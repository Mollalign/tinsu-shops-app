import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/states.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../dashboard/data/dashboard_repository.dart';
import '../../../dashboard/domain/dashboard_model.dart';
import '../../../sales/data/sales_repository.dart';
import '../../../sales/domain/sale_model.dart';
import '../../../sales/presentation/cart_provider.dart';
import 'package:go_router/go_router.dart';


part 'worker_today_screen.g.dart';

@riverpod
Future<WorkerTodayReport> workerTodayReport(Ref ref, String shopId) =>
    ref.watch(dashboardRepositoryProvider).getWorkerToday(shopId);

@riverpod
Future<List<SaleListItem>> workerSales(Ref ref, String shopId) =>
    ref.watch(salesRepositoryProvider).listSales(shopId);

class WorkerTodayScreen extends ConsumerWidget {
  const WorkerTodayScreen({super.key});

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
    ref.read(cartProvider.notifier).clear();
    await ref.read(sessionProvider.notifier).logout();
    if (context.mounted) context.go('/worker/select');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (user, shopId) => shopId ?? user.shopId ?? '',
      orElse: () => '',
    );
    final workerName = session.maybeWhen(
      authenticated: (user, _) => user.name,
      orElse: () => '',
    );

    final reportAsync = ref.watch(workerTodayReportProvider(shopId));
    final salesAsync = ref.watch(workerSalesProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () async {
            ref.invalidate(workerTodayReportProvider(shopId));
            ref.invalidate(workerSalesProvider(shopId));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('My Sales Today',
                                  style: Theme.of(context).textTheme.headlineSmall),
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
                          Tooltip(
                            message: 'End Shift',
                            child: IconButton(
                              icon: const Icon(Icons.logout, size: 22, color: AppTheme.outline),
                              onPressed: () => _confirmLogout(context, ref),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // ── Summary card ──
                      reportAsync.when(
                        loading: () => _SummarySkeleton(),
                        error: (e, _) => _InlinError(
                          message: e is AppError
                              ? e.toUserMessage()
                              : 'Could not load today\'s report.',
                        ),
                        data: (report) => _SummaryCard(report: report),
                      ),
                      const SizedBox(height: 24),
                      Text('Recent Sales',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              salesAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  )),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: ErrorState(
                    message: e is AppError
                        ? e.toUserMessage()
                        : 'Could not load sales.',
                  ),
                ),
                data: (sales) {
                  if (sales.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'No sales yet today',
                        description:
                            'Your sales will appear here after completing a sale.',
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _SaleRow(sale: sales[i]),
                        ),
                        childCount: sales.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final WorkerTodayReport report;
  const _SummaryCard({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Formatters.currency(report.total),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Stat('${report.numberOfSales}', 'sales'),
              const SizedBox(width: 24),
              _Stat('${report.itemsSold}', 'items'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 22)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}

class _SaleRow extends StatelessWidget {
  final SaleListItem sale;
  const _SaleRow({required this.sale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_outlined,
              color: AppTheme.outline, size: 18),
          const SizedBox(width: 10),
          Text(Formatters.time(sale.createdAt),
              style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            Formatters.currency(sale.total),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}

class _SummarySkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 130,
        decoration: BoxDecoration(
          color: AppTheme.divider,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
      );
}

class _InlinError extends StatelessWidget {
  final String message;
  const _InlinError({required this.message});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.errorContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Text(message,
            style: const TextStyle(color: AppTheme.error, fontSize: 13)),
      );
}
