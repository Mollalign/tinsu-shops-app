import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../domain/user_model.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(
      dio: ref.watch(dioProvider),
      storage: ref.watch(secureStorageProvider),
    );

class AuthRepository {
  final Dio _dio;
  final SecureStorage _storage;

  AuthRepository({required Dio dio, required SecureStorage storage})
      : _dio = dio,
        _storage = storage;

  Future<AuthResponse> ownerLogin({
    required String phone,
    required String pin,
  }) async {
    try {
      final res = await _dio.post(ApiConstants.ownerLogin, data: {
        'phone': phone,
        'pin': pin,
      });
      return AuthResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<AuthResponse> workerLogin({
    required String shopId,
    required String workerId,
    required String pin,
  }) async {
    try {
      final res = await _dio.post(ApiConstants.workerLogin, data: {
        'shop_id': shopId,
        'worker_id': workerId,
        'pin': pin,
      });
      return AuthResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<void> saveSession(AuthResponse auth, {String? ownerPhone}) async {
    await _storage.saveAccessToken(auth.accessToken);
    await _storage.saveSession(
      userId: auth.user.id,
      role: auth.user.role.name,
      name: auth.user.name,
      shopId: auth.user.shopId,
    );
    // Persist phone for PIN-only re-login on future launches.
    // PIN is intentionally NOT stored.
    if (ownerPhone != null && ownerPhone.isNotEmpty) {
      await _storage.saveOwnerPhone(ownerPhone);
    }
  }

  /// Returns the remembered owner phone, if any.
  Future<String?> getRememberedPhone() => _storage.getOwnerPhone();

  /// Clears access token + session metadata.
  /// Keeps the remembered phone so "Welcome back" still works.
  Future<void> clearSession() => _storage.clearSession();

  /// Full wipe — used by "Use another account".
  Future<void> clearAll() => _storage.clearAll();

  /// Change the owner's PIN.
  /// Sends [currentPin] for server-side verification; stores hash of [newPin].
  /// Never logs or persists either PIN locally.
  Future<void> changeOwnerPin({
    required String currentPin,
    required String newPin,
  }) async {
    try {
      await _dio.patch(ApiConstants.ownerChangePin, data: {
        'current_pin': currentPin,
        'new_pin': newPin,
      });
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}
