import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/products_repository.dart';
import '../domain/product_search_result.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

/// Immutable state owned by [ProductSearchController].
class ProductSearchState {
  const ProductSearchState({
    this.normalizedQuery = '',
    this.isSearching = false,
    this.results,
    this.errorMessage,
  });

  /// The last query string that was (or is being) sent to the backend.
  /// Empty string means no active search.
  final String normalizedQuery;

  /// True while a network fetch is in-flight.
  /// Previous [results] remain accessible so the UI never goes blank.
  final bool isSearching;

  /// Latest search results.
  /// `null` = no search has been run yet (show the normal product grid).
  /// Non-null with empty `items` = search returned zero results.
  final ProductSearchResult? results;

  /// Human-readable error shown to the user, `null` when healthy.
  final String? errorMessage;

  // ── Derived ────────────────────────────────────────────────────────────────

  bool get hasActiveSearch => normalizedQuery.isNotEmpty;
  bool get hasError => errorMessage != null;
  bool get hasResults => results != null && results!.items.isNotEmpty;

  ProductSearchState copyWith({
    String? normalizedQuery,
    bool? isSearching,
    ProductSearchResult? results,
    bool clearResults = false,
    String? errorMessage,
    bool clearError = false,
  }) =>
      ProductSearchState(
        normalizedQuery: normalizedQuery ?? this.normalizedQuery,
        isSearching: isSearching ?? this.isSearching,
        results: clearResults ? null : (results ?? this.results),
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────

/// Manages the full search lifecycle for one shop:
///
/// - **300 ms debounce** — fires only after the user pauses typing
/// - **Version counter** — discards responses from superseded requests so
///   a slow "b" response can never overwrite a fast "biscuit" response
/// - **Stable results** — keeps the previous result set visible while the
///   next fetch is in-flight (no full-screen flash)
/// - **Category-aware** — call [onCategoryChanged] whenever the filter chip
///   changes while a search is active
///
/// Usage:
/// ```dart
/// // Inside a ConsumerWidget / ConsumerState:
/// final ctrl = ref.read(productSearchControllerProvider(shopId).notifier);
/// ctrl.onQueryChanged(textFieldValue, categoryId: _selectedCategory);
///
/// final state = ref.watch(productSearchControllerProvider(shopId));
/// if (state.hasActiveSearch) { ... show search view ... }
/// ```
class ProductSearchController extends StateNotifier<ProductSearchState> {
  ProductSearchController({
    required String shopId,
    required ProductsRepository repository,
  })  : _shopId = shopId,
        _repo = repository,
        super(const ProductSearchState());

  static const _kDebounce = Duration(milliseconds: 300);

  final String _shopId;
  final ProductsRepository _repo;

  Timer? _debounce;

  /// Monotonically-increasing request version.
  /// Each new fetch increments this counter; a response is only applied to
  /// state when its captured version still matches the current one.
  int _version = 0;

  /// Category currently selected by the UI — stored so [retry] can reuse it.
  String? _activeCategory;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call this from the TextField's `onChanged` callback.
  ///
  /// Whitespace is normalised immediately. If the normalised query hasn't
  /// changed nothing happens. If it's empty, state is reset synchronously
  /// and any pending debounce/fetch is cancelled.
  void onQueryChanged(String raw, {String? categoryId}) {
    final normalized = raw.trim();
    _activeCategory = categoryId;

    // Skip if nothing meaningful changed.
    if (normalized == state.normalizedQuery) return;

    _debounce?.cancel();

    if (normalized.isEmpty) {
      _version++; // invalidate any in-flight fetch
      state = const ProductSearchState();
      return;
    }

    // Immediately reflect the new query + isSearching flag but keep the
    // previous results visible — avoids the "blank flash" while loading.
    state = ProductSearchState(
      normalizedQuery: normalized,
      isSearching: true,
      results: state.results,
    );

    _debounce = Timer(
      _kDebounce,
      () => _fetch(normalized, categoryId: _activeCategory),
    );
  }

  /// Call this when the category chip selection changes while a search is active.
  /// Re-fetches immediately (no debounce — it's a deliberate user action).
  void onCategoryChanged(String? categoryId) {
    _activeCategory = categoryId;
    if (!state.hasActiveSearch) return;
    _debounce?.cancel();
    state = state.copyWith(isSearching: true, clearError: true);
    _fetch(state.normalizedQuery, categoryId: categoryId);
  }

  /// Resets all search state and cancels pending debounce / in-flight requests.
  void clear() {
    _debounce?.cancel();
    _version++;
    state = const ProductSearchState();
  }

  /// Retries the last failed request.
  void retry() {
    if (!state.hasActiveSearch) return;
    state = state.copyWith(isSearching: true, clearError: true);
    _fetch(state.normalizedQuery, categoryId: _activeCategory);
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  Future<void> _fetch(String query, {String? categoryId}) async {
    _version++;
    final myVersion = _version;

    try {
      final result = await _repo.searchProducts(
        _shopId,
        query,
        categoryId: categoryId,
      );

      // Discard if a newer request has already superseded this one.
      if (!mounted || myVersion != _version) return;

      state = ProductSearchState(
        normalizedQuery: query,
        results: result,
      );
    } catch (_) {
      if (!mounted || myVersion != _version) return;

      state = ProductSearchState(
        normalizedQuery: query,
        results: state.results, // keep last-good results on error
        errorMessage: "Couldn't search products.",
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

/// Auto-disposing family provider — one controller per shop.
///
/// Keyed only on [shopId], so the controller persists across query and
/// category changes (which would create new provider instances if they were
/// part of the key). Auto-disposed when no widget is watching.
final productSearchControllerProvider = StateNotifierProvider.autoDispose
    .family<ProductSearchController, ProductSearchState, String>(
  (ref, shopId) => ProductSearchController(
    shopId: shopId,
    repository: ref.watch(productsRepositoryProvider),
  ),
);
