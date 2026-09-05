import 'package:flutter_test/flutter_test.dart';

import 'package:tinsu_shops/features/products/domain/category_model.dart';
import 'package:tinsu_shops/features/products/domain/product_model.dart';
import 'package:tinsu_shops/features/products/domain/product_search_result.dart';

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

  // ── ProductSearchResult model ──────────────────────────────────
  group('ProductSearchResult — parsing', () {
    final productJson = {
      'id': 'prod-001',
      'shop_id': 'shop-001',
      'name': 'Coca-Cola',
      'selling_price': 35,
      'stock_quantity': 20,
      'is_active': true,
      'category_id': 'cat-001',
      'category_name': 'Drinks',
    };

    test('fromJson with matched_category', () {
      final result = ProductSearchResult.fromJson({
        'matched_category': {
          'id': 'cat-001',
          'name': 'Drinks',
          'product_count': 12,
        },
        'items': [productJson],
      });

      expect(result.matchedCategory, isNotNull);
      expect(result.matchedCategory!.id, 'cat-001');
      expect(result.matchedCategory!.name, 'Drinks');
      expect(result.matchedCategory!.productCount, 12);
      expect(result.items.length, 1);
      expect(result.items.first.name, 'Coca-Cola');
    });

    test('fromJson without matched_category', () {
      final result = ProductSearchResult.fromJson({
        'matched_category': null,
        'items': [productJson],
      });

      expect(result.matchedCategory, isNull);
      expect(result.items.length, 1);
    });

    test('fromJson with empty items', () {
      final result = ProductSearchResult.fromJson({
        'matched_category': null,
        'items': <dynamic>[],
      });

      expect(result.matchedCategory, isNull);
      expect(result.items, isEmpty);
    });

    test('CategorySearchMatch.fromJson parses productCount correctly', () {
      final match = CategorySearchMatch.fromJson({
        'id': 'cat-abc',
        'name': 'Snacks',
        'product_count': 5,
      });

      expect(match.id, 'cat-abc');
      expect(match.name, 'Snacks');
      expect(match.productCount, 5);
    });

    test('default ProductSearchResult const has empty items and no match', () {
      const r = ProductSearchResult(items: []);
      expect(r.matchedCategory, isNull);
      expect(r.items, isEmpty);
    });
  });

  // ── Search result UX logic ────────────────────────────────────────
  group('Search result UX logic', () {
    test('no match and no items → show empty state', () {
      const result = ProductSearchResult(items: []);
      expect(result.matchedCategory, isNull);
      expect(result.items.isEmpty, isTrue);
    });

    test('match present, no items → banner only (no products)', () {
      final result = ProductSearchResult.fromJson({
        'matched_category': {
          'id': 'cat-001',
          'name': 'Drinks',
          'product_count': 8,
        },
        'items': <dynamic>[],
      });

      expect(result.matchedCategory, isNotNull);
      expect(result.matchedCategory!.name, 'Drinks');
      expect(result.matchedCategory!.productCount, 8);
      expect(result.items.isEmpty, isTrue);
    });

    test('no match, items present → show product list only', () {
      final result = ProductSearchResult.fromJson({
        'matched_category': null,
        'items': [
          {
            'id': 'p1',
            'shop_id': 's',
            'name': 'Coke',
            'selling_price': 35,
            'stock_quantity': 10,
            'is_active': true,
          }
        ],
      });

      expect(result.matchedCategory, isNull);
      expect(result.items.length, 1);
    });

    test('productCount label handles singular correctly', () {
      const match = CategorySearchMatch(id: 'x', name: 'Test', productCount: 1);
      final label =
          '${match.productCount} product${match.productCount == 1 ? '' : 's'}';
      expect(label, '1 product');
    });

    test('productCount label handles plural correctly', () {
      const match =
          CategorySearchMatch(id: 'x', name: 'Test', productCount: 12);
      final label =
          '${match.productCount} product${match.productCount == 1 ? '' : 's'}';
      expect(label, '12 products');
    });

    test('search result items preserve category fields from backend', () {
      final result = ProductSearchResult.fromJson({
        'matched_category': null,
        'items': [
          {
            'id': 'prod-001',
            'shop_id': 'shop-001',
            'name': 'Fanta',
            'selling_price': 30,
            'stock_quantity': 5,
            'is_active': true,
            'category_id': 'cat-001',
            'category_name': 'Drinks',
          }
        ],
      });

      final product = result.items.first;
      expect(product.categoryId, 'cat-001');
      expect(product.categoryName, 'Drinks');
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
