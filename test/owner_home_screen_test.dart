import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tinsu_shops/app/theme/app_theme.dart';
import 'package:tinsu_shops/features/auth/domain/user_model.dart';
import 'package:tinsu_shops/features/auth/presentation/session_provider.dart';
import 'package:tinsu_shops/features/dashboard/domain/dashboard_model.dart';
import 'package:tinsu_shops/features/dashboard/presentation/screens/owner_dashboard_screen.dart';
import 'package:tinsu_shops/features/shops/domain/shop_model.dart';
import 'package:tinsu_shops/l10n/app_localizations.dart';

class MockSession extends Session {
  final SessionState _initial;
  MockSession(this._initial);

  @override
  SessionState build() => _initial;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockToday = TodayReport(
    date: '2026-09-17',
    totalSales: '2620.00',
    numberOfSales: 12,
    itemsSold: 34,
    lowStockCount: 2,
  );

  final mockLowStock = [
    HomeLowStockItem(
      id: 'p1',
      name: 'Coca-Cola',
      stockQuantity: 3,
      lowStockThreshold: 10,
      isOutOfStock: false,
    ),
    HomeLowStockItem(
      id: 'p2',
      name: 'Bread',
      stockQuantity: 0,
      lowStockThreshold: 5,
      isOutOfStock: true,
    ),
  ];

  final mockRecentSales = [
    HomeRecentSaleItem(
      id: 's1',
      createdAt: DateTime(2026, 9, 17, 21, 29),
      soldByName: 'Hana',
      totalAmount: '2620.00',
      itemsCount: 4,
    ),
    HomeRecentSaleItem(
      id: 's2',
      createdAt: DateTime(2026, 9, 17, 18, 36),
      soldByName: 'Abebe',
      totalAmount: '125.00',
      itemsCount: 1,
    ),
  ];

  final mockShops = [
    const ShopModel(id: 'shop-1', name: 'Main Shop', location: 'Bole'),
    const ShopModel(id: 'shop-2', name: 'Second Shop', location: 'Piazza'),
  ];

  Widget buildHomeScreen({
    required String currentShopId,
    required HomeSummary summary,
    List<ShopModel>? shops,
    Locale locale = const Locale('en'),
  }) {
    return ProviderScope(
      overrides: [
        sessionProvider.overrideWith(
          () => MockSession(
            SessionState.authenticated(
              user: const UserModel(id: 'owner-1', role: UserRole.owner, name: 'Tinsu'),
              currentShopId: currentShopId,
            ),
          ),
        ),
        shopHomeSummaryProvider(currentShopId).overrideWith((ref) => Future.value(summary)),
        dashboardShopsProvider.overrideWith((ref) => Future.value(shops ?? mockShops)),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const OwnerDashboardScreen(),
      ),
    );
  }

  group('Owner Home Screen UI & Layout', () {
    testWidgets('displays header with greeting and selected shop name', (tester) async {
      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      expect(find.text('Main Shop'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('displays today sales summary amount and stats', (tester) async {
      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      expect(find.text("Today's Sales"), findsOneWidget);
      expect(find.text('2,620 ETB'), findsWidgets);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Sales'), findsWidgets);
      expect(find.text('34'), findsOneWidget);
      expect(find.text('Items'), findsWidgets);
    });

    testWidgets('displays 4 quick action buttons', (tester) async {
      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Add Product'), findsOneWidget);
      expect(find.text('Add Stock'), findsOneWidget);
      expect(find.text('Add Worker'), findsOneWidget);
      expect(find.text('Sales History'), findsOneWidget);
    });

    testWidgets('displays low-stock products when present', (tester) async {
      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      expect(find.text('Low Stock'), findsOneWidget);
      expect(find.text('Coca-Cola'), findsOneWidget);
      expect(find.text('3 left'), findsOneWidget);
      expect(find.text('Bread'), findsOneWidget);
      expect(find.text('Out of stock'), findsOneWidget);
      expect(find.text('View all →'), findsWidgets);
    });

    testWidgets('displays encouraging empty state when low stock is empty', (tester) async {
      final summary = HomeSummary(
        today: mockToday,
        lowStock: [],
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      expect(find.text('All stock looks good'), findsOneWidget);
      expect(find.text('No products currently need restocking.'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('displays recent sales with time, seller and amount', (tester) async {
      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Recent Sales'), 200);

      expect(find.text('Recent Sales'), findsOneWidget);
      expect(find.textContaining('Hana'), findsOneWidget);
      expect(find.textContaining('Abebe'), findsOneWidget);
      expect(find.text('125 ETB'), findsOneWidget);
    });

    testWidgets('displays clean empty state when no recent sales', (tester) async {
      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: [],
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('No sales yet'), 200);

      expect(find.text('No sales yet'), findsOneWidget);
      expect(find.text('Once sales are recorded, they will appear here.'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long_outlined), findsWidgets);
    });

    testWidgets('renders without overflow on small device (360x640)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders in Amharic without error or overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(
        currentShopId: 'shop-1',
        summary: summary,
        locale: const Locale('am'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ፈጣን ተግባራት'), findsOneWidget);
      expect(find.text('የዛሬ ሽያጭ'), findsOneWidget);
      expect(find.text('ሁሉንም ይመልከቱ →'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('displays view analytics link on today sales hero card', (tester) async {
      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      expect(find.text('View analytics →'), findsOneWidget);
    });

    testWidgets('renders without overflow on tablet device (800x1280)', (tester) async {
      tester.view.physicalSize = const Size(800, 1280);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final summary = HomeSummary(
        today: mockToday,
        lowStock: mockLowStock,
        recentSales: mockRecentSales,
      );

      await tester.pumpWidget(buildHomeScreen(currentShopId: 'shop-1', summary: summary));
      await tester.pumpAndSettle();

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Add Product'), findsOneWidget);
      expect(find.text('Add Stock'), findsOneWidget);
      expect(find.text('Add Worker'), findsOneWidget);
      expect(find.text('Sales History'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
