import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/products_repository.dart';
import '../../domain/product_model.dart';

part 'product_detail_screen.g.dart';

@riverpod
Future<ProductModel> productDetail(Ref ref, String shopId, String productId) =>
    ref.watch(productsRepositoryProvider).getProduct(shopId, productId);

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final productAsync = ref.watch(productDetailProvider(shopId, productId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(l.productLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                context.push('/owner/products/$productId/edit'),
          ),
        ],
      ),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: e is AppError ? e.toUserMessage(l) : l.couldNotLoadProducts,
          onRetry: () => ref.invalidate(productDetailProvider(shopId, productId)),
        ),
        data: (product) => _ProductDetailBody(
          product: product,
          shopId: shopId,
          l: l,
        ),
      ),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  final ProductModel product;
  final String shopId;
  final AppLocalizations l;
  const _ProductDetailBody({required this.product, required this.shopId, required this.l});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: double.infinity,
            height: 200,
            color: AppTheme.surfaceVariant,
            child: product.photoUrl != null
                ? Image.network(product.photoUrl!, fit: BoxFit.cover)
                : const Center(
                    child: Icon(Icons.shopping_bag_outlined,
                        size: 64, color: AppTheme.outline),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(product.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    _StatusBadge(product: product, l: l),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        label: l.sellingPrice,
                        value: Formatters.currency(product.price),
                        valueColor: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        label: l.currentStock,
                        value: '${product.stockQuantity}',
                        valueColor: product.isOutOfStock
                            ? AppTheme.error
                            : product.isLowStock
                                ? AppTheme.warning
                                : null,
                      ),
                    ),
                  ],
                ),
                if (product.categoryName != null) ...[
                  const SizedBox(height: 12),
                  _InfoCard(
                    label: l.categoryOptional,
                    value: product.categoryName!,
                  ),
                ],
                const SizedBox(height: 24),
                PrimaryButton(
                  label: l.restock,
                  icon: Icons.add_circle_outline,
                  onPressed: () =>
                      context.push('/owner/products/${product.id}/restock'),
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: l.editProduct,
                  icon: Icons.edit_outlined,
                  onPressed: () =>
                      context.push('/owner/products/${product.id}/edit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoCard({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProductModel product;
  final AppLocalizations l;
  const _StatusBadge({required this.product, required this.l});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    String label;
    if (product.isOutOfStock) {
      bg = AppTheme.outOfStockBg;
      fg = AppTheme.outOfStockText;
      label = l.outOfStock;
    } else if (product.isLowStock) {
      bg = AppTheme.lowStockBg;
      fg = AppTheme.lowStockText;
      label = l.lowStock;
    } else {
      bg = AppTheme.primaryContainer;
      fg = AppTheme.primary;
      label = l.inStock;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
