import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/states.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../products/domain/product_model.dart';
import '../../../products/presentation/screens/products_screen.dart';

class LowStockScreen extends ConsumerWidget {
  const LowStockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final productsAsync = ref.watch(ownerProductsProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Low Stock')),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: e is AppError ? e.toUserMessage() : 'Could not load.',
        ),
        data: (products) {
          final lowStock = products
              .where((p) => p.isActive && (p.isLowStock || p.isOutOfStock))
              .toList()
            ..sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));

          if (lowStock.isEmpty) {
            return const EmptyState(
              icon: Icons.check_circle_outline,
              title: 'All products well-stocked',
              description: 'No products need attention right now.',
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lowStockBg,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber,
                          color: AppTheme.lowStockText, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${lowStock.length} products need attention',
                        style: const TextStyle(
                          color: AppTheme.lowStockText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  itemCount: lowStock.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = lowStock[i];
                    return GestureDetector(
                      onTap: () =>
                          context.push('/owner/products/${p.id}/restock'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                          border: Border.all(color: AppTheme.divider),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          )),
                                  const SizedBox(height: 4),
                                  Text(
                                    p.isOutOfStock
                                        ? 'Out of stock'
                                        : '${p.stockQuantity} remaining',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: p.isOutOfStock
                                          ? AppTheme.outOfStockText
                                          : AppTheme.lowStockText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Restock',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
