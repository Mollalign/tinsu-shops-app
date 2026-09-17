import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tinsu_shops/app/router.dart';
import 'package:tinsu_shops/features/auth/domain/user_model.dart';
import 'package:tinsu_shops/features/auth/presentation/session_provider.dart';
import 'package:tinsu_shops/features/inventory/domain/stock_analytics_model.dart';
import 'package:tinsu_shops/features/inventory/presentation/screens/stock_analytics_screen.dart';
import 'package:tinsu_shops/features/sales/domain/analytics_model.dart';
import 'package:tinsu_shops/l10n/app_localizations.dart';

class MockSession extends Session {
  final SessionState _initial;
  MockSession(this._initial);

  @override
  SessionState build() => _initial;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StockAnalyticsModel', () {
    test('StockAnalytics serializes and deserializes correctly', () {
      final json = {
        'period': 'weekly',
        'start_date': '2026-09-11',
        'end_date': '2026-09-17',
        'restocked_units': 120,
        'sold_units': 85,
        'current_stock': 350,
        'data': [
          {
            'date': '2026-09-11',
            'restocked_units': 50,
            'sold_units': 30,
          },
          {
            'date': '2026-09-12',
            'restocked_units': 70,
            'sold_units': 55,
          },
        ],
        'top_restocked': [
          {
            'product_id': 'p-1',
            'product_name': 'Coca-Cola',
            'quantity': 70,
          }
        ],
        'top_sold': [
          {
            'product_id': 'p-1',
            'product_name': 'Coca-Cola',
            'quantity': 55,
          }
        ],
      };

      final model = StockAnalytics.fromJson(json);
      expect(model.period, 'weekly');
      expect(model.startDate, '2026-09-11');
      expect(model.endDate, '2026-09-17');
      expect(model.restockedUnits, 120);
      expect(model.soldUnits, 85);
      expect(model.currentStock, 350);
      expect(model.data.length, 2);
      expect(model.data[0].date, '2026-09-11');
      expect(model.data[0].restockedUnits, 50);
      expect(model.data[0].soldUnits, 30);
      expect(model.topRestocked.length, 1);
      expect(model.topRestocked[0].productName, 'Coca-Cola');
      expect(model.topRestocked[0].quantity, 70);
      expect(model.topSold.length, 1);
      expect(model.topSold[0].productName, 'Coca-Cola');
      expect(model.topSold[0].quantity, 55);

      final outputJson = model.toJson();
      expect(outputJson['period'], 'weekly');
      expect(outputJson['restocked_units'], 120);
      expect(outputJson['sold_units'], 85);
      expect(outputJson['current_stock'], 350);
    });

    test('ProductStockAnalytics serializes and deserializes correctly', () {
      final json = {
        'product_id': 'p-1',
        'product_name': 'Coca-Cola',
        'period': 'monthly',
        'start_date': '2026-09-01',
        'end_date': '2026-09-30',
        'current_stock': 50,
        'restocked_units': 200,
        'sold_units': 150,
        'data': [
          {
            'date': '2026-09-17',
            'restocked_units': 50,
            'sold_units': 20,
          },
        ],
      };

      final model = ProductStockAnalytics.fromJson(json);
      expect(model.productId, 'p-1');
      expect(model.productName, 'Coca-Cola');
      expect(model.currentStock, 50);
      expect(model.restockedUnits, 200);
      expect(model.soldUnits, 150);
      expect(model.data.length, 1);
    });
  });

  group('StockAnalytics Navigation & Access', () {
    test('Owner redirect evaluation permits /owner/stock-analytics when shop is selected', () {
      const user = UserModel(id: 'owner-1', name: 'Owner', role: UserRole.owner);
      const session = SessionState.authenticated(user: user, currentShopId: 'shop-1');

      final redirect = evaluateRedirect(
        path: '/owner/stock-analytics',
        session: session,
      );
      expect(redirect, isNull);
    });

    test('Worker redirect evaluation blocks /owner/stock-analytics', () {
      const user = UserModel(id: 'worker-1', name: 'Worker', role: UserRole.worker);
      const session = SessionState.authenticated(user: user, currentShopId: 'shop-1');

      final redirect = evaluateRedirect(
        path: '/owner/stock-analytics',
        session: session,
      );
      expect(redirect, '/worker/sell');
    });
  });

  group('StockAnalyticsScreen Widget', () {
    testWidgets('renders summary cards, metric items, and top products', (tester) async {
      final mockData = StockAnalytics(
        period: 'weekly',
        startDate: '2026-09-11',
        endDate: '2026-09-17',
        restockedUnits: 120,
        soldUnits: 85,
        currentStock: 350,
        data: const [
          StockAnalyticsDataPoint(date: '2026-09-15', restockedUnits: 50, soldUnits: 30),
          StockAnalyticsDataPoint(date: '2026-09-16', restockedUnits: 70, soldUnits: 55),
        ],
        topRestocked: const [
          TopStockItem(productId: 'p-1', productName: 'Coca-Cola', quantity: 70),
        ],
        topSold: const [
          TopStockItem(productId: 'p-1', productName: 'Coca-Cola', quantity: 55),
        ],
      );

      const user = UserModel(id: 'owner-1', name: 'Owner', role: UserRole.owner);
      final sessionState = SessionState.authenticated(user: user, currentShopId: 'shop-1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionProvider.overrideWith(() => MockSession(sessionState)),
            shopStockAnalyticsProvider('shop-1', AnalyticsPeriod.weekly, '2026-09-17')
                .overrideWith((ref) => Future.value(mockData)),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: StockAnalyticsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Current stock should display
      expect(find.text('350'), findsOneWidget);
      // Restocked display with +
      expect(find.text('+120'), findsOneWidget);
      // Sold display with -
      expect(find.text('-85'), findsOneWidget);

      // Period chips should be present
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('7 Days'), findsOneWidget);
      expect(find.text('30 Days'), findsOneWidget);
      expect(find.text('Year'), findsOneWidget);

      // Top products should display Coca-Cola
      expect(find.text('Coca-Cola'), findsWidgets);
      expect(find.text('+70'), findsOneWidget);
      expect(find.text('-55'), findsOneWidget);
    });

    testWidgets('renders empty placeholder when no movements in period', (tester) async {
      final mockEmpty = StockAnalytics(
        period: 'weekly',
        startDate: '2026-09-11',
        endDate: '2026-09-17',
        restockedUnits: 0,
        soldUnits: 0,
        currentStock: 0,
        data: const [],
        topRestocked: const [],
        topSold: const [],
      );

      const user = UserModel(id: 'owner-1', name: 'Owner', role: UserRole.owner);
      final sessionState = SessionState.authenticated(user: user, currentShopId: 'shop-1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionProvider.overrideWith(() => MockSession(sessionState)),
            shopStockAnalyticsProvider('shop-1', AnalyticsPeriod.weekly, '2026-09-17')
                .overrideWith((ref) => Future.value(mockEmpty)),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: StockAnalyticsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('0'), findsWidgets);
      expect(find.text('No stock movement in this period.'), findsWidgets);
    });
  });
}
