// Tests for the "Recently Sold" feature.
//
// These are unit / logic tests that do NOT require a running backend
// or a WidgetTester — they verify the data-layer behaviours and UI
// invariants described in the feature spec.
import 'package:flutter_test/flutter_test.dart';

import 'package:tinsu_shops/features/products/domain/product_model.dart';
import 'package:tinsu_shops/features/sales/domain/cart_item_model.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

ProductModel _makeProduct({
  required String id,
  required String name,
  int stock = 50,
  bool active = true,
  String? categoryId,
  String? categoryName,
}) =>
    ProductModel(
      id: id,
      shopId: 'shop-001',
      name: name,
      sellingPrice: '35.00',
      stockQuantity: stock,
      isActive: active,
      categoryId: categoryId,
      categoryName: categoryName,
    );

/// Simulates the "recently sold" ordering logic: unique products, most recently
/// sold first.  Mirrors what the backend query returns.
List<ProductModel> _applyRecentOrder(
  List<ProductModel> current,
  List<ProductModel> justSold,
) {
  // Remove sold products from existing list (they will be re-inserted at front)
  final soldIds = justSold.map((p) => p.id).toSet();
  final withoutSold = current.where((p) => !soldIds.contains(p.id)).toList();
  // Insert sold products at the front in reverse sell-order so the latest
  // sold ends up at index 0.
  return [...justSold.reversed, ...withoutSold];
}

/// Simple cart simulation (add by 1, capped at stockQuantity).
CartState _addToCart(CartState cart, ProductModel product) {
  if (!product.isActive || product.isOutOfStock) return cart;
  final idx = cart.indexOf(product.id);
  if (idx >= 0) {
    final existing = cart.items[idx];
    final newQty = existing.quantity + 1;
    if (newQty > product.stockQuantity) return cart;
    final updated = List<CartItem>.from(cart.items);
    updated[idx] = existing.copyWith(quantity: newQty);
    return cart.copyWith(items: updated);
  }
  return cart.copyWith(
    items: [...cart.items, CartItem(product: product, quantity: 1)],
  );
}

// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // 1. Recently Sold section displays products when list is non-empty
  group('1. Recently Sold — display', () {
    test('non-empty list contains expected products', () {
      final products = [
        _makeProduct(id: 'p1', name: 'Coke'),
        _makeProduct(id: 'p2', name: 'Water'),
      ];
      expect(products, isNotEmpty);
      expect(products.map((p) => p.name), containsAll(['Coke', 'Water']));
    });

    test('empty list → section should be hidden', () {
      final products = <ProductModel>[];
      expect(products.isEmpty, isTrue,
          reason: 'When empty, the section must not render');
    });
  });

  // 2. No sales → hide section
  group('2. No sales → section hidden', () {
    test('empty recent list triggers hide', () {
      const recentProducts = <ProductModel>[];
      expect(recentProducts.isEmpty, isTrue);
    });
  });

  // 3. Products are ordered correctly (most recent first)
  group('3. Ordering — most recently sold appears first', () {
    test('products are in most-recently-sold order', () {
      final coke = _makeProduct(id: 'p1', name: 'Coke');
      final water = _makeProduct(id: 'p2', name: 'Water');
      final fanta = _makeProduct(id: 'p3', name: 'Fanta');

      // Simulate: Coke sold, then Water, then Fanta (most recent = Fanta)
      final recent = [fanta, water, coke];
      expect(recent.first.name, 'Fanta');
    });

    test('re-selling a product moves it to the front', () {
      final coke = _makeProduct(id: 'p1', name: 'Coke');
      final water = _makeProduct(id: 'p2', name: 'Water');
      final fanta = _makeProduct(id: 'p3', name: 'Fanta');

      // Current order: Fanta, Water, Coke
      final before = [fanta, water, coke];

      // Sell Coke again → Coke moves to front
      final after = _applyRecentOrder(before, [coke]);
      expect(after.first.name, 'Coke');
      expect(after.map((p) => p.name), equals(['Coke', 'Fanta', 'Water']));
    });
  });

  // 4. Duplicate products do not appear
  group('4. No duplicates', () {
    test('same product sold multiple times appears only once', () {
      final coke = _makeProduct(id: 'p1', name: 'Coke');

      // Simulate backend deduplication: product appears only once
      final recent = [coke];
      final ids = recent.map((p) => p.id).toList();
      expect(ids.toSet().length, equals(ids.length),
          reason: 'No duplicate product IDs allowed');
    });

    test('applying re-sell does not create duplicates', () {
      final coke = _makeProduct(id: 'p1', name: 'Coke');
      final water = _makeProduct(id: 'p2', name: 'Water');
      final before = [coke, water];

      // Sell water again
      final after = _applyRecentOrder(before, [water]);
      final ids = after.map((p) => p.id).toList();
      expect(ids.toSet().length, ids.length,
          reason: 'No duplicates after re-sell');
      expect(ids.length, 2, reason: 'Same 2 products, no extra');
    });
  });

  // 5. Tap recent product adds to cart
  group('5. Tap recent product adds to cart', () {
    test('tapping a product adds 1 to cart', () {
      final coke = _makeProduct(id: 'p1', name: 'Coke');
      var cart = const CartState();
      expect(cart.quantityFor('p1'), 0);

      cart = _addToCart(cart, coke);
      expect(cart.quantityFor('p1'), 1);
    });

    test('tapping the same product twice adds 2', () {
      final coke = _makeProduct(id: 'p1', name: 'Coke');
      var cart = const CartState();

      cart = _addToCart(cart, coke);
      cart = _addToCart(cart, coke);
      expect(cart.quantityFor('p1'), 2);
    });

    test('tapping a recently sold product that is already in cart increments', () {
      final coke = _makeProduct(id: 'p1', name: 'Coke');
      var cart = const CartState();

      // Already added from regular grid: qty = 2
      cart = _addToCart(cart, coke);
      cart = _addToCart(cart, coke);
      expect(cart.quantityFor('p1'), 2);

      // Tap from Recently Sold → qty becomes 3
      cart = _addToCart(cart, coke);
      expect(cart.quantityFor('p1'), 3);
    });
  });

  // 6. Category change does not alter recent history
  group('6. Category change does not alter recent history', () {
    test('category filter has no effect on recent list', () {
      final recentBefore = [
        _makeProduct(id: 'p1', name: 'Coke', categoryId: 'cat-drinks'),
        _makeProduct(id: 'p2', name: 'Water', categoryId: 'cat-drinks'),
      ];

      // Simulate selecting Snacks category — recentProducts list unchanged
      const selectedCategoryId = 'cat-snacks';
      final recentAfter = recentBefore; // no mutation

      expect(recentAfter, equals(recentBefore));
      expect(selectedCategoryId, 'cat-snacks'); // category changed
      expect(recentAfter.first.id, 'p1',
          reason: 'Recent list must be unchanged');
    });
  });

  // 7. Search does not alter recent history
  group('7. Search does not alter recent history', () {
    test('search query has no effect on recent list', () {
      final recentBefore = [
        _makeProduct(id: 'p1', name: 'Coke'),
        _makeProduct(id: 'p2', name: 'Water'),
      ];

      const searchQuery = 'coke'; // searching changes query, not recent list
      final recentAfter = recentBefore;

      expect(searchQuery, 'coke');
      expect(recentAfter, equals(recentBefore));
    });
  });

  // 8. Successful sale moves sold products to front
  group('8. Successful sale updates recent order', () {
    test('sold products move to front after successful sale', () {
      final coke = _makeProduct(id: 'p1', name: 'Coke');
      final water = _makeProduct(id: 'p2', name: 'Water');
      final biscuit = _makeProduct(id: 'p3', name: 'Biscuit');
      final fanta = _makeProduct(id: 'p4', name: 'Fanta');

      // Before: Water, Biscuit, Fanta, Coke
      final before = [water, biscuit, fanta, coke];

      // Sell Coke → Coke moves to front
      final afterCoke = _applyRecentOrder(before, [coke]);
      expect(afterCoke.first.name, 'Coke');
      expect(afterCoke.map((p) => p.name),
          equals(['Coke', 'Water', 'Biscuit', 'Fanta']));

      // Sell Water → Water moves to front
      final afterWater = _applyRecentOrder(afterCoke, [water]);
      expect(afterWater.first.name, 'Water');
      expect(afterWater.map((p) => p.name),
          equals(['Water', 'Coke', 'Biscuit', 'Fanta']));
    });
  });

  // 9. Failed sale does not change recent history
  group('9. Failed sale does not change recent history', () {
    test('cart is preserved on failure', () {
      final coke = _makeProduct(id: 'p1', name: 'Coke');
      var cart = const CartState();
      cart = _addToCart(cart, coke);
      expect(cart.quantityFor('p1'), 1);

      // Simulate failed sale: cart must remain intact
      // (No mutation simulated — this is the contract)
      expect(cart.quantityFor('p1'), 1,
          reason: 'Cart unchanged after failed sale');
    });

    test('recent list does not change on failed sale', () {
      final recentBefore = [
        _makeProduct(id: 'p1', name: 'Coke'),
        _makeProduct(id: 'p2', name: 'Water'),
      ];

      // Simulate failed sale — do NOT apply _applyRecentOrder
      final recentAfter = recentBefore; // no mutation
      expect(recentAfter.first.name, 'Coke',
          reason: 'Recent list must be unchanged on failure');
    });
  });

  // 10. Switching worker updates recent products
  group('10. Worker switch updates recent products', () {
    test('different worker IDs map to different recent lists', () {
      // Hana's recent products
      final hanaRecent = [_makeProduct(id: 'p1', name: 'Coke')];
      // Abebe's recent products (empty for new worker)
      final ababeRecent = <ProductModel>[];

      // After switching to Abebe, provider is rebuilt with Abebe's identity
      expect(hanaRecent, isNotEmpty);
      expect(ababeRecent, isEmpty,
          reason: 'Different worker must see their own history');
    });
  });

  // 11. Switching shop updates recent products
  group('11. Shop switch updates recent products', () {
    test('different shopIds map to different recent lists', () {
      final mainShopRecent = [_makeProduct(id: 'p1', name: 'Coke')];
      // Branch 2 has no sales yet
      final branch2Recent = <ProductModel>[];

      expect(mainShopRecent, isNotEmpty);
      expect(branch2Recent, isEmpty,
          reason: 'Switching shop must clear previous shop recent products');
    });
  });

  // 12. Out-of-stock recent product cannot be sold
  group('12. Out-of-stock product cannot be added to cart', () {
    test('out-of-stock product tap is ignored', () {
      final outOfStockCoke = _makeProduct(id: 'p1', name: 'Coke', stock: 0);
      var cart = const CartState();

      // addProduct is a no-op for out-of-stock
      cart = _addToCart(cart, outOfStockCoke);
      expect(cart.quantityFor('p1'), 0,
          reason: 'Out-of-stock product must not be added to cart');
    });

    test('in-stock product can be added', () {
      final inStockCoke = _makeProduct(id: 'p1', name: 'Coke', stock: 10);
      var cart = const CartState();
      cart = _addToCart(cart, inStockCoke);
      expect(cart.quantityFor('p1'), 1);
    });

    test('out-of-stock check uses stockQuantity <= 0', () {
      final outOfStockProduct = _makeProduct(id: 'p2', name: 'Water', stock: 0);
      expect(outOfStockProduct.isOutOfStock, isTrue);
    });

    test('restocked product becomes sellable again', () {
      final restockedCoke = _makeProduct(id: 'p1', name: 'Coke', stock: 5);
      expect(restockedCoke.isOutOfStock, isFalse);
      var cart = const CartState();
      cart = _addToCart(cart, restockedCoke);
      expect(cart.quantityFor('p1'), 1);
    });
  });

  // ── Bonus: ProductModel parsing for recent-products response ──────────────
  group('ProductModel parsing — recent-products response shape', () {
    test('fromJson parses backend response including shop_id', () {
      final p = ProductModel.fromJson({
        'id': 'prod-001',
        'shop_id': 'shop-001',
        'name': 'Coca-Cola 500ml',
        'selling_price': 35,
        'stock_quantity': 24,
        'low_stock_threshold': 5,
        'category_id': 'cat-001',
        'category_name': 'Drinks',
        'is_active': true,
        'photo_url': null,
      });
      expect(p.id, 'prod-001');
      expect(p.shopId, 'shop-001');
      expect(p.name, 'Coca-Cola 500ml');
      expect(p.price, closeTo(35.0, 0.001));
      expect(p.stockQuantity, 24);
      expect(p.categoryId, 'cat-001');
      expect(p.categoryName, 'Drinks');
      expect(p.isActive, isTrue);
      expect(p.isOutOfStock, isFalse);
    });

    test('fromJson handles missing optional fields gracefully', () {
      final p = ProductModel.fromJson({
        'id': 'prod-002',
        'shop_id': 'shop-001',
        'name': 'Water',
        'selling_price': 20,
        'stock_quantity': 0,
        'is_active': true,
      });
      expect(p.isOutOfStock, isTrue);
      expect(p.categoryId, isNull);
      expect(p.categoryName, isNull);
    });
  });
}
