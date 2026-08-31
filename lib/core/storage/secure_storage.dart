import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/app_constants.dart';

part 'secure_storage.g.dart';

@riverpod
SecureStorage secureStorage(Ref ref) => SecureStorage();

/// Wraps FlutterSecureStorage with typed access methods.
class SecureStorage {
  static const _opts = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _opts,
  );

  // ── Token ─────────────────────────────────────────────────────────────────
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: AppConstants.keyAccessToken, value: token);

  Future<String?> getAccessToken() =>
      _storage.read(key: AppConstants.keyAccessToken);

  Future<void> deleteAccessToken() =>
      _storage.delete(key: AppConstants.keyAccessToken);

  // ── Session ───────────────────────────────────────────────────────────────
  Future<void> saveSession({
    required String userId,
    required String role,
    required String name,
    String? shopId,
  }) async {
    await Future.wait([
      _storage.write(key: AppConstants.keyUserId, value: userId),
      _storage.write(key: AppConstants.keyUserRole, value: role),
      _storage.write(key: AppConstants.keyUserName, value: name),
      if (shopId != null)
        _storage.write(key: AppConstants.keyShopId, value: shopId),
    ]);
  }

  Future<Map<String, String?>> getSession() async {
    final results = await Future.wait([
      _storage.read(key: AppConstants.keyUserId),
      _storage.read(key: AppConstants.keyUserRole),
      _storage.read(key: AppConstants.keyUserName),
      _storage.read(key: AppConstants.keyShopId),
    ]);
    return {
      'userId': results[0],
      'role': results[1],
      'name': results[2],
      'shopId': results[3],
    };
  }

  // ── Owner Phone (remembered for PIN-only re-login) ────────────────────────
  Future<void> saveOwnerPhone(String phone) =>
      _storage.write(key: AppConstants.keyOwnerPhone, value: phone);

  Future<String?> getOwnerPhone() =>
      _storage.read(key: AppConstants.keyOwnerPhone);

  Future<void> deleteOwnerPhone() =>
      _storage.delete(key: AppConstants.keyOwnerPhone);

  // ── Clear ─────────────────────────────────────────────────────────────────
  /// Full logout — removes token + session metadata but keeps the remembered
  /// owner phone so the "Welcome back" screen can be shown on next launch.
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: AppConstants.keyAccessToken),
      _storage.delete(key: AppConstants.keyUserId),
      _storage.delete(key: AppConstants.keyUserRole),
      _storage.delete(key: AppConstants.keyUserName),
      _storage.delete(key: AppConstants.keyShopId),
    ]);
  }

  /// Full wipe — removes ALL data including remembered phone.
  /// Used by "Use another account".
  Future<void> clearAll() => _storage.deleteAll();
}
