import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/states.dart';
import '../../../../core/widgets/language_toggle.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../products/data/categories_repository.dart';
import '../../../products/data/products_repository.dart';
import '../../../products/domain/category_model.dart';
import '../../../products/domain/product_model.dart';
import '../../../products/domain/product_search_result.dart';
import '../../../products/presentation/product_search_controller.dart';
import '../../../sales/data/sales_repository.dart';
import '../../domain/sale_model.dart';
import '../../domain/cart_item_model.dart';
import '../cart_provider.dart';

part 'sell_screen.g.dart';

/// Sentinel value for the "Recent" pseudo-category filter chip.
/// Must not collide with real category UUIDs.
const String _kRecentCategory = '__recent__';

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
Future<ProductSearchResult> productSearch(
    Ref ref, String shopId, String query,
    {String? categoryId}) async {
  if (query.trim().isEmpty) return const ProductSearchResult(items: []);
  return ref
      .watch(productsRepositoryProvider)
      .searchProducts(shopId, query, categoryId: categoryId);
}

@riverpod
Future<List<ProductModel>> recentProducts(Ref ref, String shopId) =>
    ref.watch(productsRepositoryProvider).getRecentProducts(shopId);

class SellScreen extends ConsumerStatefulWidget {
  const SellScreen({super.key});

  @override
  ConsumerState<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends ConsumerState<SellScreen> {
  final _searchCtrl = TextEditingController();
  // null = All, '__recent__' = Recent filter, otherwise = category UUID
  String? _selectedCategoryId;
  bool _checkingOut = false;
  String? _checkoutError;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String shopId, String value) {
    ref
        .read(productSearchControllerProvider(shopId).notifier)
        .onQueryChanged(value, categoryId: _effectiveCategoryId);
  }

  /// Converts __recent__ to null for the search controller (searches all).
  String? get _effectiveCategoryId =>
      _selectedCategoryId == _kRecentCategory ? null : _selectedCategoryId;


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

      // Refresh product stock and recently sold after a successful sale
      ref.invalidate(shopProductsProvider(shopId));
      ref.invalidate(recentProductsProvider(shopId));

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
      if (mounted) {
        setState(() => _checkoutError = e.toUserMessage(AppLocalizations.of(context)!));
      }
    } on AppError catch (e) {
      if (mounted) {
        setState(() => _checkoutError = e.toUserMessage(AppLocalizations.of(context)!));
      }
    } catch (_) {
      if (mounted) {
        setState(() =>
            _checkoutError = AppLocalizations.of(context)!.errorGeneric);
      }
    } finally {
      if (mounted) setState(() => _checkingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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

    // Watch the search controller — one stable notifier per shop.
    final searchState = ref.watch(productSearchControllerProvider(shopId));
    final searchNotifier =
        ref.read(productSearchControllerProvider(shopId).notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _SellHeader(workerName: workerName),

            // ── Search ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => _onSearch(shopId, v),
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
                            searchNotifier.clear();
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),

            // ── Inline search-loading bar (2 px) ──
            if (searchState.isSearching)
              const LinearProgressIndicator(
                minHeight: 2,
                color: AppTheme.primary,
                backgroundColor: AppTheme.primaryContainer,
              )
            else
              const SizedBox(height: 2),

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

            // ── Category / Recent filter chips ──
            _CategoryFilterBar(
              shopId: shopId,
              selectedId: _selectedCategoryId,
              onSelected: (id) {
                setState(() => _selectedCategoryId = id);
                // Notify controller of the category change (re-fetch if searching)
                searchNotifier.onCategoryChanged(
                  id == _kRecentCategory ? null : id,
                );
              },
            ),

            // ── Product grid or search results ──
            Expanded(
              child: searchState.hasActiveSearch
                  ? _SearchResultList(
                      searchState: searchState,
                      onRetry: searchNotifier.retry,
                      onCategorySelected: (id) {
                        _searchCtrl.clear();
                        searchNotifier.clear();
                        setState(() => _selectedCategoryId = id);
                      },
                    )
                  : _ProductGrid(
                      shopId: shopId,
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
  const _SellHeader({required this.workerName});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.endShiftTitle),
        content: Text(l.endShiftContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l.logout,
              style: const TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    ref.read(cartProvider.notifier).clear();
    await ref.read(sessionProvider.notifier).logout();
    if (context.mounted) context.go('/worker/select');
  }

  void _showAccountSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _WorkerAccountSheet(
        workerName: workerName,
        onLogout: () => _confirmLogout(context, ref),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final initial = workerName.isNotEmpty ? workerName[0].toUpperCase() : '?';

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      child: Row(
        children: [
          // ── Worker avatar & info (tappable to open profile/language sheet) ──
          Expanded(
            child: InkWell(
              onTap: () => _showAccountSheet(context, ref),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.success,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.surface, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.sell,
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
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Quick Language Toggle ──
          const LanguageToggle(compact: true),
          const SizedBox(width: 6),

          // ── End shift icon ──
          Tooltip(
            message: l.endShift,
            child: IconButton(
              icon: const Icon(Icons.exit_to_app,
                  size: 22, color: AppTheme.outline),
              onPressed: () => _confirmLogout(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerAccountSheet extends StatelessWidget {
  final String workerName;
  final VoidCallback onLogout;

  const _WorkerAccountSheet({
    required this.workerName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final initial = workerName.isNotEmpty ? workerName[0].toUpperCase() : '?';

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Worker Avatar & Name
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppTheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            workerName.isNotEmpty ? workerName : l.workerRole,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Text(
              l.workerRole,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: AppTheme.divider),
          const SizedBox(height: 16),

          // Language Selector row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.language, size: 22, color: AppTheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Text(
                    l.language,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const LanguageToggle(compact: true),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.divider),
          const SizedBox(height: 20),

          // End Shift / Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onLogout();
              },
              icon: const Icon(Icons.exit_to_app, color: AppTheme.error, size: 20),
              label: Text(
                l.endShift,
                style: const TextStyle(
                  color: AppTheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
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
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        border: Border(
            top: BorderSide(
                color: AppTheme.primary.withValues(alpha: 0.2))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Summary info — tappable to view cart detail
          Expanded(
            child: GestureDetector(
              onTap: onViewCart,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart_rounded,
                      size: 20, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${cart.totalItems} ${l.items}',
                            style: const TextStyle(
                              color: AppTheme.onSurfaceVariant,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const TextSpan(
                            text: '  ·  ',
                            style: TextStyle(
                              color: AppTheme.outline,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: Formatters.currency(cart.estimatedTotal),
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Complete Sale button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: checking ? null : onComplete,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                minimumSize: Size.zero,
              ),
              child: checking
                  ? const SizedBox(
                       width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.completeSale,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
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
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(shopCategoriesProvider(shopId));
    // Always show All + Recent even while loading or on error
    final List<CategoryModel> cats = async.maybeWhen(
      data: (c) => c,
      orElse: () => [],
    );
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _CategoryChip(
            label: l.all,
            selected: selectedId == null,
            onTap: () => onSelected(null),
          ),
          _CategoryChip(
            label: l.recent,
            icon: Icons.star_rounded,
            selected: selectedId == _kRecentCategory,
            onTap: () => onSelected(_kRecentCategory),
          ),
          ...cats.map((c) => _CategoryChip(
                label: c.name,
                selected: selectedId == c.id,
                onTap: () => onSelected(c.id),
              )),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.divider,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : AppTheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppTheme.onSurfaceVariant,
                ),
              ),
            ],
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

  bool get _isRecent => categoryId == _kRecentCategory;

  int _columns(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 840) return 5;
    if (w >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    if (_isRecent) {
      final async = ref.watch(recentProductsProvider(shopId));
      return async.when(
        loading: () => ProductGridSkeleton(columns: _columns(context)),
        error: (e, _) => ErrorState(
          message: e is AppError
              ? e.toUserMessage(l)
              : l.couldNotLoadProducts,
          onRetry: () => ref.invalidate(recentProductsProvider(shopId)),
        ),
        data: (products) {
          final active = products.where((p) => p.isActive).toList();
          if (active.isEmpty) {
            return EmptyState(
              icon: Icons.history_outlined,
              title: l.noRecentProducts,
              description: l.noRecentProductsDesc,
            );
          }
          return _buildGrid(context, ref, active,
              onRefresh: () => ref.invalidate(recentProductsProvider(shopId)));
        },
      );
    }

    // All / category
    final async =
        ref.watch(shopProductsProvider(shopId, categoryId: categoryId));
    return async.when(
      loading: () => ProductGridSkeleton(columns: _columns(context)),
      error: (e, _) => ErrorState(
        message:
            e is AppError ? e.toUserMessage(l) : l.couldNotLoadProducts,
        onRetry: () => ref
            .invalidate(shopProductsProvider(shopId, categoryId: categoryId)),
      ),
      data: (products) {
        final active = products.where((p) => p.isActive).toList();
        if (active.isEmpty) {
          return EmptyState(
            icon: Icons.inventory_2_outlined,
            title: l.noProducts,
            description: l.noProductsInCategory,
          );
        }
        return _buildGrid(context, ref, active,
            onRefresh: () => ref
                .invalidate(shopProductsProvider(shopId, categoryId: categoryId)));
      },
    );
  }

  Widget _buildGrid(
    BuildContext context,
    WidgetRef ref,
    List<ProductModel> products, {
    required VoidCallback onRefresh,
  }) {
    final cols = _columns(context);
    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () async => onRefresh(),
      child: GridView.builder(
        // 120 px of bottom padding clears cart bar + nav bar
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 120),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (context, i) => _TapProductCard(product: products[i]),
      ),
    );
  }
}

class _SearchResultList extends StatelessWidget {
  final ProductSearchState searchState;
  final VoidCallback onRetry;
  final void Function(String categoryId) onCategorySelected;

  const _SearchResultList({
    required this.searchState,
    required this.onRetry,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // Error state — keep previous results visible below the banner
    if (searchState.hasError) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.errorContainer,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.error, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    searchState.errorMessage!,
                    style: const TextStyle(color: AppTheme.error, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: onRetry,
                  child: Text(l.retry),
                ),
              ],
            ),
          ),
          // Show stale results below the error banner if available
          if (searchState.results != null && searchState.results!.items.isNotEmpty)
            Expanded(child: _ResultsBody(result: searchState.results!, onCategorySelected: onCategorySelected)),
        ],
      );
    }

    // No results yet (first fetch for this query)
    if (searchState.results == null) {
      return const SizedBox.shrink();
    }

    final result = searchState.results!;
    final hasCategoryMatch = result.matchedCategory != null;
    final hasProducts = result.items.isNotEmpty;

    if (!hasCategoryMatch && !hasProducts) {
      return EmptyState(
        icon: Icons.search_off,
        title: l.noSearchResults,
        description: l.noSearchResultsDesc(searchState.normalizedQuery),
      );
    }

    return _ResultsBody(result: result, onCategorySelected: onCategorySelected);
  }
}

/// The actual scrollable results body, extracted so it can be reused
/// by both the happy-path and the error-with-stale-results paths.
class _ResultsBody extends StatelessWidget {
  final ProductSearchResult result;
  final void Function(String categoryId) onCategorySelected;

  const _ResultsBody({
    required this.result,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final hasCategoryMatch = result.matchedCategory != null;
    final hasProducts = result.items.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      children: [
        // ── Category match banner ──
        if (hasCategoryMatch)
          _CategoryMatchBanner(
            match: result.matchedCategory!,
            onTap: () => onCategorySelected(result.matchedCategory!.id),
          ),
        // ── Section label when both exist ──
        if (hasCategoryMatch && hasProducts)
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 14, 2, 6),
            child: Text(
              l.products,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppTheme.outline, letterSpacing: 0.5),
            ),
          ),
        // ── Product tiles ──
        ...result.items.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SearchProductTile(product: p),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Category match banner
// ─────────────────────────────────────────────────────────

class _CategoryMatchBanner extends StatelessWidget {
  final CategorySearchMatch match;
  final VoidCallback onTap;

  const _CategoryMatchBanner({required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.folder_outlined,
                color: AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.outline,
                          letterSpacing: 0.4,
                        ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    match.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${match.productCount} ${l.products}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.outline),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppTheme.outline),
          ],
        ),
      ),
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
    final l = AppLocalizations.of(context)!;
    // Granular selector — only rebuilds when THIS product's qty changes
    final qty = ref.watch(
      cartProvider.select((s) => s.quantityFor(product.id)),
    );

    final isOut = product.isOutOfStock;
    final isLow = product.isLowStock;
    final isSelected = qty > 0;

    return AnimatedContainer(
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
          // ── Photo area — tap image to add to cart ──
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: isOut
                  ? null
                  : () =>
                      ref.read(cartProvider.notifier).addProduct(product),
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
                    // Cart quantity badge — top right
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
          ),

          // ── Info + controls ──
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                          color: isOut ? AppTheme.outline : null,
                        ),
                  ),

                  // Price + stock left text
                  Row(
                    children: [
                      Text(
                        Formatters.currency(product.price),
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isOut
                                  ? AppTheme.outline
                                  : AppTheme.primary,
                            ),
                      ),
                      if (isLow && !isOut) ...[
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            '· ${product.stockQuantity} left',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.lowStockText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // ── Add button or qty stepper ──
                  if (isOut)
                    // Out of stock
                    Container(
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l.outOfStock,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.outline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else if (!isSelected)
                    // + Add button
                    GestureDetector(
                      onTap: () => ref
                          .read(cartProvider.notifier)
                          .addProduct(product),
                      child: Container(
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.primary, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add,
                                size: 16, color: AppTheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              l.add,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // − qty + stepper
                    SizedBox(
                      height: 34,
                      child: Row(
                        children: [
                          _CardStepBtn(
                            icon: qty > 1
                                ? Icons.remove
                                : Icons.delete_outline,
                            color: qty == 1
                                ? AppTheme.error
                                : AppTheme.primary,
                            onTap: () => ref
                                .read(cartProvider.notifier)
                                .decrement(product.id),
                          ),
                          Expanded(
                            child: Center(
                              child: AnimatedSwitcher(
                                duration:
                                    const Duration(milliseconds: 150),
                                child: Text(
                                  '$qty',
                                  key: ValueKey(qty),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.onBackground,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _CardStepBtn(
                            icon: Icons.add,
                            color: AppTheme.primary,
                            onTap: qty < product.stockQuantity
                                ? () => ref
                                    .read(cartProvider.notifier)
                                    .increment(product.id)
                                : null,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small square step button used inside the product card.
class _CardStepBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _CardStepBtn(
      {required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled
              ? color.withValues(alpha: 0.12)
              : AppTheme.divider,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 17,
          color: enabled ? color : AppTheme.outline,
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
    final l = AppLocalizations.of(context)!;
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
                Text(l.outOfStock,
                    style: const TextStyle(color: AppTheme.outline, fontSize: 12)),
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
  final int columns;
  const ProductGridSkeleton({super.key, this.columns = 2});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
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
