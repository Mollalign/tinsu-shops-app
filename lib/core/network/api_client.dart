import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/api_constants.dart';
import '../errors/app_error.dart';
import '../storage/secure_storage.dart';
import '../../features/auth/presentation/session_provider.dart';

part 'api_client.g.dart';

/// Central Dio client with auth injection and error normalization.
@riverpod
Dio dio(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  final d = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );

  d.interceptors.add(AuthInterceptor(storage: storage, dio: d));
  d.interceptors.add(
    ErrorInterceptor(
      dio: d,
      onRefreshToken: () => attemptTokenRefresh(storage),
      onSessionExpired: () {
        ref.read(sessionProvider.notifier).expireSession();
      },
    ),
  );

  return d;
}

/// Attempts a token refresh using the stored refresh token.
///
/// Uses a bare [Dio] (no interceptors) to avoid recursive interception loops.
/// Returns `true` and saves the new tokens on success, `false` on any failure.
///
/// Exposed at the library level so it can be tested independently.
Future<bool> attemptTokenRefresh(SecureStorage storage) async {
  final refreshToken = await storage.getRefreshToken();
  if (refreshToken == null) return false;

  final refreshDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );

  try {
    final res = await refreshDio.post(
      ApiConstants.refresh,
      data: {'refresh_token': refreshToken},
    );
    final newAccess = res.data['access_token'] as String?;
    if (newAccess == null) return false;
    await storage.saveAccessToken(newAccess);
    // Persist the rotated refresh token when the server provides one
    final newRefresh = res.data['refresh_token'] as String?;
    if (newRefresh != null) await storage.saveRefreshToken(newRefresh);
    return true;
  } catch (_) {
    return false;
  }
}

/// Injects the Authorization header from secure storage
class AuthInterceptor extends Interceptor {
  final SecureStorage storage;
  final Dio dio;

  AuthInterceptor({required this.storage, required this.dio});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Handles 401 responses by attempting a token refresh before giving up.
///
/// On a 401 (non-login, non-refresh, not already retried):
///   1. Calls [onRefreshToken]. Multiple concurrent 401s share one refresh
///      attempt via an internal [Completer].
///   2. If refresh succeeds → retries the original request (which
///      [AuthInterceptor] will now send with the fresh access token).
///   3. If refresh fails → calls [onSessionExpired] and rejects.
///
/// Also maps all [DioException]s to typed [AppError]s.
class ErrorInterceptor extends Interceptor {
  /// The parent [Dio] instance — used to retry the original request after a
  /// successful token refresh.  May be `null` in unit tests that only verify
  /// error-mapping behaviour.
  final Dio? dio;

  /// Called once per 401 cycle (even when multiple requests fail concurrently).
  /// Should return `true` when a fresh access token has been saved to storage.
  final Future<bool> Function()? onRefreshToken;

  /// Called when token refresh fails or is unavailable.
  final void Function()? onSessionExpired;

  ErrorInterceptor({
    this.dio,
    this.onRefreshToken,
    this.onSessionExpired,
  });

  // Serialises concurrent refresh attempts: only one network call is made and
  // all waiting requests share the result.
  Completer<bool>? _refreshCompleter;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    // Endpoints that must never trigger automatic token refresh
    final isAuthEndpoint = path.contains('/auth/owner/login') ||
        path.contains('/auth/worker/login') ||
        path.contains('/auth/refresh');

    // Prevent infinite retry loops
    final alreadyRetried = err.requestOptions.extra['_retried'] == true;

    if (statusCode == 401 && !isAuthEndpoint && !alreadyRetried) {
      final refreshed = await _doRefresh();

      if (refreshed && dio != null) {
        // Mark so that a second 401 on the retry does not loop
        err.requestOptions.extra['_retried'] = true;
        try {
          // AuthInterceptor.onRequest will inject the new access token
          final response = await dio!.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (_) {
          // Retry itself failed — fall through to expire session
        }
      }

      onSessionExpired?.call();
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: _mapError(err),
        type: err.type,
        response: err.response,
      ),
    );
  }

  /// Executes a single refresh attempt, queuing concurrent callers.
  Future<bool> _doRefresh() async {
    if (_refreshCompleter != null) {
      // Another coroutine has already started a refresh; wait for its result
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      final result = await (onRefreshToken?.call() ?? Future.value(false));
      _refreshCompleter!.complete(result);
      return result;
    } catch (_) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  AppError _mapError(DioException err) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return const NetworkError();
    }

    final statusCode = err.response?.statusCode;
    final detail = err.response?.data?['detail'];

    if (statusCode == 401) return const UnauthorizedError();
    if (statusCode == 404) return const NotFoundError();

    // Check for domain errors from backend
    // FastAPI AppException returns: {"detail": {"code": "...", "message": "..."}}
    if (detail is Map) {
      final code = detail['code'] as String?;
      final message = detail['message'] as String?;
      if (code == 'INSUFFICIENT_STOCK' ||
          (message != null && message.toLowerCase().contains('insufficient stock'))) {
        return InsufficientStockError(
            productName: message ?? 'Product', available: 0);
      }
      if (message != null) return ValidationError(message);
    } else if (detail is String) {
      if (detail.contains('INSUFFICIENT_STOCK') ||
          detail.toLowerCase().contains('insufficient stock')) {
        return const InsufficientStockError(productName: 'Product', available: 0);
      }
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        return ValidationError(detail);
      }
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerError(statusCode);
    }

    return GenericError(err.message ?? 'Unexpected error');
  }
}

/// Extracts typed [AppError] from a [DioException]
AppError extractError(Object err) {
  if (err is DioException && err.error is AppError) {
    return err.error as AppError;
  }
  if (err is AppError) return err;
  return const GenericError();
}
