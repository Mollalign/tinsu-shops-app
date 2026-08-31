import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/storage/secure_storage.dart';
import '../data/auth_repository.dart';
import '../domain/user_model.dart';

part 'session_provider.freezed.dart';
part 'session_provider.g.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState.initial() = _Initial;
  const factory SessionState.loading() = _Loading;
  const factory SessionState.authenticated({
    required UserModel user,
    String? currentShopId,
  }) = _Authenticated;
  /// No valid session token, but a remembered phone is available
  /// so the quick-login (PIN-only) screen can be shown.
  const factory SessionState.unauthenticated({
    String? rememberedPhone,
    String? rememberedName,
  }) = _Unauthenticated;
}

@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  SessionState build() => const SessionState.initial();

  /// Attempt to restore a previous session from secure storage.
  Future<void> restore() async {
    state = const SessionState.loading();
    final storage = ref.read(secureStorageProvider);
    final token = await storage.getAccessToken();

    // Always try to load the remembered phone/name for the quick-login screen.
    final rememberedPhone = await storage.getOwnerPhone();

    if (token == null) {
      final session = await storage.getSession();
      state = SessionState.unauthenticated(
        rememberedPhone: rememberedPhone,
        rememberedName: session['name'],
      );
      return;
    }

    final session = await storage.getSession();
    final roleStr = session['role'];
    if (roleStr == null || session['userId'] == null) {
      state = SessionState.unauthenticated(
        rememberedPhone: rememberedPhone,
        rememberedName: session['name'],
      );
      return;
    }

    final role = roleStr == 'owner' ? UserRole.owner : UserRole.worker;
    state = SessionState.authenticated(
      user: UserModel(
        id: session['userId']!,
        role: role,
        name: session['name'] ?? '',
        shopId: session['shopId'],
      ),
      currentShopId: session['shopId'],
    );
  }

  /// Called after a successful login. Pass [ownerPhone] to persist it for
  /// PIN-only re-login on future launches (owners only).
  Future<void> login(AuthResponse auth, {String? ownerPhone}) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.saveSession(auth, ownerPhone: ownerPhone);
    state = SessionState.authenticated(
      user: auth.user,
      currentShopId: auth.user.shopId,
    );
  }

  void setCurrentShop(String shopId) {
    final current = state;
    if (current is _Authenticated) {
      state = current.copyWith(currentShopId: shopId);
      // Persist so the selection survives app restarts
      final storage = ref.read(secureStorageProvider);
      storage.saveSession(
        userId: current.user.id,
        role: current.user.role.name,
        name: current.user.name,
        shopId: shopId,
      );
    }
  }

  /// Standard logout — clears token but keeps remembered phone.
  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    final phone = await storage.getOwnerPhone();
    final session = await storage.getSession();
    await storage.clearSession();
    state = SessionState.unauthenticated(
      rememberedPhone: phone,
      rememberedName: session['name'],
    );
  }

  /// "Use another account" — wipes everything including remembered phone.
  Future<void> switchAccount() async {
    await ref.read(authRepositoryProvider).clearAll();
    state = const SessionState.unauthenticated();
  }

  UserModel? get currentUser {
    final s = state;
    if (s is _Authenticated) return s.user;
    return null;
  }

  String? get currentShopId {
    final s = state;
    if (s is _Authenticated) return s.currentShopId;
    return null;
  }

  bool get isOwner {
    final s = state;
    if (s is _Authenticated) return s.user.role == UserRole.owner;
    return false;
  }

  bool get isWorker {
    final s = state;
    if (s is _Authenticated) return s.user.role == UserRole.worker;
    return false;
  }
}
