import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/sales_repository.dart';
import '../../domain/sale_model.dart';

part 'sales_history_screen.g.dart';

@riverpod
Future<List<SaleListItem>> shopSales(Ref ref, String shopId) =>
    ref.watch(salesRepositoryProvider).listSales(shopId);

/// Represents a chronological group of sales for a single calendar day.
class DateGroup {
  final DateTime date; // Local calendar date (midnight)
  final List<SaleListItem> sales;

  const DateGroup({required this.date, required this.sales});
}

class SalesHistoryScreen extends ConsumerStatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  ConsumerState<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends ConsumerState<SalesHistoryScreen> {
  static const _pageSize = 30;

  final _scrollCtrl = ScrollController();

  List<SaleListItem> _items = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = false;
  int _page = 0;
  Object? _error;
  String _loadedShopId = '';

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollCtrl.position;
    if (_hasMore && !_loadingMore && pos.pixels >= pos.maxScrollExtent - 300) {
      _fetchPage(_page + 1);
    }
  }

  Future<void> _fetchPage(int page, {bool reset = false}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
        _items = []; // Clears old shop data immediately for shop isolation
      });
    } else {
      setState(() => _loadingMore = true);
    }
    try {
      final result = await ref
          .read(salesRepositoryProvider)
          .listSalesPage(_loadedShopId, page: page, pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _items = reset ? result.items : [..._items, ...result.items];
        _page = result.page;
        _hasMore = result.hasMore;
        _loading = false;
        _loadingMore = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
        _error = e;
      });
    }
  }

  void _maybeLoad(String shopId) {
    if (shopId == _loadedShopId || shopId.isEmpty) return;
    _loadedShopId = shopId;
    _fetchPage(1, reset: true);
  }

  /// Groups sales chronologically by local date.
  /// - Date groups are sorted descending (newest date first).
  /// - Sales within each date group are sorted descending (newest sale first).
  List<DateGroup> _groupSales(List<SaleListItem> items) {
    final map = <DateTime, List<SaleListItem>>{};
    for (final sale in items) {
      final local = sale.createdAt.toLocal();
      final dateKey = DateTime(local.year, local.month, local.day);
      map.putIfAbsent(dateKey, () => []).add(sale);
    }

    // Sort date keys descending (newest date first)
    final sortedKeys = map.keys.toList()..sort((a, b) => b.compareTo(a));

    return sortedKeys.map((date) {
      final groupSales = map[date]!;
      // Sort sales within each group descending by createdAt (newest sale first)
      groupSales.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return DateGroup(date: date, sales: groupSales);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, sid) => sid ?? '',
      orElse: () => '',
    );

    _maybeLoad(shopId);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(l.salesHistory),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/owner/sales');
            }
          },
        ),
      ),
      body: _buildBody(context, l, shopId),
    );
  }

  String _errorMsg(AppLocalizations l) => _error is AppError
      ? (_error as AppError).toUserMessage(l)
      : l.couldNotLoadSales;

  Widget _buildBody(BuildContext context, AppLocalizations l, String shopId) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _items.isEmpty) {
      return ErrorState(
        message: _errorMsg(l),
        onRetry: () => _fetchPage(1, reset: true),
      );
    }

    if (_items.isEmpty) {
      return EmptyState(
        icon: Icons.receipt_long_outlined,
        title: l.noSalesHistory,
        description: l.noSalesHistoryDesc,
      );
    }

    final groups = _groupSales(_items);
    final locale = Localizations.localeOf(context).languageCode;

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () => _fetchPage(1, reset: true),
      child: ListView.separated(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        // +1 for the pagination footer slot
        itemCount: groups.length + 1,
        separatorBuilder: (_, i) =>
            i < groups.length - 1 ? const SizedBox(height: 16) : const SizedBox.shrink(),
        itemBuilder: (context, i) {
          if (i >= groups.length) {
            // Footer: loading spinner or retry error
            if (_loadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }
            if (_error != null) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () => _fetchPage(_page + 1),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(l.retry),
                  ),
                ),
              );
            }
            return const SizedBox(height: 8);
          }

          return _DateGroupSection(
            group: groups[i],
            l: l,
            locale: locale,
            onSaleTap: (sale) => context.push('/owner/sales/${sale.id}'),
          );
        },
      ),
    );
  }
}

class _DateGroupSection extends StatelessWidget {
  final DateGroup group;
  final AppLocalizations l;
  final String locale;
  final void Function(SaleListItem) onSaleTap;

  const _DateGroupSection({
    required this.group,
    required this.l,
    required this.locale,
    required this.onSaleTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = Formatters.dateGroupHeader(
      group.date,
      todayLabel: l.today,
      yesterdayLabel: l.yesterday,
      locale: locale,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 6),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                  letterSpacing: 0.2,
                ),
          ),
        ),
        const Divider(color: AppTheme.divider, height: 1),
        const SizedBox(height: 10),
        ...group.sales.map(
          (sale) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SaleRow(
              sale: sale,
              onTap: () => onSaleTap(sale),
            ),
          ),
        ),
      ],
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
