import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tinsu_shops/app/locale_provider.dart';
import 'package:tinsu_shops/app/router.dart';
import 'package:tinsu_shops/core/network/api_client.dart';
import 'package:tinsu_shops/core/storage/preferences.dart';
import 'package:tinsu_shops/core/storage/secure_storage.dart';
import 'package:tinsu_shops/features/auth/data/auth_repository.dart';
import 'package:tinsu_shops/features/auth/domain/user_model.dart';
import 'package:tinsu_shops/features/auth/presentation/session_provider.dart';
import 'package:tinsu_shops/features/products/domain/product_model.dart';
import 'package:tinsu_shops/features/sales/presentation/cart_provider.dart';
import 'package:tinsu_shops/l10n/app_localizations.dart';

class FakeSecureStorage extends SecureStorage {
  String? accessToken;
  String? userId;
  String? role;
  String? name;
  String? shopId;
  String? ownerPhone;

  @override
  Future<void> saveAccessToken(String token) async => accessToken = token;

  @override
  Future<String?> getAccessToken() async => accessToken;

  @override
  Future<void> deleteAccessToken() async => accessToken = null;

  @override
  Future<void> saveSession({
    required String userId,
    required String role,
    required String name,
    String? shopId,
  }) async {
    this.userId = userId;
    this.role = role;
    this.name = name;
    this.shopId = shopId;
  }

  @override
  Future<Map<String, String?>> getSession() async => {
        'userId': userId,
        'role': role,
        'name': name,
        'shopId': shopId,
      };

  @override
  Future<void> saveOwnerPhone(String phone) async => ownerPhone = phone;

  @override
  Future<String?> getOwnerPhone() async => ownerPhone;

  @override
  Future<void> deleteOwnerPhone() async => ownerPhone = null;

  @override
  Future<void> clearSession() async {
    accessToken = null;
    userId = null;
    role = null;
    name = null;
    shopId = null;
  }

  @override
  Future<void> clearAll() async {
    await clearSession();
    ownerPhone = null;
  }
}

class FakeHttpAdapter implements HttpClientAdapter {
  final int statusCode;
  final dynamic responseBody;

  FakeHttpAdapter({required this.statusCode, this.responseBody = const {}});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      responseBody is String ? responseBody : '{"detail": "error"}',
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ErrorInterceptor Session Expiration Detection', () {
    test('401 on authenticated endpoint triggers onSessionExpired', () async {
      bool expiredCalled = false;
      final dio = Dio()..httpClientAdapter = FakeHttpAdapter(statusCode: 401);
      dio.interceptors.add(
        ErrorInterceptor(onSessionExpired: () => expiredCalled = true),
      );

      try {
        await dio.get(
          'https://api.tinsushops.com/api/v1/products',
          options: Options(headers: {'Authorization': 'Bearer test-token'}),
        );
      } catch (_) {}

      expect(expiredCalled, isTrue);
    });

    test('401 on owner login endpoint does NOT trigger onSessionExpired',
        () async {
      bool expiredCalled = false;
      final dio = Dio()..httpClientAdapter = FakeHttpAdapter(statusCode: 401);
      dio.interceptors.add(
        ErrorInterceptor(onSessionExpired: () => expiredCalled = true),
      );

      try {
        await dio.post('https://api.tinsushops.com/api/v1/auth/owner/login');
      } catch (_) {}

      expect(expiredCalled, isFalse);
    });

    test('401 on worker login endpoint does NOT trigger onSessionExpired',
        () async {
      bool expiredCalled = false;
      final dio = Dio()..httpClientAdapter = FakeHttpAdapter(statusCode: 401);
      dio.interceptors.add(
        ErrorInterceptor(onSessionExpired: () => expiredCalled = true),
      );

      try {
        await dio.post('https://api.tinsushops.com/api/v1/auth/worker/login');
      } catch (_) {}

      expect(expiredCalled, isFalse);
    });

    test('Non-401 error does NOT trigger onSessionExpired', () async {
      bool expiredCalled = false;
      final dio = Dio()..httpClientAdapter = FakeHttpAdapter(statusCode: 404);
      dio.interceptors.add(
        ErrorInterceptor(onSessionExpired: () => expiredCalled = true),
      );

      try {
        await dio.get('https://api.tinsushops.com/api/v1/products');
      } catch (_) {}

      expect(expiredCalled, isFalse);
    });
  });

  group('Session Expiration State Management', () {
    late FakeSecureStorage fakeStorage;
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = Preferences(sp);

      fakeStorage = FakeSecureStorage();
      container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(fakeStorage),
          preferencesProvider.overrideWithValue(prefs),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('Owner session expiration clears tokens and marks session expired',
        () async {
      final sessionNotifier = container.read(sessionProvider.notifier);

      // Set up authenticated owner session
      await fakeStorage.saveAccessToken('owner-token');
      await fakeStorage.saveOwnerPhone('0911223344');
      await fakeStorage.saveSession(
        userId: 'owner-1',
        role: 'owner',
        name: 'Abebe Owner',
        shopId: 'shop-1',
      );

      await sessionNotifier.restore();
      expect(sessionNotifier.isOwner, isTrue);

      // Trigger automatic session expiration
      await sessionNotifier.expireSession();

      final state = container.read(sessionProvider);
      state.maybeWhen(
        unauthenticated: (phone, name, isSessionExpired, lastRole) {
          expect(isSessionExpired, isTrue);
          expect(lastRole, UserRole.owner);
          expect(phone, '0911223344');
          expect(name, 'Abebe Owner');
        },
        orElse: () => fail('Expected unauthenticated state'),
      );

      // Access token must be cleared from storage
      expect(await fakeStorage.getAccessToken(), isNull);
      // Stored session metadata cleared
      final s = await fakeStorage.getSession();
      expect(s['userId'], isNull);
      // Remembered phone preserved for quick login
      expect(await fakeStorage.getOwnerPhone(), '0911223344');
    });

    test(
        'Worker session expiration clears cart, tokens, and does not set owner phone',
        () async {
      final sessionNotifier = container.read(sessionProvider.notifier);

      // Set up authenticated worker session
      await fakeStorage.saveAccessToken('worker-token');
      await fakeStorage.saveSession(
        userId: 'worker-1',
        role: 'worker',
        name: 'Chala Worker',
        shopId: 'shop-1',
      );

      await sessionNotifier.restore();
      expect(sessionNotifier.isWorker, isTrue);

      // Add item to cart
      final cartNotifier = container.read(cartProvider.notifier);
      cartNotifier.addProduct(
        const ProductModel(
          id: 'p1',
          shopId: 'shop-1',
          name: 'Bread',
          sellingPrice: '15.00',
          stockQuantity: 10,
        ),
      );
      expect(container.read(cartProvider).items.isNotEmpty, isTrue);

      // Trigger automatic session expiration
      await sessionNotifier.expireSession();

      final state = container.read(sessionProvider);
      state.maybeWhen(
        unauthenticated: (phone, name, isSessionExpired, lastRole) {
          expect(isSessionExpired, isTrue);
          expect(lastRole, UserRole.worker);
          expect(phone, isNull);
        },
        orElse: () => fail('Expected unauthenticated state'),
      );

      // Cart must be cleared
      expect(container.read(cartProvider).items.isEmpty, isTrue);
      // Access token cleared
      expect(await fakeStorage.getAccessToken(), isNull);
    });

    test('Concurrent expireSession calls are idempotent', () async {
      final sessionNotifier = container.read(sessionProvider.notifier);
      await fakeStorage.saveAccessToken('owner-token');
      await sessionNotifier.login(
        const AuthResponse(
          accessToken: 'owner-token',
          tokenType: 'bearer',
          user: UserModel(
            id: 'o1',
            role: UserRole.owner,
            name: 'Abebe',
          ),
        ),
        ownerPhone: '0911223344',
      );

      // Call expireSession multiple times simultaneously
      await Future.wait([
        sessionNotifier.expireSession(),
        sessionNotifier.expireSession(),
        sessionNotifier.expireSession(),
      ]);

      final state = container.read(sessionProvider);
      state.maybeWhen(
        unauthenticated: (_, __, isSessionExpired, lastRole) {
          expect(isSessionExpired, isTrue);
          expect(lastRole, UserRole.owner);
        },
        orElse: () => fail('Expected unauthenticated state'),
      );
    });

    test('clearSessionExpiredFlag resets flag to false', () async {
      final sessionNotifier = container.read(sessionProvider.notifier);
      await sessionNotifier.expireSession();

      sessionNotifier.clearSessionExpiredFlag();

      final state = container.read(sessionProvider);
      state.maybeWhen(
        unauthenticated: (_, __, isSessionExpired, ___) {
          expect(isSessionExpired, isFalse);
        },
        orElse: () => fail('Expected unauthenticated state'),
      );
    });
  });

  group('Router Redirection on Session Expiration', () {
    test(
        'Unauthenticated Owner on protected route with phone redirects to /owner/quick-login',
        () {
      const session = SessionState.unauthenticated(
        rememberedPhone: '0911223344',
        rememberedName: 'Abebe',
        isSessionExpired: true,
        lastRole: UserRole.owner,
      );

      // On protected owner routes
      expect(
        evaluateRedirect(path: '/owner/products', session: session),
        '/owner/quick-login',
      );
      expect(
        evaluateRedirect(path: '/owner/dashboard', session: session),
        '/owner/quick-login',
      );
      expect(
        evaluateRedirect(path: '/owner/settings', session: session),
        '/owner/quick-login',
      );
    });

    test(
        'Unauthenticated Owner on protected route without phone redirects to /login',
        () {
      const session = SessionState.unauthenticated(
        rememberedPhone: null,
        isSessionExpired: true,
        lastRole: UserRole.owner,
      );

      expect(
        evaluateRedirect(path: '/owner/products', session: session),
        '/login',
      );
    });

    test('Unauthenticated Worker on protected route redirects to /worker/select',
        () {
      const session = SessionState.unauthenticated(
        rememberedPhone: null,
        isSessionExpired: true,
        lastRole: UserRole.worker,
      );

      // On worker sell
      expect(
        evaluateRedirect(path: '/worker/sell', session: session),
        '/worker/select',
      );
      // On worker cart
      expect(
        evaluateRedirect(path: '/worker/cart', session: session),
        '/worker/select',
      );
      // On worker sale complete
      expect(
        evaluateRedirect(path: '/worker/sale-complete', session: session),
        '/worker/select',
      );
    });

    test('Public routes allow navigation without redirection', () {
      const session = SessionState.unauthenticated(
        rememberedPhone: '0911223344',
        isSessionExpired: true,
        lastRole: UserRole.owner,
      );

      expect(evaluateRedirect(path: '/login', session: session), isNull);
      expect(
          evaluateRedirect(path: '/owner/quick-login', session: session), isNull);
      expect(
          evaluateRedirect(path: '/worker/select', session: session), isNull);
      expect(evaluateRedirect(path: '/worker/select-worker', session: session),
          isNull);
      expect(evaluateRedirect(path: '/worker/pin', session: session), isNull);
    });
  });

  group('Localized Expiration Messages', () {
    test('English localization returns expected message', () {
      final l = lookupAppLocalizations(const Locale('en'));
      expect(l.errorUnauthorized,
          'Your session has expired. Please log in again.');
    });

    test('Amharic localization returns expected message', () {
      final l = lookupAppLocalizations(const Locale('am'));
      expect(l.errorUnauthorized,
          'የመግቢያ ጊዜዎ አልቋል። እባክዎ እንደገና ይግቡ።');
    });
  });
}
