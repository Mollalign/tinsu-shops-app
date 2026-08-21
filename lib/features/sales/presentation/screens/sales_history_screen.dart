import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/states.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/sales_repository.dart';
import '../../domain/sale_model.dart';

part 'sales_history_screen.g.dart';

@riverpod
Future<List<SaleListItem>> shopSales(Ref ref, String shopId) =>
    ref.watch(salesRepositoryProvider).listSales(shopId);

class SalesHistoryScreen extends ConsumerWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final salesAsync = ref.watch(shopSalesProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Sales')),
      body: salesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: e is AppError ? e.toUserMessage() : 'Could not load sales.',
          onRetry: () => ref.invalidate(shopSalesProvider(shopId)),
        ),
        data: (sales) {
          if (sales.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No sales yet',
              description: 'Sales will appear here after the first sale.',
            );
          }
          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () async => ref.invalidate(shopSalesProvider(shopId)),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: sales.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) => _SaleRow(
                sale: sales[i],
                onTap: () => context.push('/owner/sales/${sales[i].id}'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SaleRow extends StatelessWidget {
  final SaleListItem sale;
  final VoidCallback onTap;
  const _SaleRow({required this.sale, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.divider),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.receipt, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Formatters.time(sale.createdAt)} • ${sale.soldByName}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${sale.itemsCount} item${sale.itemsCount == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                Formatters.currency(sale.total),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: AppTheme.outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
