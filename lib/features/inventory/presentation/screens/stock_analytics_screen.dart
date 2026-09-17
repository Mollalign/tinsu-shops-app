import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../sales/domain/analytics_model.dart';
import '../../data/stock_analytics_repository.dart';
import '../../domain/stock_analytics_model.dart';

part 'stock_analytics_screen.g.dart';

// ─── Riverpod provider ────────────────────────────────────────────────────────

@riverpod
Future<StockAnalytics> shopStockAnalytics(
  Ref ref,
  String shopId,
  AnalyticsPeriod period,
  String date,
) =>
    ref.watch(stockAnalyticsRepositoryProvider).getStockAnalytics(
          shopId,
          period,
          date: date.isEmpty ? null : date,
        );

// ─── Screen ───────────────────────────────────────────────────────────────────

class StockAnalyticsScreen extends ConsumerStatefulWidget {
  const StockAnalyticsScreen({super.key});

  @override
  ConsumerState<StockAnalyticsScreen> createState() =>
      _StockAnalyticsScreenState();
}

class _StockAnalyticsScreenState extends ConsumerState<StockAnalyticsScreen> {
  AnalyticsPeriod _period = AnalyticsPeriod.weekly;
  DateTime _referenceDate = DateTime.now();

  String get _dateStr => DateFormat('yyyy-MM-dd').format(_referenceDate);

  void _onPeriodChanged(AnalyticsPeriod p) {
    setState(() {
      _period = p;
      _referenceDate = DateTime.now();
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _referenceDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _referenceDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (_, sid) => sid ?? '',
      orElse: () => '',
    );

    if (shopId.isEmpty) {
      return Scaffold(appBar: AppBar(title: Text(l.stockAnalytics)));
    }

    final analyticsAsync =
        ref.watch(shopStockAnalyticsProvider(shopId, _period, _dateStr));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(l.stockAnalytics),
        actions: [
          IconButton(
            icon: const Icon(Icons.warehouse_outlined),
            tooltip: l.stock,
            onPressed: () => context.go('/owner/stock'),
          ),
          if (_period != AnalyticsPeriod.yearly)
            IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              tooltip: l.analyticsPickDate,
              onPressed: () => _pickDate(context),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {
          ref.invalidate(
              shopStockAnalyticsProvider(shopId, _period, _dateStr));
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
          children: [
            // ── Period selector ────────────────────────────────────────────
            _PeriodSelector(current: _period, onChanged: _onPeriodChanged, l: l),
            const SizedBox(height: 16),

            // ── Summary cards ──────────────────────────────────────────────
            analyticsAsync.when(
              loading: () => const _SkeletonCard(height: 120),
              error: (e, _) => _ErrorCard(
                message: e is AppError
                    ? e.toUserMessage(l)
                    : l.couldNotLoadStockAnalytics,
                onRetry: () => ref.invalidate(
                    shopStockAnalyticsProvider(shopId, _period, _dateStr)),
                l: l,
              ),
              data: (analytics) => _SummaryCards(analytics: analytics, l: l),
            ),
            const SizedBox(height: 20),

            // ── Movement trend chart ───────────────────────────────────────
            Text(l.stockMovementTrend,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            analyticsAsync.when(
              loading: () => const _SkeletonCard(height: 220),
              error: (_, __) => const SizedBox.shrink(),
              data: (analytics) =>
                  _StockMovementChart(analytics: analytics, period: _period, l: l),
            ),
            const SizedBox(height: 24),

            // ── Top Restocked Products ─────────────────────────────────────
            analyticsAsync.maybeWhen(
              data: (analytics) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.topRestockedProducts,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  _TopProductsList(
                    items: analytics.topRestocked,
                    isRestock: true,
                    emptyText: l.noStockAnalyticsData,
                    l: l,
                  ),
                  const SizedBox(height: 24),

                  // ── Top Sold Products ──────────────────────────────────
                  Text(l.topSoldProducts,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  _TopProductsList(
                    items: analytics.topSold,
                    isRestock: false,
                    emptyText: l.noStockAnalyticsData,
                    l: l,
                  ),
                ],
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Period selector ──────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  final AnalyticsPeriod current;
  final ValueChanged<AnalyticsPeriod> onChanged;
  final AppLocalizations l;
  const _PeriodSelector({
    required this.current,
    required this.onChanged,
    required this.l,
  });

  String _label(AnalyticsPeriod p) => switch (p) {
        AnalyticsPeriod.daily => l.today,
        AnalyticsPeriod.weekly => l.period7Days,
        AnalyticsPeriod.monthly => l.period30Days,
        AnalyticsPeriod.yearly => l.periodYear,
      };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AnalyticsPeriod.values.map((p) {
          final selected = p == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_label(p)),
              selected: selected,
              onSelected: (_) => onChanged(p),
              selectedColor: AppTheme.primary,
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppTheme.onSurface,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
              backgroundColor: AppTheme.surface,
              side: BorderSide(
                color: selected ? AppTheme.primary : AppTheme.divider,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Summary cards ────────────────────────────────────────────────────────────

class _SummaryCards extends StatelessWidget {
  final StockAnalytics analytics;
  final AppLocalizations l;
  const _SummaryCards({required this.analytics, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.stockCurrent,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.number(analytics.currentStock),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.inventory_2_outlined,
                    color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: l.stockAdded,
                  value: '+${Formatters.number(analytics.restockedUnits)}',
                  icon: Icons.add_circle_outline,
                ),
              ),
              Container(width: 1, height: 36, color: Colors.white24),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricItem(
                  label: l.stockSold,
                  value: '-${Formatters.number(analytics.soldUnits)}',
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}

// ─── Stock Movement Trend Chart ───────────────────────────────────────────────

class _StockMovementChart extends StatelessWidget {
  final StockAnalytics analytics;
  final AnalyticsPeriod period;
  final AppLocalizations l;
  const _StockMovementChart({
    required this.analytics,
    required this.period,
    required this.l,
  });

  String _barLabel(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return switch (period) {
        AnalyticsPeriod.daily => DateFormat('d MMM').format(dt),
        AnalyticsPeriod.weekly => DateFormat('EEE').format(dt),
        AnalyticsPeriod.monthly => DateFormat('d').format(dt),
        AnalyticsPeriod.yearly => DateFormat('MMM').format(dt),
      };
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (analytics.data.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Text(
          l.noStockAnalyticsData,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppTheme.outline),
        ),
      );
    }

    // Find max value for Y-axis scaling
    int maxVal = 0;
    for (final d in analytics.data) {
      if (d.restockedUnits > maxVal) maxVal = d.restockedUnits;
      if (d.soldUnits > maxVal) maxVal = d.soldUnits;
    }
    final double maxY = maxVal > 0 ? (maxVal * 1.2).toDouble() : 10.0;

    final barWidth = switch (period) {
      AnalyticsPeriod.daily => 24.0,
      AnalyticsPeriod.weekly => 12.0,
      AnalyticsPeriod.monthly => 4.0,
      AnalyticsPeriod.yearly => 8.0,
    };

    final bars = analytics.data.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barsSpace: 3,
        barRods: [
          // Rod 1: Restocked (Deep Green)
          BarChartRodData(
            toY: e.value.restockedUnits.toDouble(),
            color: AppTheme.primary,
            width: barWidth,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          ),
          // Rod 2: Sold (Blue)
          BarChartRodData(
            toY: e.value.soldUnits.toDouble(),
            color: const Color(0xFF1565C0),
            width: barWidth,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _LegendItem(color: AppTheme.primary, label: l.stockAdded),
              const SizedBox(width: 16),
              _LegendItem(color: const Color(0xFF1565C0), label: l.stockSold),
            ],
          ),
          const SizedBox(height: 12),

          // Chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: bars,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 4 ? maxY / 4 : 1,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppTheme.divider,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = analytics.data[group.x];
                      final label = _barLabel(item.date);
                      final isRestock = rodIndex == 0;
                      final type = isRestock ? l.stockAdded : l.stockSold;
                      final qty = rod.toY.toInt();
                      return BarTooltipItem(
                        '$label\n$type: $qty',
                        const TextStyle(color: Colors.white, fontSize: 11),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, _) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                            fontSize: 9, color: AppTheme.outline),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, _) {
                        final i = value.toInt();
                        if (i < 0 || i >= analytics.data.length) {
                          return const SizedBox.shrink();
                        }
                        // Skip some labels on monthly to prevent crowding
                        if (period == AnalyticsPeriod.monthly && i % 4 != 0) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _barLabel(analytics.data[i].date),
                            style: const TextStyle(
                                fontSize: 9, color: AppTheme.outline),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ─── Top Products List ────────────────────────────────────────────────────────

class _TopProductsList extends StatelessWidget {
  final List<TopStockItem> items;
  final bool isRestock;
  final String emptyText;
  final AppLocalizations l;
  const _TopProductsList({
    required this.items,
    required this.isRestock,
    required this.emptyText,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Text(
          emptyText,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppTheme.outline),
        ),
      );
    }

    final accentColor =
        isRestock ? AppTheme.primary : const Color(0xFF1565C0);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          final prefix = isRestock ? '+' : '-';

          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                title: Text(
                  item.productName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: Text(
                  l.unitsCount(item.quantity),
                  style: const TextStyle(fontSize: 12, color: AppTheme.outline),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$prefix${item.quantity}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right,
                        size: 18, color: AppTheme.outline),
                  ],
                ),
                onTap: () => context
                    .push('/owner/products/${item.productId}/stock-history'),
              ),
              if (!isLast) const Divider(height: 1, indent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── Skeleton & Error Cards ───────────────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  final double height;
  const _SkeletonCard({required this.height});

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.divider,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
      );
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l;
  const _ErrorCard({
    required this.message,
    required this.onRetry,
    required this.l,
  });

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
            TextButton(
              onPressed: onRetry,
              child: Text(l.retry,
                  style: const TextStyle(color: AppTheme.error)),
            ),
          ],
        ),
      );
}
