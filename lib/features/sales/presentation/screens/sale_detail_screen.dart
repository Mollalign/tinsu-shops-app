import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/states.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/sales_repository.dart';
import '../../domain/sale_model.dart';

part 'sale_detail_screen.g.dart';

@riverpod
Future<SaleModel> saleDetail(Ref ref, String shopId, String saleId) =>
    ref.watch(salesRepositoryProvider).getSale(shopId, saleId);

class SaleDetailScreen extends ConsumerWidget {
  final String saleId;
  const SaleDetailScreen({super.key, required this.saleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final saleAsync = ref.watch(saleDetailProvider(shopId, saleId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Sale Details')),
      body: saleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: e is AppError ? e.toUserMessage() : 'Could not load sale.',
          onRetry: () => ref.invalidate(saleDetailProvider(shopId, saleId)),
        ),
        data: (sale) => _SaleDetailBody(sale: sale),
      ),
    );
  }
}

class _SaleDetailBody extends StatelessWidget {
  final SaleModel sale;
  const _SaleDetailBody({required this.sale});

  @override
  Widget build(BuildContext context) {
    final payLabel = switch (sale.paymentMethod) {
      'CASH' => 'Cash',
      'TELEBIRR' => 'Telebirr',
      'CBE_BIRR' => 'CBE Birr',
      _ => 'Other',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sale #${sale.id.substring(0, 8).toUpperCase()}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.outline,
                    ),
              ),
              Text(
                Formatters.time(sale.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Items
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(
              children: [
                ...sale.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600)),
                                Text(
                                  '${Formatters.currency(double.tryParse(item.unitPrice) ?? 0)} × ${item.quantity}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            Formatters.currency(
                                double.tryParse(item.subtotal) ?? 0),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        Formatters.currency(sale.total),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Payment + Sold by
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(
              children: [
                _InfoRow('Payment', payLabel),
                const SizedBox(height: 8),
                _InfoRow('Sold by', sale.soldBy.name),
                const SizedBox(height: 8),
                _InfoRow('Date', Formatters.date(sale.createdAt)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.outline)),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
