import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tinsu_shops/app/router.dart';
import 'package:tinsu_shops/core/utils/paged_result.dart';
import 'package:tinsu_shops/features/auth/domain/user_model.dart';
import 'package:tinsu_shops/features/auth/presentation/session_provider.dart';
import 'package:tinsu_shops/features/inventory/domain/inventory_movement_model.dart';
import 'package:tinsu_shops/features/inventory/presentation/screens/stock_history_screen.dart';
import 'package:tinsu_shops/features/products/domain/product_model.dart';
import 'package:tinsu_shops/features/products/presentation/screens/product_detail_screen.dart';
import 'package:tinsu_shops/l10n/app_localizations.dart';

class MockSession extends Session {
  final SessionState _initial;
  MockSession(this._initial);

  @override
  SessionState build() => _initial;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InventoryMovementModel', () {
    test('serializes and deserializes correctly', () {
      final json = {
        'id': 'mov-1',
        'shop_id': 'shop-1',
        'product_id': 'prod-1',
        'type': 'RESTOCK',
        'quantity': 25,
        'reason': 'Shipment arrived',
        'created_by_type': 'OWNER',
        'created_by_id': 'owner-1',
        'created_at': '2026-09-17T10:00:00.000Z',
      };

      final model = InventoryMovementModel.fromJson(json);
      expect(model.id, 'mov-1');
      expect(model.shopId, 'shop-1');
      expect(model.productId, 'prod-1');
      expect(model.type, 'RESTOCK');
      expect(model.quantity, 25);
      expect(model.reason, 'Shipment arrived');
      expect(model.createdByType, 'OWNER');
      expect(model.createdById, 'owner-1');
      expect(model.isPositive, true);
      expect(model.quantityDisplay, '+25');

      final serialized = model.toJson();
      expect(serialized['id'], 'mov-1');
      expect(serialized['shop_id'], 'shop-1');
      expect(serialized['type'], 'RESTOCK');
      expect(serialized['quantity'], 25);
      expect(serialized['reason'], 'Shipment arrived');
    });

    test('negative movement has correct display', () {
      final model = InventoryMovementModel(
        id: 'mov-2',
        shopId: 'shop-1',
        productId: 'prod-1',
        type: 'SALE',
        quantity: -5,
        createdByType: 'WORKER',
        createdAt: DateTime.now(),
      );

      expect(model.isPositive, false);
      expect(model.quantityDisplay, '-5');
    });
  });

  group('Stock router configuration', () {
    test('contains stock-history route', () {
      final container = ProviderContainer(
        overrides: [
          sessionProvider.overrideWith(
            () => MockSession(
              const SessionState.authenticated(
                user: UserModel(id: '1', name: 'Owner', role: UserRole.owner),
                currentShopId: 'shop-1',
              ),
            ),
          ),
        ],
      );
      final router = container.read(routerProvider);
      final routes = router.configuration.routes;

      bool hasStockHistory = false;
      for (final r in routes) {
        if (r is GoRoute && r.path == '/owner/products/:id/stock-history') {
          hasStockHistory = true;
        }
      }
      expect(hasStockHistory, isTrue);
    });
  });

  group('StockHistoryScreen widget test', () {
    testWidgets('renders empty state when there are no movements', (tester) async {
      const testProduct = ProductModel(
        id: 'p-1',
        shopId: 's-1',
        name: 'Injera',
        sellingPrice: '20',
        stockQuantity: 10,
      );

      const pagedEmpty = PagedResult<InventoryMovementModel>(
        items: [],
        total: 0,
        page: 1,
        totalPages: 0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionProvider.overrideWith(
              () => MockSession(
                const SessionState.authenticated(
                  user: UserModel(id: '1', name: 'Owner', role: UserRole.owner),
                  currentShopId: 's-1',
                ),
              ),
            ),
            productDetailProvider('s-1', 'p-1').overrideWith((ref) async => testProduct),
            productMovementsProvider('s-1', 'p-1').overrideWith((ref) async => pagedEmpty),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: StockHistoryScreen(productId: 'p-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Injera'), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    testWidgets('renders movement list items', (tester) async {
      const testProduct = ProductModel(
        id: 'p-1',
        shopId: 's-1',
        name: 'Injera',
        sellingPrice: '20',
        stockQuantity: 50,
      );

      final movements = [
        InventoryMovementModel(
          id: 'm-1',
          shopId: 's-1',
          productId: 'p-1',
          type: 'RESTOCK',
          quantity: 40,
          reason: 'Supplier bakery delivered',
          createdByType: 'OWNER',
          createdAt: DateTime(2026, 9, 17, 8, 30),
        ),
        InventoryMovementModel(
          id: 'm-2',
          shopId: 's-1',
          productId: 'p-1',
          type: 'SALE',
          quantity: -2,
          reason: null,
          createdByType: 'WORKER',
          createdAt: DateTime(2026, 9, 17, 9, 15),
        ),
      ];

      final pagedResult = PagedResult<InventoryMovementModel>(
        items: movements,
        total: 2,
        page: 1,
        totalPages: 1,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionProvider.overrideWith(
              () => MockSession(
                const SessionState.authenticated(
                  user: UserModel(id: '1', name: 'Owner', role: UserRole.owner),
                  currentShopId: 's-1',
                ),
              ),
            ),
            productDetailProvider('s-1', 'p-1').overrideWith((ref) async => testProduct),
            productMovementsProvider('s-1', 'p-1').overrideWith((ref) async => pagedResult),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: StockHistoryScreen(productId: 'p-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('+40'), findsOneWidget);
      expect(find.text('-2'), findsOneWidget);
      expect(find.text('Supplier bakery delivered'), findsOneWidget);
    });
  });
}
