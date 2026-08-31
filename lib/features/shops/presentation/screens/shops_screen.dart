import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/states.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../dashboard/data/dashboard_repository.dart';
import '../../../dashboard/domain/dashboard_model.dart';
import '../../data/shops_repository.dart';
import '../../domain/shop_model.dart';

part 'shops_screen.g.dart';

@riverpod
Future<List<ShopModel>> ownerShops(Ref ref) =>
    ref.watch(shopsRepositoryProvider).listShops();

@riverpod
Future<OwnerDashboard> ownerDashboard(Ref ref) =>
    ref.watch(dashboardRepositoryProvider).getOwnerDashboard();

class ShopsScreen extends ConsumerWidget {
  const ShopsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final ownerName = session.maybeWhen(
      authenticated: (user, _) => user.name,
      orElse: () => '',
    );
    final currentShopId = ref.read(sessionProvider.notifier).currentShopId;

    final shopsAsync = ref.watch(ownerShopsProvider);
    final dashAsync = ref.watch(ownerDashboardProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('My Shops', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/owner/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/owner/shops/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Shop'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {
          ref.invalidate(ownerShopsProvider);
          ref.invalidate(ownerDashboardProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(ownerName),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    // Overall total
                    dashAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (dash) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Today',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppTheme.primary)),
                            Text(
                              Formatters.currency(dash.grandTotal),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            shopsAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: ErrorState(
                  message: e is AppError
                      ? e.toUserMessage()
                      : 'Could not load shops.',
                  onRetry: () => ref.invalidate(ownerShopsProvider),
                ),
              ),
              data: (shops) {
                if (shops.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: EmptyState(
                      icon: Icons.store_outlined,
                      title: 'No shops yet',
                      description: 'Add your first shop to get started.',
                    ),
                  );
                }

                // Overlay daily summaries if available
                final summaries = dashAsync.maybeWhen(
                  data: (d) => {
                    for (final s in d.shops) s.shopId: s,
                  },
                  orElse: () => <String, ShopDailySummary>{},
                );

                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    16, 0, 16,
                    MediaQuery.viewPaddingOf(context).bottom + 88,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final shop = shops[i];
                        final summary = summaries[shop.id];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ShopCard(
                            shop: shop,
                            summary: summary,
                            isSelected: shop.id == currentShopId,
                            onTap: () {
                              ref
                                  .read(sessionProvider.notifier)
                                  .setCurrentShop(shop.id);
                              context.go('/owner/dashboard');
                            },
                          ),
                        );
                      },
                      childCount: shops.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _greeting(String name) {
    final h = DateTime.now().hour;
    final g = h < 12
        ? 'Good morning'
        : h < 17
            ? 'Good afternoon'
            : 'Good evening';
    return '$g, $name';
  }
}

class _ShopCard extends StatelessWidget {
  final ShopModel shop;
  final ShopDailySummary? summary;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShopCard({
    required this.shop,
    this.summary,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppTheme.primaryContainer : AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.divider,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.store,
                  color: isSelected ? Colors.white : AppTheme.outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppTheme.primary : null,
                          ),
                    ),
                    if (shop.location != null && shop.location!.isNotEmpty)
                      Text(shop.location!,
                          style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (summary != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.currency(summary!.total),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                    ),
                    Text('Today',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check_circle, color: AppTheme.primary, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
