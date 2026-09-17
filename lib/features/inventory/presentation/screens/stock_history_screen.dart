import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/paged_result.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';
import '../../data/inventory_repository.dart';
import '../../domain/inventory_movement_model.dart';

part 'stock_history_screen.g.dart';

@riverpod
Future<PagedResult<InventoryMovementModel>> productMovements(
  Ref ref,
  String shopId,
  String productId,
) =>
    ref
        .watch(inventoryRepositoryProvider)
        .getMovements(shopId, productId);

class StockHistoryScreen extends ConsumerWidget {
  final String productId;
  const StockHistoryScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final productAsync = ref.watch(productDetailProvider(shopId, productId));
    final movementsAsync =
        ref.watch(productMovementsProvider(shopId, productId));

    final productName = productAsync.maybeWhen(
      data: (p) => p.name,
      orElse: () => l.stockHistory,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.stockHistory,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            if (productAsync.hasValue)
              Text(productName,
                  style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.outline,
                      fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      body: movementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: e is AppError
              ? e.toUserMessage(l)
              : l.couldNotLoadStockHistory,
          onRetry: () =>
              ref.invalidate(productMovementsProvider(shopId, productId)),
        ),
        data: (page) {
          if (page.items.isEmpty) {
            return EmptyState(
              icon: Icons.history,
              title: l.noStockHistory,
              description: l.noStockHistoryDesc,
            );
          }
          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () async =>
                ref.invalidate(productMovementsProvider(shopId, productId)),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
              itemCount: page.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) =>
                  _MovementTile(movement: page.items[i], l: l),
            ),
          );
        },
      ),
    );
  }
}

class _MovementTile extends StatelessWidget {
  final InventoryMovementModel movement;
  final AppLocalizations l;
  const _MovementTile({required this.movement, required this.l});

  String _typeLabel(AppLocalizations l) {
    switch (movement.type) {
      case 'RESTOCK':
        return l.movementTypeRestock;
      case 'SALE':
        return l.movementTypeSale;
      case 'ADJUSTMENT':
        return l.movementTypeAdjustment;
      case 'INITIAL':
        return l.movementTypeInitial;
      case 'RETURN':
        return l.movementTypeReturn;
      default:
        return movement.type;
    }
  }

  Color _typeColor() {
    switch (movement.type) {
      case 'RESTOCK':
        return AppTheme.primary;
      case 'SALE':
        return const Color(0xFF1565C0); // blue
      case 'ADJUSTMENT':
        return const Color(0xFFE65100); // orange
      case 'RETURN':
        return const Color(0xFF6A1B9A); // purple
      default:
        return AppTheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = movement.isPositive;
    final color = _typeColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          // Type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _typeLabel(l),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Reason / date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movement.reason != null && movement.reason!.isNotEmpty)
                  Text(
                    movement.reason!,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  Formatters.time(movement.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Quantity
          Text(
            movement.quantityDisplay,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isPositive ? AppTheme.primary : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
