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
      setState(() { _loading = true; _error = null; });
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
      setState(() { _loading = false; _loadingMore = false; _error = e; });
    }
  }

  void _maybeLoad(String shopId) {
    if (shopId == _loadedShopId || shopId.isEmpty) return;
    _loadedShopId = shopId;
    _fetchPage(1, reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    _maybeLoad(shopId);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(l.salesHistory)),
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

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () => _fetchPage(1, reset: true),
      child: ListView.separated(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        // +1 for the pagination footer slot
        itemCount: _items.length + 1,
        separatorBuilder: (_, i) =>
            i < _items.length - 1 ? const SizedBox(height: 8) : const SizedBox.shrink(),
        itemBuilder: (context, i) {
          if (i >= _items.length) {
            // Footer: loading spinner or nothing
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
          return _SaleRow(
            sale: _items[i],
            onTap: () => context.push('/owner/sales/${_items[i].id}'),
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
