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
      onSessionExpired: () {
        ref.read(sessionProvider.notifier).expireSession();
      },
    ),
  );

  return d;
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

/// Maps Dio exceptions to typed [AppError]
class ErrorInterceptor extends Interceptor {
  final void Function()? onSessionExpired;

  ErrorInterceptor({this.onSessionExpired});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    // Check if this is a 401 on an authenticated request.
    // Exclude public login endpoints where 401 represents invalid credentials.
    final isLoginEndpoint = path.contains('/auth/owner/login') ||
        path.contains('/auth/worker/login');

    if (statusCode == 401 && !isLoginEndpoint) {
      onSessionExpired?.call();
    }

    final error = _mapError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: error,
        type: err.type,
        response: err.response,
      ),
    );
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
