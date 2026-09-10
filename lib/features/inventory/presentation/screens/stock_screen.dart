import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../products/domain/product_model.dart';
import '../../../products/presentation/screens/products_screen.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  int _filter = 0; // 0=All, 1=Low, 2=OutOfStock

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );
    final productsAsync = ref.watch(ownerProductsProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(l.stockLabel)),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                _FilterChip(label: l.all, selected: _filter == 0, onTap: () => setState(() => _filter = 0)),
                const SizedBox(width: 8),
                _FilterChip(label: l.lowStock, selected: _filter == 1, onTap: () => setState(() => _filter = 1)),
                const SizedBox(width: 8),
                _FilterChip(label: l.outOfStock, selected: _filter == 2, onTap: () => setState(() => _filter = 2)),
              ],
            ),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorState(
                message: e is AppError ? e.toUserMessage(l) : l.couldNotLoadProducts,
                onRetry: () => ref.invalidate(ownerProductsProvider(shopId)),
              ),
              data: (products) {
                var filtered = products.where((p) => p.isActive).toList();
                if (_filter == 1) filtered = filtered.where((p) => p.isLowStock || p.isOutOfStock).toList();
                if (_filter == 2) filtered = filtered.where((p) => p.isOutOfStock).toList();
                filtered.sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));

                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: l.noProducts,
                    description: l.noProductsFilter,
                  );
                }
                return RefreshIndicator(
                  color: AppTheme.primary,
                  onRefresh: () async => ref.invalidate(ownerProductsProvider(shopId)),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) => _StockTile(
                      product: filtered[i],
                      outOfStockLabel: l.outOfStock,
                      onTap: () => context.push(
                          '/owner/products/${filtered[i].id}/restock'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _StockTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final String outOfStockLabel;
  const _StockTile({required this.product, required this.onTap, required this.outOfStockLabel});

  @override
  Widget build(BuildContext context) {
    final isOut = product.isOutOfStock;
    final isLow = product.isLowStock;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isOut
              ? AppTheme.outOfStockBg
              : isLow
                  ? AppTheme.lowStockBg
                  : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(product.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
            ),
            const SizedBox(width: 12),
            Text(
              isOut ? outOfStockLabel : '${product.stockQuantity}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isOut
                        ? AppTheme.outOfStockText
                        : isLow
                            ? AppTheme.lowStockText
                            : AppTheme.outline,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (isOut || isLow) ...[
              const SizedBox(width: 6),
              Icon(
                isOut ? Icons.error_outline : Icons.warning_amber,
                size: 16,
                color: isOut ? AppTheme.outOfStockText : AppTheme.lowStockText,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
