import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../cart_provider.dart';
import '../../../products/domain/product_model.dart';
import '../../domain/cart_item_model.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(l.currentSale),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, ref),
              child: Text(l.clear, style: const TextStyle(color: AppTheme.error)),
            ),
        ],
      ),
      body: cart.isEmpty
          ? EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: l.saleEmpty,
              description: l.saleEmptyDesc,
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) =>
                        _CartItemRow(item: cart.items[i]),
                  ),
                ),
                // Total footer
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    border:
                        Border(top: BorderSide(color: AppTheme.divider)),
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
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l.total,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            Formatters.currency(cart.estimatedTotal),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => context.pop(),
                          child: Text(l.backToProducts),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.clearSaleTitle),
        content: Text(l.clearSaleContent),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clear();
              Navigator.pop(context);
              context.pop();
            },
            child: Text(l.clear,
                style: const TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends ConsumerWidget {
  final CartItem item;
  const _CartItemRow({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.read(cartProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          // Name + price × qty
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  '${Formatters.currency(item.product.price)} × ${item.quantity}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.outline),
                ),
              ],
            ),
          ),
          // Qty stepper
          Row(
            children: [
              _StepBtn(
                icon: item.quantity > 1
                    ? Icons.remove
                    : Icons.delete_outline,
                color: item.quantity == 1 ? AppTheme.error : null,
                onTap: () => cart.decrement(item.product.id),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  '${item.quantity}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              _StepBtn(
                icon: Icons.add,
                onTap: item.quantity < item.product.stockQuantity
                    ? () => cart.increment(item.product.id)
                    : null,
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Subtotal
          Text(
            Formatters.currency(item.subtotal),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  const _StepBtn({required this.icon, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled
              ? (color?.withValues(alpha: 0.1) ?? AppTheme.primaryContainer)
              : AppTheme.divider,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? (color ?? AppTheme.primary)
              : AppTheme.outline,
        ),
      ),
    );
  }
}
