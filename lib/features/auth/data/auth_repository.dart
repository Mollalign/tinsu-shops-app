import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_error.dart';
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

  Future<void> saveSession(AuthResponse auth) async {
    await _storage.saveAccessToken(auth.accessToken);
    await _storage.saveSession(
      userId: auth.user.id,
      role: auth.user.role.name,
      name: auth.user.name,
      shopId: auth.user.shopId,
    );
  }

  Future<void> clearSession() => _storage.clearSession();
}
