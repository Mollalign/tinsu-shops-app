import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/components.dart';
import '../../../../core/widgets/states.dart';
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
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (user, shopId) => shopId ?? '',
      orElse: () => '',
    );

    // Use the shared search controller (server-side, with debounce + stale protection)
    final searchState = ref.watch(productSearchControllerProvider(shopId));
    final searchCtrl =
        ref.read(productSearchControllerProvider(shopId).notifier);

    final productsAsync = ref.watch(ownerProductsProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/owner/products/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
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
                onChanged: (v) =>
                    searchCtrl.onQueryChanged(v),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search products or categories…',
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
                  : _ProductListView(
                      productsAsync: productsAsync,
                      shopId: shopId,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search results view ───────────────────────────────────────────────────────

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
    if (state.hasError) {
      return ErrorState(
        message: state.errorMessage!,
        onRetry: onRetry,
      );
    }

    if (state.results == null) {
      // First fetch not yet returned — show previous grid or skeleton
      return const ProductGridSkeleton();
    }

    final items = state.results!.items;

    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_outlined,
        title: 'No results found',
        description:
            'No products matched "${state.normalizedQuery}".\n'
            'Try a different name or category.',
      );
    }

    final bottomPad = 88.0; // FAB height + gap
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPad),
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
    if (url == null || url!.isEmpty) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: const Icon(Icons.inventory_2_outlined,
            size: 20, color: AppTheme.outline),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: Image.network(url!, width: 44, height: 44, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
                width: 44,
                height: 44,
                color: AppTheme.surfaceVariant,
                child: const Icon(Icons.broken_image_outlined,
                    size: 20, color: AppTheme.outline),
              )),
    );
  }
}

// ── Normal product grid (no search active) ────────────────────────────────────

class _ProductListView extends ConsumerWidget {
  const _ProductListView({
    required this.productsAsync,
    required this.shopId,
  });

  final AsyncValue<List<ProductModel>> productsAsync;
  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return productsAsync.when(
      loading: () => const ProductGridSkeleton(),
      error: (e, _) => ErrorState(
        message: e is AppError ? e.toUserMessage() : 'Could not load products.',
        onRetry: () => ref.invalidate(ownerProductsProvider(shopId)),
      ),
      data: (products) {
        final active = products.where((p) => p.isActive).toList();
        if (active.isEmpty) {
          return EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'No products yet',
            description: 'Add your first product to start selling.',
            actionLabel: 'Add Product',
            onAction: () => context.push('/owner/products/add'),
          );
        }
        final bottomPad = MediaQuery.viewPaddingOf(context).bottom + 88;
        return RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () async => ref.invalidate(ownerProductsProvider(shopId)),
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPad),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: active.length,
            itemBuilder: (context, i) => ProductCard(
              product: active[i],
              onTap: () => context.push('/owner/products/${active[i].id}'),
            ),
          ),
        );
      },
    );
  }
}
