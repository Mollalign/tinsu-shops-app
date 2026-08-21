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
  const factory SessionState.unauthenticated() = _Unauthenticated;
}

@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  SessionState build() => const SessionState.initial();

  /// Attempt to restore a previous session from secure storage
  Future<void> restore() async {
    state = const SessionState.loading();
    final storage = ref.read(secureStorageProvider);
    final token = await storage.getAccessToken();
    if (token == null) {
      state = const SessionState.unauthenticated();
      return;
    }
    final session = await storage.getSession();
    final roleStr = session['role'];
    if (roleStr == null || session['userId'] == null) {
      state = const SessionState.unauthenticated();
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

  Future<void> login(AuthResponse auth) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.saveSession(auth);
    state = SessionState.authenticated(
      user: auth.user,
      currentShopId: auth.user.shopId,
    );
  }

  void setCurrentShop(String shopId) {
    final current = state;
    if (current is _Authenticated) {
      state = current.copyWith(currentShopId: shopId);
    }
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.clearSession();
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
