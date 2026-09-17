import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/sales_repository.dart';
import '../../domain/analytics_model.dart';

part 'sales_analytics_screen.g.dart';

// ─── Riverpod providers ───────────────────────────────────────────────────────

@riverpod
Future<SalesAnalytics> shopAnalytics(
  Ref ref,
  String shopId,
  AnalyticsPeriod period,
  String date,
) =>
    ref.watch(salesRepositoryProvider).getAnalytics(shopId, period, date: date.isEmpty ? null : date);

@riverpod
Future<WorkerAnalytics> shopWorkerAnalytics(
  Ref ref,
  String shopId,
  String startDate,
  String endDate,
) =>
    ref.watch(salesRepositoryProvider).getWorkerAnalytics(
          shopId,
          startDate: startDate.isEmpty ? null : startDate,
          endDate: endDate.isEmpty ? null : endDate,
        );

// ─── Screen ───────────────────────────────────────────────────────────────────

class SalesAnalyticsScreen extends ConsumerStatefulWidget {
  const SalesAnalyticsScreen({super.key});

  @override
  ConsumerState<SalesAnalyticsScreen> createState() => _SalesAnalyticsScreenState();
}

class _SalesAnalyticsScreenState extends ConsumerState<SalesAnalyticsScreen> {
  AnalyticsPeriod _period = AnalyticsPeriod.weekly;
  DateTime _referenceDate = DateTime.now();

  String get _dateStr => DateFormat('yyyy-MM-dd').format(_referenceDate);

  // Worker analytics window mirrors the time-series window — reuse dates from
  // the summary response so the two sections are always in sync.
  String _workerStart = '';
  String _workerEnd = '';

  void _onPeriodChanged(AnalyticsPeriod p) {
    setState(() {
      _period = p;
      _referenceDate = DateTime.now(); // reset to today on period change
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
      return Scaffold(appBar: AppBar(title: Text(l.salesAnalytics)));
    }

    final analyticsAsync = ref.watch(shopAnalyticsProvider(shopId, _period, _dateStr));

    // Once analytics resolve, sync worker analytics window to the same dates.
    analyticsAsync.whenData((a) {
      if (_workerStart != a.startDate || _workerEnd != a.endDate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _workerStart = a.startDate;
              _workerEnd = a.endDate;
            });
          }
        });
      }
    });

    final workerAsync = ref.watch(shopWorkerAnalyticsProvider(shopId, _workerStart, _workerEnd));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(l.salesAnalytics),
        actions: [
          // Date picker — only meaningful for daily/weekly/monthly
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
          ref.invalidate(shopAnalyticsProvider(shopId, _period, _dateStr));
          ref.invalidate(shopWorkerAnalyticsProvider(shopId, _workerStart, _workerEnd));
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          children: [
            // ── Period selector ────────────────────────────────────────────
            _PeriodSelector(current: _period, onChanged: _onPeriodChanged, l: l),
            const SizedBox(height: 16),

            // ── Summary cards ──────────────────────────────────────────────
            analyticsAsync.when(
              loading: () => const _SkeletonCard(height: 120),
              error: (e, _) => _ErrorCard(
                message: e is AppError ? e.toUserMessage(l) : l.couldNotLoadAnalytics,
                onRetry: () => ref.invalidate(shopAnalyticsProvider(shopId, _period, _dateStr)),
                l: l,
              ),
              data: (analytics) => _SummaryCards(analytics: analytics, l: l),
            ),
            const SizedBox(height: 20),

            // ── Trend chart ────────────────────────────────────────────────
            Text(l.salesTrend, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            analyticsAsync.when(
              loading: () => const _SkeletonCard(height: 200),
              error: (_, __) => const SizedBox.shrink(),
              data: (analytics) => _TrendChart(analytics: analytics, period: _period),
            ),
            const SizedBox(height: 24),

            // ── Sales by worker ────────────────────────────────────────────
            Text(l.salesByWorker, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            workerAsync.when(
              loading: () => const _SkeletonCard(height: 120),
              error: (e, _) => _ErrorCard(
                message: e is AppError ? e.toUserMessage(l) : l.couldNotLoadAnalytics,
                onRetry: () => ref.invalidate(
                    shopWorkerAnalyticsProvider(shopId, _workerStart, _workerEnd)),
                l: l,
              ),
              data: (wa) => _WorkerList(analytics: wa, l: l),
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
  const _PeriodSelector({required this.current, required this.onChanged, required this.l});

  String _label(AnalyticsPeriod p) => switch (p) {
        AnalyticsPeriod.daily => l.periodDaily,
        AnalyticsPeriod.weekly => l.periodWeekly,
        AnalyticsPeriod.monthly => l.periodMonthly,
        AnalyticsPeriod.yearly => l.periodYearly,
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
  final SalesAnalytics analytics;
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
          Text(
            l.totalSalesAmount,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.currency(analytics.totalAmount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatChip(Formatters.number(analytics.salesCount), l.sales),
              const SizedBox(width: 24),
              _StatChip(Formatters.number(analytics.itemsSold), l.itemsSold),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip(this.value, this.label);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      );
}

// ─── Trend bar chart ──────────────────────────────────────────────────────────

class _TrendChart extends StatelessWidget {
  final SalesAnalytics analytics;
  final AnalyticsPeriod period;
  const _TrendChart({required this.analytics, required this.period});

  String _barLabel(String periodStr) {
    try {
      final dt = DateTime.parse(periodStr);
      return switch (period) {
        AnalyticsPeriod.daily => DateFormat('HH:mm').format(dt),
        AnalyticsPeriod.weekly => DateFormat('EEE').format(dt),   // Mon, Tue…
        AnalyticsPeriod.monthly => DateFormat('d').format(dt),    // 1, 2, …31
        AnalyticsPeriod.yearly => DateFormat('MMM').format(dt),   // Jan, Feb…
      };
    } catch (_) {
      return periodStr;
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
          'No data',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppTheme.outline),
        ),
      );
    }

    final maxY = analytics.data
        .map((d) => d.totalAmount)
        .reduce((a, b) => a > b ? a : b);

    final bars = analytics.data.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value.totalAmount,
            color: AppTheme.primary,
            width: analytics.data.length > 20 ? 6 : 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY * 1.1,
              color: AppTheme.primaryContainer.withValues(alpha: 0.3),
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.divider),
      ),
      child: BarChart(
        BarChartData(
          barGroups: bars,
          maxY: maxY * 1.15,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY > 0 ? maxY / 4 : 1,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppTheme.divider,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final label = _barLabel(analytics.data[group.x].period);
                return BarTooltipItem(
                  '$label\n${Formatters.currency(rod.toY, compact: true)}',
                  const TextStyle(color: Colors.white, fontSize: 11),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (value, _) => Text(
                  Formatters.currency(value, compact: true),
                  style: const TextStyle(fontSize: 9, color: AppTheme.outline),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= analytics.data.length) return const SizedBox.shrink();
                  // Skip labels when too many bars to avoid crowding
                  if (analytics.data.length > 14 && i % 3 != 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _barLabel(analytics.data[i].period),
                      style: const TextStyle(fontSize: 9, color: AppTheme.outline),
                    ),
                  );
                },
                reservedSize: 22,
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}

// ─── Worker list ──────────────────────────────────────────────────────────────

class _WorkerList extends StatelessWidget {
  final WorkerAnalytics analytics;
  final AppLocalizations l;
  const _WorkerList({required this.analytics, required this.l});

  @override
  Widget build(BuildContext context) {
    if (analytics.workers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Text(l.analyticsNoWorkers,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.outline)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: analytics.workers.asMap().entries.map((e) {
          final worker = e.value;
          final isLast = e.key == analytics.workers.length - 1;
          return Column(
            children: [
              _WorkerRow(worker: worker, l: l),
              if (!isLast) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _WorkerRow extends StatelessWidget {
  final WorkerAnalyticsItem worker;
  final AppLocalizations l;
  const _WorkerRow({required this.worker, required this.l});

  @override
  Widget build(BuildContext context) {
    final initial = worker.workerName.isNotEmpty ? worker.workerName[0].toUpperCase() : '?';
    final isOwner = worker.soldByType == 'OWNER';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isOwner
                ? AppTheme.primaryContainer
                : AppTheme.surface,
            child: Text(
              initial,
              style: TextStyle(
                color: isOwner ? AppTheme.primary : AppTheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      worker.workerName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (isOwner) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          l.ownerLabel,
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  l.workerSalesSummary(
                    worker.salesCount,
                    worker.itemsSold,
                    Formatters.number(worker.totalAmount),
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.outline),
                ),
              ],
            ),
          ),
          Text(
            Formatters.currency(worker.totalAmount, compact: true),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}

// ─── Shared UI helpers ────────────────────────────────────────────────────────

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
  const _ErrorCard({required this.message, required this.onRetry, required this.l});

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
                  style: const TextStyle(color: AppTheme.error, fontSize: 13)),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text(l.retry, style: const TextStyle(color: AppTheme.error)),
            ),
          ],
        ),
      );
}
