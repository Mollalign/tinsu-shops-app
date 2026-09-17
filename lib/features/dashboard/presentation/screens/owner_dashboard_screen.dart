import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../products/data/products_repository.dart';
import '../../../products/domain/product_model.dart';
import '../../../shops/data/shops_repository.dart';
import '../../../shops/domain/shop_model.dart';
import '../../../workers/data/workers_repository.dart';
import '../../../workers/domain/worker_model.dart';
import '../../data/dashboard_repository.dart';
import '../../domain/dashboard_model.dart';

part 'owner_dashboard_screen.g.dart';

@riverpod
Future<HomeSummary> shopHomeSummary(Ref ref, String shopId) =>
    ref.watch(dashboardRepositoryProvider).getHomeSummary(shopId);

@riverpod
Future<TodayReport> shopTodayReport(Ref ref, String shopId) =>
    ref.watch(dashboardRepositoryProvider).getShopToday(shopId);

@riverpod
Future<List<ProductModel>> dashboardLowStock(Ref ref, String shopId) =>
    ref.watch(productsRepositoryProvider).getLowStock(shopId);

@riverpod
Future<List<WorkerModel>> dashboardWorkers(Ref ref, String shopId) =>
    ref.watch(workersRepositoryProvider).listWorkers(shopId);

@riverpod
Future<List<ShopModel>> dashboardShops(Ref ref) =>
    ref.watch(shopsRepositoryProvider).listShops();

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  String _greetingPrefix(AppLocalizations l) {
    final h = DateTime.now().hour;
    if (h < 12) return l.goodMorningGreeting;
    if (h < 17) return l.goodAfternoonGreeting;
    return l.goodEveningGreeting;
  }

  void _showShopSelector(
    BuildContext context,
    WidgetRef ref,
    String currentShopId,
    List<ShopModel> shops,
    AppLocalizations l,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l.selectShopSheet,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.push('/owner/shops/add');
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l.addShop),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: shops.length,
                    itemBuilder: (context, i) {
                      final s = shops[i];
                      final isSelected = s.id == currentShopId;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? AppTheme.primary
                              : AppTheme.primaryContainer,
                          child: Icon(
                            Icons.storefront,
                            color: isSelected ? Colors.white : AppTheme.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          s.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppTheme.primary : AppTheme.onSurface,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: AppTheme.primary)
                            : null,
                        onTap: () {
                          ref.read(sessionProvider.notifier).setCurrentShop(s.id);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (_, sid) => sid ?? '',
      orElse: () => '',
    );
    final ownerName = session.maybeWhen(
      authenticated: (u, _) => u.name,
      orElse: () => '',
    );

    if (shopId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/owner/shops');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final summaryAsync = ref.watch(shopHomeSummaryProvider(shopId));
    final shopsAsync = ref.watch(dashboardShopsProvider);

    // Resolve current shop name
    final shops = shopsAsync.value ?? [];
    final currentShop = shops.where((s) => s.id == shopId).firstOrNull;
    final shopName = currentShop?.name ?? l.myShops;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () async {
            ref.invalidate(shopHomeSummaryProvider(shopId));
            ref.invalidate(dashboardShopsProvider);
          },
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                children: [
                  // ── Header (Greeting + Owner Name + Shop Switcher + Profile) ──
                  _HeaderSection(
                    greeting: _greetingPrefix(l),
                    ownerName: ownerName.isNotEmpty ? ownerName : 'Owner',
                    shopName: shopName,
                    onShopTap: () => _showShopSelector(context, ref, shopId, shops, l),
                    onProfileTap: () => context.go('/owner/settings'),
                  ),
                  const SizedBox(height: 20),

                  // ── Today's Sales Hero Card ─────────────────────────────────
                  summaryAsync.when(
                    loading: () => const _Skeleton(height: 170),
                    error: (e, _) => _InlineError(
                      message: e is AppError ? e.toUserMessage(l) : l.couldNotLoadHome,
                      onRetry: () => ref.invalidate(shopHomeSummaryProvider(shopId)),
                      retryLabel: l.retry,
                    ),
                    data: (summary) => _TodaySalesHeroCard(
                      summary: summary,
                      l: l,
                      onAnalyticsTap: () => context.push('/owner/sales'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Quick Actions ────────────────────────────────────────────
                  _QuickActionsGrid(l: l),
                  const SizedBox(height: 24),

                  // ── Low Stock ────────────────────────────────────────────────
                  summaryAsync.maybeWhen(
                    data: (summary) => _LowStockSection(
                      items: summary.lowStock,
                      l: l,
                      onViewAll: () => context.push('/owner/stock'),
                      onItemTap: (id) => context.push('/owner/products/$id/restock'),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),

                  // ── Recent Sales ─────────────────────────────────────────────
                  summaryAsync.maybeWhen(
                    data: (summary) => _RecentSalesSection(
                      sales: summary.recentSales,
                      l: l,
                      onViewAll: () => context.push('/owner/sales/history'),
                      onSaleTap: (id) => context.push('/owner/sales/$id'),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header Section ───────────────────────────────────────────────────────────

class _HeaderSection extends StatelessWidget {
  final String greeting;
  final String ownerName;
  final String shopName;
  final VoidCallback onShopTap;
  final VoidCallback onProfileTap;

  const _HeaderSection({
    required this.greeting,
    required this.ownerName,
    required this.shopName,
    required this.onShopTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.outline,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                ownerName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onBackground,
                      fontSize: 24,
                      letterSpacing: -0.3,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Compact tactile shop selector chip
              Material(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  onTap: onShopTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.storefront_outlined,
                          color: AppTheme.primary,
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            shopName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onBackground,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppTheme.outline,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Subtle owner profile avatar on top right
        Material(
          color: AppTheme.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onProfileTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surface,
                border: Border.all(color: AppTheme.divider),
              ),
              child: Center(
                child: ownerName.isNotEmpty
                    ? Text(
                        ownerName[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      )
                    : const Icon(
                        Icons.person_outline_rounded,
                        color: AppTheme.primary,
                        size: 20,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Today's Sales Hero Card ──────────────────────────────────────────────────

class _TodaySalesHeroCard extends StatelessWidget {
  final HomeSummary summary;
  final AppLocalizations l;
  final VoidCallback onAnalyticsTap;

  const _TodaySalesHeroCard({
    required this.summary,
    required this.l,
    required this.onAnalyticsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.primary,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg + 4),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg + 4),
        onTap: onAnalyticsTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B6B3A), Color(0xFF14532D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg + 4),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.todaySales,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4ADE80),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                Formatters.currency(summary.today.total),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _HeroStatItem(
                    value: Formatters.number(summary.today.numberOfSales),
                    label: l.sales,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '·',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _HeroStatItem(
                    value: Formatters.number(summary.today.itemsSold),
                    label: l.items,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    l.viewAnalytics,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroStatItem extends StatelessWidget {
  final String value;
  final String label;

  const _HeroStatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  final AppLocalizations l;

  const _QuickActionsGrid({required this.l});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.quickActions,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 520;
            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      label: l.addProduct,
                      icon: Icons.add_circle_outline_rounded,
                      onTap: () => context.push('/owner/products/add'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionButton(
                      label: l.addStock,
                      icon: Icons.inventory_2_outlined,
                      onTap: () => context.push('/owner/stock'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionButton(
                      label: l.addWorker,
                      icon: Icons.person_add_outlined,
                      onTap: () => context.push('/owner/workers/add'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionButton(
                      label: l.salesHistory,
                      icon: Icons.receipt_long_outlined,
                      onTap: () => context.push('/owner/sales/history'),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        label: l.addProduct,
                        icon: Icons.add_circle_outline_rounded,
                        onTap: () => context.push('/owner/products/add'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickActionButton(
                        label: l.addStock,
                        icon: Icons.inventory_2_outlined,
                        onTap: () => context.push('/owner/stock'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        label: l.addWorker,
                        icon: Icons.person_add_outlined,
                        onTap: () => context.push('/owner/workers/add'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickActionButton(
                        label: l.salesHistory,
                        icon: Icons.receipt_long_outlined,
                        onTap: () => context.push('/owner/sales/history'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primary, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                        fontSize: 13,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Low Stock Section ────────────────────────────────────────────────────────

class _LowStockSection extends StatelessWidget {
  final List<HomeLowStockItem> items;
  final AppLocalizations l;
  final VoidCallback onViewAll;
  final void Function(String id) onItemTap;

  const _LowStockSection({
    required this.items,
    required this.l,
    required this.onViewAll,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppTheme.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      l.lowStock,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                            fontSize: 16,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (items.isNotEmpty)
              InkWell(
                onTap: onViewAll,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Text(
                    l.viewAll,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: items.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: AppTheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.allStockLooksGood,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l.allStockLooksGoodDesc,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: items.asMap().entries.map((e) {
                    final p = e.value;
                    final isLast = e.key == items.length - 1;
                    final isOut = p.isOutOfStock || p.stockQuantity <= 0;
                    return Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.vertical(
                            top: e.key == 0 ? const Radius.circular(AppTheme.radiusLg) : Radius.zero,
                            bottom: isLast ? const Radius.circular(AppTheme.radiusLg) : Radius.zero,
                          ),
                          onTap: () => onItemTap(p.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    p.name,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.onSurface,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isOut ? AppTheme.outOfStockBg : AppTheme.lowStockBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isOut ? l.outOfStock : l.stockLeft(p.stockQuantity),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: isOut ? AppTheme.outOfStockText : AppTheme.lowStockText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

// ─── Recent Sales Section ─────────────────────────────────────────────────────

class _RecentSalesSection extends StatelessWidget {
  final List<HomeRecentSaleItem> sales;
  final AppLocalizations l;
  final VoidCallback onViewAll;
  final void Function(String id) onSaleTap;

  const _RecentSalesSection({
    required this.sales,
    required this.l,
    required this.onViewAll,
    required this.onSaleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      l.recentSales,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                            fontSize: 16,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (sales.isNotEmpty)
              InkWell(
                onTap: onViewAll,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Text(
                    l.viewAll,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: sales.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          color: AppTheme.outline,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.noSalesYetHome,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l.noSalesRecordedHomeDesc,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: sales.asMap().entries.map((e) {
                    final s = e.value;
                    final isLast = e.key == sales.length - 1;
                    return Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.vertical(
                            top: e.key == 0 ? const Radius.circular(AppTheme.radiusLg) : Radius.zero,
                            bottom: isLast ? const Radius.circular(AppTheme.radiusLg) : Radius.zero,
                          ),
                          onTap: () => onSaleTap(s.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${Formatters.time(s.createdAt)} · ${s.soldByName}',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.onSurface,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${s.itemsCount} ${l.items.toLowerCase()}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppTheme.outline,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  Formatters.currency(s.total),
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppTheme.outline,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _Skeleton extends StatelessWidget {
  final double height;
  const _Skeleton({required this.height});

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.divider.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg + 4),
        ),
      );
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  const _InlineError({required this.message, this.onRetry, this.retryLabel});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.errorContainer.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: AppTheme.error.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppTheme.error, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppTheme.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(
                  retryLabel ?? 'Retry',
                  style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
      );
}
