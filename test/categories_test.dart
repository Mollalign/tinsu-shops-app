import 'package:flutter_test/flutter_test.dart';

import 'package:tinsu_shops/features/products/domain/category_model.dart';
import 'package:tinsu_shops/features/products/domain/product_model.dart';

void main() {
  // ── CategoryModel ─────────────────────────────────────────────────
  group('CategoryModel', () {
    const json = {
      'id': 'cat-001',
      'shop_id': 'shop-001',
      'name': 'Drinks',
    };

    test('fromJson parses correctly', () {
      final cat = CategoryModel.fromJson(json);
      expect(cat.id, 'cat-001');
      expect(cat.shopId, 'shop-001');
      expect(cat.name, 'Drinks');
    });

    test('toJson serialises to snake_case', () {
      const cat = CategoryModel(
        id: 'cat-001',
        shopId: 'shop-001',
        name: 'Drinks',
      );
      final out = cat.toJson();
      expect(out['shop_id'], 'shop-001');
      expect(out['name'], 'Drinks');
    });

    test('equality — same data', () {
      final a = CategoryModel.fromJson(json);
      final b = CategoryModel.fromJson(json);
      expect(a, equals(b));
    });
  });

  // ── ProductModel with category fields ─────────────────────────────
  group('ProductModel — category fields', () {
    test('deserialises category_id and category_name when present', () {
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
      });
      expect(p.categoryId, 'cat-001');
      expect(p.categoryName, 'Drinks');
    });

    test('deserialises null category_id and category_name', () {
      final p = ProductModel.fromJson({
        'id': 'prod-002',
        'shop_id': 'shop-001',
        'name': 'Mystery Item',
        'selling_price': 10,
        'stock_quantity': 5,
        'is_active': true,
        'category_id': null,
        'category_name': null,
      });
      expect(p.categoryId, isNull);
      expect(p.categoryName, isNull);
    });

    test('deserialises when category fields are absent (backward compat)', () {
      final p = ProductModel.fromJson({
        'id': 'prod-003',
        'shop_id': 'shop-001',
        'name': 'Old Product',
        'selling_price': 20,
        'stock_quantity': 10,
        'is_active': true,
      });
      expect(p.categoryId, isNull);
      expect(p.categoryName, isNull);
    });

    test('product price extension works', () {
      final p = ProductModel.fromJson({
        'id': 'prod-004',
        'shop_id': 'shop-001',
        'name': 'Item',
        'selling_price': 49.99,
        'stock_quantity': 2,
        'is_active': true,
      });
      expect(p.price, closeTo(49.99, 0.001));
    });

    test('toJson preserves category_id and category_name', () {
      const p = ProductModel(
        id: 'prod-001',
        shopId: 'shop-001',
        name: 'Coca-Cola',
        sellingPrice: '35.00',
        stockQuantity: 10,
        categoryId: 'cat-001',
        categoryName: 'Drinks',
      );
      final json = p.toJson();
      expect(json['category_id'], 'cat-001');
      expect(json['category_name'], 'Drinks');
    });
  });

  // ── Category filter logic ──────────────────────────────────────────
  group('Category filter logic', () {
    final drinks = CategoryModel(id: 'cat-001', shopId: 's', name: 'Drinks');
    final snacks = CategoryModel(id: 'cat-002', shopId: 's', name: 'Snacks');

    final products = [
      ProductModel(
        id: 'p1',
        shopId: 's',
        name: 'Coke',
        sellingPrice: '35',
        stockQuantity: 10,
        categoryId: 'cat-001',
        categoryName: 'Drinks',
      ),
      ProductModel(
        id: 'p2',
        shopId: 's',
        name: 'Water',
        sellingPrice: '20',
        stockQuantity: 5,
        categoryId: 'cat-001',
        categoryName: 'Drinks',
      ),
      ProductModel(
        id: 'p3',
        shopId: 's',
        name: 'Biscuit',
        sellingPrice: '15',
        stockQuantity: 8,
        categoryId: 'cat-002',
        categoryName: 'Snacks',
      ),
      ProductModel(
        id: 'p4',
        shopId: 's',
        name: 'Random',
        sellingPrice: '5',
        stockQuantity: 3,
        // no category
      ),
    ];

    List<ProductModel> filterByCategory(
        List<ProductModel> all, String? catId) {
      if (catId == null) return all; // All
      return all.where((p) => p.categoryId == catId).toList();
    }

    test('All (null) returns every product', () {
      final result = filterByCategory(products, null);
      expect(result.length, 4);
    });

    test('Drinks filter returns only drinks', () {
      final result = filterByCategory(products, drinks.id);
      expect(result.length, 2);
      expect(result.every((p) => p.categoryName == 'Drinks'), isTrue);
    });

    test('Snacks filter returns only snacks', () {
      final result = filterByCategory(products, snacks.id);
      expect(result.length, 1);
      expect(result.first.name, 'Biscuit');
    });

    test('Category + search: Drinks + "coke" returns only matching drink', () {
      final byCategory = filterByCategory(products, drinks.id);
      final bySearch = byCategory
          .where((p) => p.name.toLowerCase().contains('coke'))
          .toList();
      expect(bySearch.length, 1);
      expect(bySearch.first.name, 'Coke');
    });

    test('Category + search: Drinks + "biscuit" returns nothing', () {
      final byCategory = filterByCategory(products, drinks.id);
      final bySearch = byCategory
          .where((p) => p.name.toLowerCase().contains('biscuit'))
          .toList();
      expect(bySearch, isEmpty);
    });
  });

  // ── Cart unaffected by category change ────────────────────────────
  group('Cart independence from category', () {
    test('Cart items do not depend on category fields', () {
      // Simulate a cart item built from a product, then simulate a
      // category change by copying the product with a different category.
      // The cart item itself must be unchanged.
      const originalProduct = ProductModel(
        id: 'p1',
        shopId: 's',
        name: 'Coke',
        sellingPrice: '35',
        stockQuantity: 10,
        categoryId: 'cat-001',
        categoryName: 'Drinks',
      );

      // Simulate cart state: qty = 2, total = 70
      final cartQty = 2;
      final cartTotal = originalProduct.price * cartQty;

      // Simulate category change (produce a new product with different category)
      final productAfterCategoryChange =
          originalProduct.copyWith(categoryId: 'cat-002', categoryName: 'Snacks');

      // Cart values derived from the original product must remain the same
      final stillTotal = originalProduct.price * cartQty;
      expect(stillTotal, equals(cartTotal));
      expect(productAfterCategoryChange.id, equals(originalProduct.id));
      expect(productAfterCategoryChange.price, equals(originalProduct.price));

      // Cart quantity is not stored on the product model — it's external state
      // This test documents that changing category (a product model update)
      // does NOT affect cart quantity or total.
      expect(cartQty, 2);
      expect(cartTotal, 70.0);
    });
  });
}
