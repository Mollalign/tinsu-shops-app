import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/components.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/products_repository.dart';
import '../../domain/product_model.dart';
import '../product_search_controller.dart';

part 'products_screen.g.dart';

@riverpod
Future<List<ProductModel>> ownerProducts(Ref ref, String shopId) =>
    ref.watch(productsRepositoryProvider).listProducts(shopId);

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  static const _pageSize = 30;

  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  // Pagination state
  List<ProductModel> _items = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = false;
  int _page = 0;
  Object? _error; // AppError or generic Exception
  String _loadedShopId = '';

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollCtrl.position;
    if (_hasMore && !_loadingMore && pos.pixels >= pos.maxScrollExtent - 400) {
      _fetchPage(_page + 1);
    }
  }

  Future<void> _fetchPage(int page, {bool reset = false}) async {
    if (reset) {
      setState(() { _loading = true; _error = null; });
    } else {
      setState(() => _loadingMore = true);
    }
    try {
      final result = await ref
          .read(productsRepositoryProvider)
          .listProductsPage(_loadedShopId, page: page, pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _items = reset ? result.items : [..._items, ...result.items];
        _page = result.page;
        _hasMore = result.hasMore;
        _loading = false;
        _loadingMore = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _loadingMore = false; _error = e; });
    }
  }

  void _maybeLoad(String shopId) {
    if (shopId == _loadedShopId || shopId.isEmpty) return;
    _loadedShopId = shopId;
    _fetchPage(1, reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (user, shopId) => shopId ?? '',
      orElse: () => '',
    );

    // Trigger initial load (or reload on shop change) from build.
    _maybeLoad(shopId);

    final searchState = ref.watch(productSearchControllerProvider(shopId));
    final searchCtrl =
        ref.read(productSearchControllerProvider(shopId).notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(l.products)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/owner/products/add'),
        icon: const Icon(Icons.add),
        label: Text(l.addProduct),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ── Search field ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => searchCtrl.onQueryChanged(v),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l.searchProductsHint,
                  prefixIcon:
                      const Icon(Icons.search, color: AppTheme.outline),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            searchCtrl.clear();
                          },
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            // ── Inline search-loading indicator ───────────────────────────
            if (searchState.isSearching)
              const LinearProgressIndicator(
                minHeight: 2,
                color: AppTheme.primary,
                backgroundColor: AppTheme.primaryContainer,
              )
            else
              const SizedBox(height: 2),
            const SizedBox(height: 6),

            // ── Content ───────────────────────────────────────────────────
            Expanded(
              child: searchState.hasActiveSearch
                  ? _SearchView(
                      state: searchState,
                      onRetry: searchCtrl.retry,
                      shopId: shopId,
                    )
                  : Builder(builder: (context) {
                      final l2 = AppLocalizations.of(context)!;
                      final errMsg = _error == null
                          ? null
                          : (_error is AppError
                              ? (_error as AppError).toUserMessage(l2)
                              : l2.couldNotLoadProducts);
                      return _ProductListView(
                        items: _items.where((p) => p.isActive).toList(),
                        loading: _loading,
                        loadingMore: _loadingMore,
                        error: errMsg,
                        hasMore: _hasMore,
                        scrollCtrl: _scrollCtrl,
                        onRefresh: () => _fetchPage(1, reset: true),
                        shopId: shopId,
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView({
    required this.state,
    required this.onRetry,
    required this.shopId,
  });

  final ProductSearchState state;
  final VoidCallback onRetry;
  final String shopId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (state.hasError) {
      return ErrorState(
        message: state.errorMessage!,
        onRetry: onRetry,
      );
    }

    if (state.results == null) {
      return const ProductGridSkeleton();
    }

    final items = state.results!.items;

    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_outlined,
        title: l.noSearchResults,
        description: l.noSearchResultsDesc(state.normalizedQuery),
      );
    }

    const bottomPad = 88.0;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, bottomPad),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final p = items[i];
        return ListTile(
          tileColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            side: const BorderSide(color: AppTheme.divider),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: _ProductThumb(url: p.photoUrl),
          title: Text(
            p.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            p.categoryName != null
                ? '${p.categoryName} · ${_price(p.price)}'
                : _price(p.price),
            style: const TextStyle(color: AppTheme.outline, fontSize: 12),
          ),
          trailing: Text(
            _price(p.price),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
          onTap: () =>
              context.push('/owner/products/${p.id}'),
        );
      },
    );
  }

  static String _price(double price) =>
      'ETB ${price.toStringAsFixed(2)}';
}

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: SizedBox(
        width: 44,
        height: 44,
        child: ProductNetworkImage(
          url: url,
          width: 44,
          height: 44,
          placeholderIcon: Icons.inventory_2_outlined,
          placeholderSize: 20,
        ),
      ),
    );
  }
}

// ── Normal product grid (no search active) ────────────────────────────────────

class _ProductListView extends StatelessWidget {
  const _ProductListView({
    required this.items,
    required this.loading,
    required this.loadingMore,
    required this.error,
    required this.hasMore,
    required this.scrollCtrl,
    required this.onRefresh,
    required this.shopId,
  });

  final List<ProductModel> items;
  final bool loading;
  final bool loadingMore;
  final String? error;
  final bool hasMore;
  final ScrollController scrollCtrl;
  final Future<void> Function() onRefresh;
  final String shopId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (loading) return const ProductGridSkeleton();

    if (error != null && items.isEmpty) {
      return ErrorState(
        message: error!,
        onRetry: onRefresh,
      );
    }

    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_outlined,
        title: l.noProducts,
        description: l.noProductsDesc,
        actionLabel: l.addProduct,
        onAction: () => context.push('/owner/products/add'),
      );
    }

    final bottomPad = MediaQuery.viewPaddingOf(context).bottom + 88;
    // Extra slot at the end for the loading spinner or end-of-list indicator.
    final extraItem = (loadingMore || hasMore || error != null) ? 1 : 0;
    final totalSlots = items.length + extraItem;

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: onRefresh,
      child: GridView.builder(
        controller: scrollCtrl,
        padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPad),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: totalSlots,
        itemBuilder: (context, i) {
          // Last slot = pagination footer
          if (i >= items.length) {
            if (loadingMore) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            if (error != null) {
              return Center(
                child: TextButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Retry'),
                ),
              );
            }
            return const SizedBox.shrink();
          }
          return ProductCard(
            product: items[i],
            onTap: () => context.push('/owner/products/${items[i].id}'),
          );
        },
      ),
    );
  }
}
