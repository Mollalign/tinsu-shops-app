import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tinsu_shops/app/locale_provider.dart';
import 'package:tinsu_shops/core/storage/preferences.dart';
import 'package:tinsu_shops/core/widgets/language_toggle.dart';
import 'package:tinsu_shops/features/workers/data/workers_repository.dart';

class MockDioAdapter implements HttpClientAdapter {
  RequestOptions? lastRequestOptions;
  dynamic lastRequestBody;
  ResponseBody? responseToReturn;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequestOptions = options;
    lastRequestBody = options.data;
    return responseToReturn ??
        ResponseBody.fromString(
          '{"worker": {"id": "w1", "name": "Abebe", "role": "worker", "shop_id": "s1", "is_active": true}, "pin": "1234"}',
          200,
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

  group('Localization and Preferences', () {
    test('Preferences defaults to Amharic (am) when empty', () async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = Preferences(sp);

      expect(prefs.language, 'am');
    });

    test('Preferences persists language changes', () async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = Preferences(sp);

      await prefs.setLanguage('en');
      expect(prefs.language, 'en');

      await prefs.setLanguage('am');
      expect(prefs.language, 'am');
    });

    test('LocaleNotifier defaults to Amharic (am)', () async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = Preferences(sp);

      final container = ProviderContainer(
        overrides: [
          preferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final locale = container.read(localeNotifierProvider);
      expect(locale.languageCode, 'am');
    });

    test('LocaleNotifier setLocale updates state and preferences', () async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = Preferences(sp);

      final container = ProviderContainer(
        overrides: [
          preferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      container.read(localeNotifierProvider.notifier).setLocale(const Locale('en'));
      expect(container.read(localeNotifierProvider).languageCode, 'en');
      expect(prefs.language, 'en');

      container.read(localeNotifierProvider.notifier).setLocale(const Locale('am'));
      expect(container.read(localeNotifierProvider).languageCode, 'am');
      expect(prefs.language, 'am');
    });
  });

  group('LanguageToggle Widget', () {
    testWidgets('Renders Amharic and English options and handles taps',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final sp = await SharedPreferences.getInstance();
      final prefs = Preferences(sp);

      final container = ProviderContainer(
        overrides: [
          preferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: Center(
                child: LanguageToggle(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('አማርኛ'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(container.read(localeNotifierProvider).languageCode, 'am');

      // Tap English
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(container.read(localeNotifierProvider).languageCode, 'en');
      expect(prefs.language, 'en');

      // Tap Amharic
      await tester.tap(find.text('አማርኛ'));
      await tester.pumpAndSettle();

      expect(container.read(localeNotifierProvider).languageCode, 'am');
      expect(prefs.language, 'am');
    });
  });

  group('WorkersRepository Credential Management', () {
    test('createWorker sends pin when provided manually', () async {
      final mockAdapter = MockDioAdapter();
      final dio = Dio()..httpClientAdapter = mockAdapter;
      final repo = WorkersRepository(dio: dio);

      await repo.createWorker(
        shopId: 's1',
        name: 'Abebe',
        pin: '5678',
      );

      expect(mockAdapter.lastRequestBody, isNotNull);
      expect(mockAdapter.lastRequestBody['name'], 'Abebe');
      expect(mockAdapter.lastRequestBody['pin'], '5678');
    });

    test('createWorker sends null pin when auto-generated', () async {
      final mockAdapter = MockDioAdapter();
      final dio = Dio()..httpClientAdapter = mockAdapter;
      final repo = WorkersRepository(dio: dio);

      await repo.createWorker(
        shopId: 's1',
        name: 'Abebe',
        pin: null,
      );

      expect(mockAdapter.lastRequestBody, isNotNull);
      expect(mockAdapter.lastRequestBody['name'], 'Abebe');
      expect(mockAdapter.lastRequestBody['pin'], isNull);
    });

    test('resetPin sends new_pin when provided manually', () async {
      final mockAdapter = MockDioAdapter();
      final dio = Dio()..httpClientAdapter = mockAdapter;
      final repo = WorkersRepository(dio: dio);

      await repo.resetPin(
        's1',
        'w1',
        newPin: '9999',
      );

      expect(mockAdapter.lastRequestBody, isNotNull);
      expect(mockAdapter.lastRequestBody['new_pin'], '9999');
    });

    test('resetPin sends null new_pin when auto-generated', () async {
      final mockAdapter = MockDioAdapter();
      final dio = Dio()..httpClientAdapter = mockAdapter;
      final repo = WorkersRepository(dio: dio);

      await repo.resetPin(
        's1',
        'w1',
        newPin: null,
      );

      expect(mockAdapter.lastRequestBody, isNotNull);
      expect(mockAdapter.lastRequestBody['new_pin'], isNull);
    });
  });
}
