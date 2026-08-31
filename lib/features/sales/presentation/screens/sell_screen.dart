import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/states.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../products/data/categories_repository.dart';
import '../../../products/data/products_repository.dart';
import '../../../products/domain/category_model.dart';
import '../../../products/domain/product_model.dart';
import '../../../sales/data/sales_repository.dart';
import '../../domain/sale_model.dart';
import '../../domain/cart_item_model.dart';
import '../cart_provider.dart';

part 'sell_screen.g.dart';

@riverpod
Future<List<CategoryModel>> shopCategories(Ref ref, String shopId) =>
    ref.watch(categoriesRepositoryProvider).listCategories(shopId);

@riverpod
Future<List<ProductModel>> shopProducts(Ref ref, String shopId,
    {String? categoryId}) =>
    ref
        .watch(productsRepositoryProvider)
        .listProducts(shopId, categoryId: categoryId);

@riverpod
Future<List<ProductModel>> productSearch(
    Ref ref, String shopId, String query,
    {String? categoryId}) async {
  if (query.trim().isEmpty) return [];
  return ref
      .watch(productsRepositoryProvider)
      .searchProducts(shopId, query, categoryId: categoryId);
}

class SellScreen extends ConsumerStatefulWidget {
  const SellScreen({super.key});

  @override
  ConsumerState<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends ConsumerState<SellScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _selectedCategoryId; // null = All
  Timer? _debounce;
  bool _checkingOut = false;
  String? _checkoutError;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceMs),
      () {
        if (mounted) setState(() => _query = value.trim());
      },
    );
  }

  Future<void> _completeSale() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return;

    setState(() {
      _checkingOut = true;
      _checkoutError = null;
    });

    final session = ref.read(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (user, shopId) => shopId ?? user.shopId ?? '',
      orElse: () => '',
    );

    try {
      final sale = await ref.read(salesRepositoryProvider).createSale(
            shopId: shopId,
            items: cart.items
                .map((i) => {
                      'product_id': i.product.id,
                      'quantity': i.quantity,
                    })
                .toList(),
            idempotencyKey: ref.read(cartProvider.notifier).idempotencyKey,
          );

      // Clear cart (also resets idempotency key for next sale)
      ref.read(cartProvider.notifier).clear();

      // Refresh product stock after sale
      ref.invalidate(shopProductsProvider(shopId));

      if (mounted) {
        context.go('/worker/sale-complete', extra: {
          'total': sale.totalAmount,
          'itemCount': sale.itemCount,
          'productCount': sale.items.length,
          'saleId': sale.id,
        });
      }
    } on InsufficientStockError catch (e) {
      // Don't clear the cart — let the worker adjust
      setState(() => _checkoutError = e.toUserMessage());
    } on AppError catch (e) {
      setState(() => _checkoutError = e.toUserMessage());
    } catch (_) {
      setState(() =>
          _checkoutError = "Couldn't complete the sale. Please try again.");
    } finally {
      if (mounted) setState(() => _checkingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final cart = ref.watch(cartProvider);

    final shopId = session.maybeWhen(
      authenticated: (user, shopId) => shopId ?? user.shopId ?? '',
      orElse: () => '',
    );
    final workerName = session.maybeWhen(
      authenticated: (user, _) => user.name,
      orElse: () => '',
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _SellHeader(workerName: workerName, cart: cart),

            // ── Search ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon:
                      const Icon(Icons.search, color: AppTheme.outline),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),

            // ── Error banner ──
            if (_checkoutError != null)
              Container(
                margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppTheme.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_checkoutError!,
                          style: const TextStyle(
                              color: AppTheme.error, fontSize: 13)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          size: 16, color: AppTheme.error),
                      onPressed: () =>
                          setState(() => _checkoutError = null),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

            // ── Category filter ──
            _CategoryFilterBar(
              shopId: shopId,
              selectedId: _selectedCategoryId,
              onSelected: (id) =>
                  setState(() => _selectedCategoryId = id),
            ),

            // ── Product grid ──
            Expanded(
              child: _query.isEmpty
                  ? _ProductGrid(
                      shopId: shopId,
                      categoryId: _selectedCategoryId,
                    )
                  : _SearchResultList(
                      shopId: shopId,
                      query: _query,
                      categoryId: _selectedCategoryId,
                    ),
            ),

            // ── Cart bottom bar ──
            if (!cart.isEmpty)
              _CartBar(
                cart: cart,
                checking: _checkingOut,
                onViewCart: () => context.push('/worker/cart'),
                onComplete: _completeSale,
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────

class _SellHeader extends ConsumerWidget {
  final String workerName;
  final CartState cart;
  const _SellHeader({required this.workerName, required this.cart});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End Shift?'),
        content: const Text('This will clear your cart and log you out.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    // Clear the cart first, then log out
    ref.read(cartProvider.notifier).clear();
    await ref.read(sessionProvider.notifier).logout();
    if (context.mounted) context.go('/worker/select');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sell',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (workerName.isNotEmpty)
                  Text(
                    workerName,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.outline),
                  ),
              ],
            ),
          ),
          if (!cart.isEmpty)
            GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        size: 16, color: AppTheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${cart.totalItems}',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(width: 4),
          // Logout button
          Tooltip(
            message: 'End Shift',
            child: IconButton(
              icon: const Icon(Icons.logout, size: 22, color: AppTheme.outline),
              onPressed: () => _confirmLogout(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Cart bottom bar
// ─────────────────────────────────────────────────────────

class _CartBar extends StatelessWidget {
  final CartState cart;
  final bool checking;
  final VoidCallback onViewCart;
  final VoidCallback onComplete;

  const _CartBar({
    required this.cart,
    required this.checking,
    required this.onViewCart,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.divider)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Summary row — tappable to open cart detail
          GestureDetector(
            onTap: onViewCart,
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined,
                    size: 18, color: AppTheme.outline),
                const SizedBox(width: 6),
                Text(
                  '${cart.totalItems} item${cart.totalItems > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  Formatters.currency(cart.estimatedTotal),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right,
                    size: 18, color: AppTheme.outline),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Complete Sale button — full width, prominent
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: checking ? null : onComplete,
              child: checking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : const Text('Complete Sale',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Category filter bar
// ─────────────────────────────────────────────────────────

class _CategoryFilterBar extends ConsumerWidget {
  final String shopId;
  final String? selectedId;
  final ValueChanged<String?> onSelected;
  const _CategoryFilterBar({
    required this.shopId,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(shopCategoriesProvider(shopId));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (cats) {
        if (cats.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _CategoryChip(
                label: 'All',
                selected: selectedId == null,
                onTap: () => onSelected(null),
              ),
              ...cats.map((c) => _CategoryChip(
                    label: c.name,
                    selected: selectedId == c.id,
                    onTap: () => onSelected(c.id),
                  )),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.divider,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppTheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Product grid — tap to add
// ─────────────────────────────────────────────────────────

class _ProductGrid extends ConsumerWidget {
  final String shopId;
  final String? categoryId;
  const _ProductGrid({required this.shopId, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(shopProductsProvider(shopId, categoryId: categoryId));

    return async.when(
      loading: () => const ProductGridSkeleton(),
      error: (e, _) => ErrorState(
        message:
            e is AppError ? e.toUserMessage() : 'Could not load products.',
        onRetry: () => ref.invalidate(shopProductsProvider(shopId, categoryId: categoryId)),
      ),
      data: (products) {
        final active = products.where((p) => p.isActive).toList();
        if (active.isEmpty) {
          return const EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'No products',
            description: 'No products in this category.',
          );
        }
        return RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () async =>
              ref.invalidate(shopProductsProvider(shopId, categoryId: categoryId)),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemCount: active.length,
            itemBuilder: (context, i) => _TapProductCard(product: active[i]),
          ),
        );
      },
    );
  }
}

class _SearchResultList extends ConsumerWidget {
  final String shopId;
  final String query;
  final String? categoryId;
  const _SearchResultList(
      {required this.shopId, required this.query, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async =
        ref.watch(productSearchProvider(shopId, query, categoryId: categoryId));

    return async.when(
      loading: () => const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (e, _) => ErrorState(
        message: e is AppError ? e.toUserMessage() : 'Search failed.',
      ),
      data: (products) {
        if (products.isEmpty) {
          return const EmptyState(
            icon: Icons.search_off,
            title: 'No results',
            description: 'Try a different product name.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          itemCount: products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) =>
              _SearchProductTile(product: products[i]),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tap-to-add product card
// ─────────────────────────────────────────────────────────

class _TapProductCard extends ConsumerWidget {
  final ProductModel product;
  const _TapProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only listen to the quantity for THIS product — avoids full grid rebuild
    final qty = ref.watch(
      cartProvider.select((s) => s.quantityFor(product.id)),
    );

    final isOut = product.isOutOfStock;
    final isLow = product.isLowStock;
    final isSelected = qty > 0;

    return GestureDetector(
      onTap: isOut ? null : () => ref.read(cartProvider.notifier).addProduct(product),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Photo ──
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusMd - 1),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _ProductPhoto(url: product.photoUrl, isOut: isOut),
                    // Stock badge — top left
                    if (isOut || isLow)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: _StockBadge(isOut: isOut),
                      ),
                    // Quantity badge — top right
                    if (isSelected)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: _QtyBadge(qty: qty),
                      ),
                  ],
                ),
              ),
            ),
            // ── Info ──
            Expanded(
              flex: 3,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isOut ? AppTheme.outline : null,
                              ),
                    ),
                    Text(
                      Formatters.currency(product.price),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color:
                                isOut ? AppTheme.outline : AppTheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductPhoto extends StatelessWidget {
  final String? url;
  final bool isOut;
  const _ProductPhoto({this.url, required this.isOut});

  @override
  Widget build(BuildContext context) {
    Widget img;
    if (url != null && url!.isNotEmpty) {
      img = CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: AppTheme.surfaceVariant),
        errorWidget: (_, __, ___) => _PhotoPlaceholder(),
      );
    } else {
      img = _PhotoPlaceholder();
    }
    if (isOut) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: img,
      );
    }
    return img;
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: AppTheme.surfaceVariant,
        child: const Center(
          child: Icon(Icons.shopping_bag_outlined,
              size: 32, color: AppTheme.outline),
        ),
      );
}

class _QtyBadge extends StatelessWidget {
  final int qty;
  const _QtyBadge({required this.qty});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: Container(
        key: ValueKey(qty),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '×$qty',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final bool isOut;
  const _StockBadge({required this.isOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isOut ? AppTheme.outOfStockBg : AppTheme.lowStockBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isOut ? 'Out' : 'Low',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isOut ? AppTheme.outOfStockText : AppTheme.lowStockText,
        ),
      ),
    );
  }
}

class _SearchProductTile extends ConsumerWidget {
  final ProductModel product;
  const _SearchProductTile({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty = ref.watch(
      cartProvider.select((s) => s.quantityFor(product.id)),
    );

    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: product.isOutOfStock
            ? null
            : () => ref.read(cartProvider.notifier).addProduct(product),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: qty > 0 ? AppTheme.primary : AppTheme.divider,
              width: qty > 0 ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: _ProductPhoto(
                    url: product.photoUrl,
                    isOut: product.isOutOfStock,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                )),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.currency(product.price),
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ],
                ),
              ),
              if (qty > 0)
                _QtyBadge(qty: qty)
              else if (product.isOutOfStock)
                const Text('Out',
                    style:
                        TextStyle(color: AppTheme.error, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Skeleton for loading
// ─────────────────────────────────────────────────────────

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.divider,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      ),
    );
  }
}
