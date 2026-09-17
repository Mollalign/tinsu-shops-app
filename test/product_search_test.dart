/// Tests for [ProductSearchController].
///
/// Uses a simple [FakeProductsRepository] instead of Mockito so no extra
/// dev-dependency or code-generation is required.
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tinsu_shops/features/products/data/products_repository.dart';
import 'package:tinsu_shops/features/products/domain/product_model.dart';
import 'package:tinsu_shops/features/products/domain/product_search_result.dart';
import 'package:tinsu_shops/features/products/presentation/product_search_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Fake repository
// ─────────────────────────────────────────────────────────────────────────────

typedef SearchCall = ({String shopId, String query, String? categoryId});

/// Fake extending [ProductsRepository]; only [searchProducts] is overridden.
class FakeProductsRepository extends ProductsRepository {
  FakeProductsRepository() : super(dio: Dio());

  final _calls = <SearchCall>[];
  final _stubs = <String, ProductSearchResult>{};
  Completer<ProductSearchResult>? _nextCompleter;

  List<SearchCall> get calls => List.unmodifiable(_calls);

  void whenSearch(String query, ProductSearchResult result) =>
      _stubs[query] = result;

  /// The next [searchProducts] call blocks until the returned completer fires.
  Completer<ProductSearchResult> holdNext() =>
      _nextCompleter = Completer<ProductSearchResult>();

  @override
  Future<ProductSearchResult> searchProducts(
    String shopId,
    String q, {
    String? categoryId,
  }) async {
    _calls.add((shopId: shopId, query: q, categoryId: categoryId));
    if (_nextCompleter != null) {
      final c = _nextCompleter!;
      _nextCompleter = null;
      return c.future;
    }
    return _stubs[q] ?? const ProductSearchResult(items: []);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

const _shopId = 'shop-abc';
// Generous wait so VM timer jitter doesn't cause flakes.
const _kAfterDebounce = Duration(milliseconds: 500);

ProductSearchResult _result(List<String> names) => ProductSearchResult(
      items: names
          .map((n) => ProductModel(
                id: n,
                shopId: _shopId,
                name: n,
                sellingPrice: '10',
                stockQuantity: 5,
              ))
          .toList(),
    );

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  late FakeProductsRepository repo;
  late ProviderContainer container;
  late ProviderSubscription<ProductSearchState> sub;
  // Convenience getters — safe to call because [sub] keeps the provider alive.
  late ProductSearchController ctrl;

  setUp(() {
    repo = FakeProductsRepository();
    container = ProviderContainer(
      overrides: [productsRepositoryProvider.overrideWithValue(repo)],
    );
    // Keep the autoDispose provider alive for the duration of each test.
    sub = container.listen(
      productSearchControllerProvider(_shopId),
      (_, __) {},
      fireImmediately: false,
    );
    ctrl = container.read(productSearchControllerProvider(_shopId).notifier);
  });

  tearDown(() {
    sub.close();
    container.dispose();
  });

  ProductSearchState state() =>
      container.read(productSearchControllerProvider(_shopId));

  // ── 1. Initial state ───────────────────────────────────────────────────────

  test('initial state is empty with no results', () {
    final s = state();
    expect(s.normalizedQuery, '');
    expect(s.isSearching, false);
    expect(s.results, isNull);
    expect(s.hasActiveSearch, false);
  });

  // ── 2. Empty query → no fetch ──────────────────────────────────────────────

  test('empty query does not trigger a fetch', () async {
    ctrl.onQueryChanged('');
    await Future<void>.delayed(_kAfterDebounce);
    expect(repo.calls, isEmpty);
    expect(state().hasActiveSearch, false);
  });

  // ── 3. Whitespace normalisation ────────────────────────────────────────────

  test('whitespace-only query is treated as empty — no fetch', () async {
    ctrl.onQueryChanged('   ');
    await Future<void>.delayed(_kAfterDebounce);
    expect(repo.calls, isEmpty);
    expect(state().hasActiveSearch, false);
  });

  test('leading/trailing whitespace is stripped before fetching', () async {
    repo.whenSearch('bisc', _result(['Biscuit']));
    ctrl.onQueryChanged('  bisc  ');
    await Future<void>.delayed(_kAfterDebounce);
    expect(state().normalizedQuery, 'bisc');
    expect(repo.calls.last.query, 'bisc');
  });

  // ── 4. Debounce — fires at 300 ms, not before ─────────────────────────────

  test('debounce: API is NOT called before 300 ms', () async {
    ctrl.onQueryChanged('b');
    // Check at 0 ms — not fired yet
    expect(repo.calls, isEmpty);
    // Check at 100 ms — still too early
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(repo.calls, isEmpty);
  });

  test('debounce: API IS called after 300 ms', () async {
    repo.whenSearch('b', _result(['Bread']));
    ctrl.onQueryChanged('b');
    await Future<void>.delayed(_kAfterDebounce);
    expect(repo.calls.length, 1);
    expect(repo.calls.first.query, 'b');
  });

  // ── 5. Rapid typing → only one API call ───────────────────────────────────

  test('typing "biscuit" letter by letter triggers exactly 1 API call',
      () async {
    repo.whenSearch('biscuit', _result(['Biscuit']));

    for (final char in
        ['b', 'bi', 'bis', 'bisc', 'biscu', 'biscui', 'biscuit']) {
      ctrl.onQueryChanged(char);
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }
    // Wait for the final debounce to fire
    await Future<void>.delayed(_kAfterDebounce);

    expect(repo.calls.length, 1);
    expect(repo.calls.first.query, 'biscuit');
    expect(state().normalizedQuery, 'biscuit');
  });

  // ── 6. Stale request protection ───────────────────────────────────────────

  test('slow "b" response does not overwrite fast "bi" result', () async {
    final slowB = repo.holdNext(); // 'b' call will block
    ctrl.onQueryChanged('b');
    await Future<void>.delayed(_kAfterDebounce);

    // 'b' fetch in-flight. Now change to 'bi'.
    repo.whenSearch('bi', _result(['Biscuit', 'Bread']));
    ctrl.onQueryChanged('bi');
    await Future<void>.delayed(_kAfterDebounce);

    // Resolve the stale 'b' — should be discarded by version counter.
    slowB.complete(_result(['Bread only']));
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(state().normalizedQuery, 'bi');
    final names = state().results?.items.map((p) => p.name).toSet();
    expect(names, containsAll(['Biscuit', 'Bread']));
    expect(names, isNot(contains('Bread only')));
  });

  // ── 7. Previous results preserved while loading ────────────────────────────

  test('previous results remain visible while next search is loading',
      () async {
    repo.whenSearch('b', _result(['Bread']));
    ctrl.onQueryChanged('b');
    await Future<void>.delayed(_kAfterDebounce);

    expect(state().results?.items.first.name, 'Bread');

    // Start a slow second search — 'Bread' must still be in state.
    final slow = repo.holdNext();
    ctrl.onQueryChanged('bi');
    // After debounce fires the fetch is in-flight; previous results preserved.
    await Future<void>.delayed(_kAfterDebounce);

    expect(state().results?.items.first.name, 'Bread');

    // Resolve the new search.
    slow.complete(_result(['Biscuit']));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(state().results?.items.first.name, 'Biscuit');
  });

  // ── 8. Clear ──────────────────────────────────────────────────────────────

  test('clear() immediately resets state', () async {
    repo.whenSearch('b', _result(['Bread']));
    ctrl.onQueryChanged('b');
    await Future<void>.delayed(_kAfterDebounce);

    expect(state().hasActiveSearch, true);
    ctrl.clear();

    final s = state();
    expect(s.normalizedQuery, '');
    expect(s.results, isNull);
    expect(s.isSearching, false);
    expect(s.hasActiveSearch, false);
  });

  test('clear() cancels pending debounce — no API call is made', () async {
    ctrl.onQueryChanged('b');
    ctrl.clear(); // cancel before debounce fires
    await Future<void>.delayed(_kAfterDebounce);
    expect(repo.calls, isEmpty);
  });

  // ── 9. Category change while searching ────────────────────────────────────

  test('onCategoryChanged re-fetches immediately when active search exists',
      () async {
    repo.whenSearch('b', _result(['Bread']));
    ctrl.onQueryChanged('b');
    await Future<void>.delayed(_kAfterDebounce);

    repo.whenSearch('b', _result(['Biscuit']));
    ctrl.onCategoryChanged('cat-1');
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(repo.calls.last.categoryId, 'cat-1');
    expect(state().results?.items.first.name, 'Biscuit');
  });

  test('onCategoryChanged does nothing when no active search', () async {
    ctrl.onCategoryChanged('cat-1');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(repo.calls, isEmpty);
  });

  // ── 10. Error handling ────────────────────────────────────────────────────

  test('fetch failure sets errorMessage', () async {
    final c = repo.holdNext();
    ctrl.onQueryChanged('b');
    await Future<void>.delayed(_kAfterDebounce);
    c.completeError(Exception('network error'));
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(state().hasError, true);
    expect(state().errorMessage, "Couldn't search products.");
    expect(state().isSearching, false);
  });

  test('retry() re-fetches and clears error on success', () async {
    // First call fails
    final c = repo.holdNext();
    ctrl.onQueryChanged('b');
    await Future<void>.delayed(_kAfterDebounce);
    c.completeError(Exception('network error'));
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(state().hasError, true);

    // Second call succeeds
    repo.whenSearch('b', _result(['Bread']));
    ctrl.retry();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(state().hasError, false);
    expect(state().results?.items.first.name, 'Bread');
  });

  // ── 11. Duplicate query suppression ───────────────────────────────────────

  test('same normalised query does not trigger a second fetch', () async {
    repo.whenSearch('bisc', _result(['Biscuit']));

    // First call
    ctrl.onQueryChanged('bisc');
    await Future<void>.delayed(_kAfterDebounce);
    expect(repo.calls.length, 1);

    // Same query again — should be suppressed
    ctrl.onQueryChanged('bisc');
    await Future<void>.delayed(_kAfterDebounce);
    expect(repo.calls.length, 1); // still 1
  });

  // ── 12. Search scoped to shop ─────────────────────────────────────────────

  test('fetch always sends the correct shopId', () async {
    repo.whenSearch('coke', _result(['Coke']));
    ctrl.onQueryChanged('coke');
    await Future<void>.delayed(_kAfterDebounce);

    expect(repo.calls.first.shopId, _shopId);
  });

  // ── 13. Recent-first ordering preservation ────────────────────────────────
  // The controller is a pure pass-through: it does NOT reorder results.
  // Ordering comes from the backend (last_sold_at DESC NULLS LAST).
  // These tests verify the controller preserves whatever order the backend sends.

  test('search results are returned in the order given by the backend', () async {
    final t0 = DateTime(2026, 9, 17, 9, 0);
    final t1 = DateTime(2026, 9, 17, 9, 5);

    // Backend returns Coca-Cola first (sold most recently), then Water
    final result = ProductSearchResult(
      items: [
        ProductModel(
          id: 'p2', shopId: _shopId, name: 'Coca-Cola',
          sellingPrice: '15', stockQuantity: 50, lastSoldAt: t1,
        ),
        ProductModel(
          id: 'p1', shopId: _shopId, name: 'Water',
          sellingPrice: '5', stockQuantity: 30, lastSoldAt: t0,
        ),
      ],
    );
    repo.whenSearch('co', result);
    ctrl.onQueryChanged('co');
    await Future<void>.delayed(_kAfterDebounce);

    final names = state().results?.items.map((p) => p.name).toList();
    expect(names, equals(['Coca-Cola', 'Water']));
  });

  test('never-sold products (null lastSoldAt) are received at the end', () async {
    final t0 = DateTime(2026, 9, 17, 9, 0);

    // Backend puts sold product first, never-sold product last
    final result = ProductSearchResult(
      items: [
        ProductModel(
          id: 'p1', shopId: _shopId, name: 'Bread',
          sellingPrice: '8', stockQuantity: 100, lastSoldAt: t0,
        ),
        ProductModel(
          id: 'p2', shopId: _shopId, name: 'Rice',
          sellingPrice: '5', stockQuantity: 200,
        ),
      ],
    );
    repo.whenSearch('r', result);
    ctrl.onQueryChanged('r');
    await Future<void>.delayed(_kAfterDebounce);

    final items = state().results!.items;
    // Sold product comes first
    expect(items.first.lastSoldAt, isNotNull);
    // Never-sold product comes last
    expect(items.last.lastSoldAt, isNull);
  });

  test('category search preserves backend ordering', () async {
    final t0 = DateTime(2026, 9, 17, 9, 0);
    final t1 = DateTime(2026, 9, 17, 9, 5);

    // Backend returns A (newer) before B (older) because of recent ordering
    final result = ProductSearchResult(
      items: [
        ProductModel(
          id: 'pA', shopId: _shopId, name: 'CatProd A',
          sellingPrice: '10', stockQuantity: 50, lastSoldAt: t1,
        ),
        ProductModel(
          id: 'pB', shopId: _shopId, name: 'CatProd B',
          sellingPrice: '10', stockQuantity: 50, lastSoldAt: t0,
        ),
      ],
    );
    repo.whenSearch('CatProd', result);
    ctrl.onQueryChanged('CatProd');
    ctrl.onCategoryChanged('cat-drinks');
    await Future<void>.delayed(_kAfterDebounce);

    final names = state().results?.items.map((p) => p.name).toList();
    expect(names?.first, 'CatProd A');
  });
}
