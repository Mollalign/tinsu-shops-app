import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../dashboard/data/dashboard_repository.dart';
import '../../../dashboard/domain/dashboard_model.dart';
import '../../../products/data/products_repository.dart';
import '../../../products/domain/product_model.dart';
import '../../../workers/data/workers_repository.dart';
import '../../../workers/domain/worker_model.dart';

part 'owner_dashboard_screen.g.dart';

@riverpod
Future<TodayReport> shopTodayReport(Ref ref, String shopId) =>
    ref.watch(dashboardRepositoryProvider).getShopToday(shopId);

@riverpod
Future<List<ProductModel>> dashboardLowStock(Ref ref, String shopId) =>
    ref.watch(productsRepositoryProvider).getLowStock(shopId);

@riverpod
Future<List<WorkerModel>> dashboardWorkers(Ref ref, String shopId) =>
    ref.watch(workersRepositoryProvider).listWorkers(shopId);

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (_, shopId) => shopId ?? '',
      orElse: () => '',
    );

    if (shopId.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No shop selected'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/owner/shops'),
                child: const Text('Select Shop'),
              ),
            ],
          ),
        ),
      );
    }

    final reportAsync = ref.watch(shopTodayReportProvider(shopId));
    final lowStockAsync = ref.watch(dashboardLowStockProvider(shopId));
    final workersAsync = ref.watch(dashboardWorkersProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          session.maybeWhen(
            authenticated: (u, _) => u.name.isNotEmpty ? u.name : 'Dashboard',
            orElse: () => 'Dashboard',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch Shop',
            onPressed: () => context.go('/owner/shops'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {
          ref.invalidate(shopTodayReportProvider(shopId));
          ref.invalidate(dashboardLowStockProvider(shopId));
          ref.invalidate(dashboardWorkersProvider(shopId));
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          children: [
            // ── Today's sales hero ──
            reportAsync.when(
              loading: () => _Skeleton(height: 150),
              error: (e, _) => _InlineError(
                message: e is AppError
                    ? e.toUserMessage()
                    : 'Could not load report.',
                onRetry: () =>
                    ref.invalidate(shopTodayReportProvider(shopId)),
              ),
              data: (report) => _SalesHero(report: report),
            ),
            const SizedBox(height: 20),

            // ── Low stock ──
            lowStockAsync.maybeWhen(
              data: (products) {
                if (products.isEmpty) return const SizedBox.shrink();
                return _LowStockSection(products: products);
              },
              orElse: () => const SizedBox.shrink(),
            ),

            // ── Workers today ──
            workersAsync.maybeWhen(
              data: (workers) {
                if (workers.isEmpty) return const SizedBox.shrink();
                return _WorkerSalesSection(workers: workers);
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesHero extends StatelessWidget {
  final TodayReport report;
  const _SalesHero({required this.report});

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
          const Text("Today's Sales",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            Formatters.currency(report.total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _HeroStat('${report.numberOfSales}', 'sales'),
              const SizedBox(width: 24),
              _HeroStat('${report.itemsSold}', 'items'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeroStat(this.value, this.label);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          Text(label,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      );
}

class _LowStockSection extends StatelessWidget {
  final List<ProductModel> products;
  const _LowStockSection({required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber,
                color: AppTheme.warning, size: 18),
            const SizedBox(width: 6),
            Text('Low Stock',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Column(
            children: products
                .take(8)
                .map((p) => _LowStockRow(product: p))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _LowStockRow extends StatelessWidget {
  final ProductModel product;
  const _LowStockRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(product.name,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            product.isOutOfStock ? 'Out' : '${product.stockQuantity}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: product.isOutOfStock
                  ? AppTheme.error
                  : AppTheme.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerSalesSection extends StatelessWidget {
  final List<WorkerModel> workers;
  const _WorkerSalesSection({required this.workers});

  @override
  Widget build(BuildContext context) {
    // Note: per-worker sales totals require a dedicated endpoint.
    // For now show the active workers list as a roster.
    final active = workers.where((w) => w.isActive).toList();
    if (active.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Workers',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Column(
            children: active.take(5).map((w) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.primaryContainer,
                      child: Text(
                        w.name.isNotEmpty
                            ? w.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(w.name,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  final double height;
  const _Skeleton({required this.height});

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.divider,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
      );
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const _InlineError({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.errorContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(message,
                  style: const TextStyle(
                      color: AppTheme.error, fontSize: 13)),
            ),
            if (onRetry != null)
              TextButton(
                  onPressed: onRetry,
                  child: const Text('Retry',
                      style: TextStyle(color: AppTheme.error))),
          ],
        ),
      );
}
