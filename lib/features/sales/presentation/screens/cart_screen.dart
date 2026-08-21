import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/states.dart';
import '../cart_provider.dart';
import '../../../products/domain/product_model.dart';
import '../../domain/cart_item_model.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Current Sale'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, ref),
              child:
                  const Text('Clear', style: TextStyle(color: AppTheme.error)),
            ),
        ],
      ),
      body: cart.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Your sale is empty',
              description: 'Tap a product to add it.',
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
                // Total + note
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    border:
                        Border(top: BorderSide(color: AppTheme.divider)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimated Total',
                              style:
                                  Theme.of(context).textTheme.titleMedium),
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
                      const SizedBox(height: 6),
                      Text(
                        'Actual total is calculated at sale time.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppTheme.outline),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('← Back to Products'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear sale?'),
        content: const Text('All items will be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clear();
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Clear',
                style: TextStyle(color: AppTheme.error)),
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
          // Name + unit price
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
                const SizedBox(height: 2),
                Text(
                  '${Formatters.currency(item.product.price)} each',
                  style: Theme.of(context).textTheme.bodySmall,
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
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? (color?.withValues(alpha: 0.1) ?? AppTheme.primaryContainer)
              : AppTheme.divider,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled
              ? (color ?? AppTheme.primary)
              : AppTheme.outline,
        ),
      ),
    );
  }
}
