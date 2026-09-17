import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/components.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../products/data/products_repository.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';
import '../../../products/presentation/screens/products_screen.dart';

class RestockScreen extends ConsumerStatefulWidget {
  final String productId;
  const RestockScreen({super.key, required this.productId});

  @override
  ConsumerState<RestockScreen> createState() => _RestockScreenState();
}

class _RestockScreenState extends ConsumerState<RestockScreen> {
  int _qty = 10;
  bool _loading = false;
  String? _error;
  bool _success = false;
  int _previousStock = 0;
  int _newStock = 0;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _confirm(String shopId, int currentStock) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(productsRepositoryProvider).restock(
            shopId: shopId,
            productId: widget.productId,
            quantity: _qty,
            reason: _reasonController.text.trim().isEmpty
                ? null
                : _reasonController.text.trim(),
          );
      ref.invalidate(productDetailProvider(shopId, widget.productId));
      ref.invalidate(ownerProductsProvider(shopId));
      if (mounted) {
        setState(() {
          _success = true;
          _previousStock = currentStock;
          _newStock = currentStock + _qty;
        });
      }
    } on AppError catch (e) {
      if (mounted) {
        setState(() => _error = e.toUserMessage(AppLocalizations.of(context)!));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            const GenericError().toUserMessage(AppLocalizations.of(context)!));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final productAsync =
        ref.watch(productDetailProvider(shopId, widget.productId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(l.restock)),
      body: _success
          ? _SuccessBody(
              l: l,
              previousStock: _previousStock,
              addedQty: _qty,
              newStock: _newStock,
              productId: widget.productId,
            )
          : productAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorState(
                message: e is AppError
                    ? e.toUserMessage(l)
                    : l.couldNotLoadProducts,
              ),
              data: (product) => SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      l.currentStockValue(product.stockQuantity),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.outline),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          Text(l.addQuantity,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 20),
                          QuantityStepper(
                            value: _qty,
                            min: 1,
                            max: 9999,
                            onChanged: (v) => setState(() => _qty = v),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  TextSpan(text: '${l.newStockResult}: '),
                                  TextSpan(
                                    text: '${product.stockQuantity + _qty}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(l.restockReason,
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reasonController,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: l.restockReasonHint,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                          borderSide: BorderSide(color: AppTheme.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                          borderSide: BorderSide(color: AppTheme.divider),
                        ),
                        counterText: '',
                        filled: true,
                        fillColor: AppTheme.surface,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.errorContainer,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        child: Text(_error!,
                            style: const TextStyle(color: AppTheme.error)),
                      ),
                      const SizedBox(height: 16),
                    ],
                    PrimaryButton(
                      label: l.confirmRestock,
                      onPressed: () => _confirm(shopId, product.stockQuantity),
                      loading: _loading,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ── Success state ──────────────────────────────────────────────────────────

class _SuccessBody extends StatelessWidget {
  final AppLocalizations l;
  final int previousStock;
  final int addedQty;
  final int newStock;
  final String productId;
  const _SuccessBody({
    required this.l,
    required this.previousStock,
    required this.addedQty,
    required this.newStock,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline,
                  color: AppTheme.primary, size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              l.restockSuccess,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 28),
            // Stock summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StockStat(
                      label: l.previousStock,
                      value: '$previousStock',
                      color: AppTheme.outline),
                  const Text('→',
                      style: TextStyle(
                          fontSize: 22,
                          color: AppTheme.outline,
                          fontWeight: FontWeight.w300)),
                  _StockStat(
                      label: '+${l.addedStock}',
                      value: '+$addedQty',
                      color: AppTheme.primary),
                  const Text('=',
                      style: TextStyle(
                          fontSize: 22,
                          color: AppTheme.outline,
                          fontWeight: FontWeight.w300)),
                  _StockStat(
                      label: l.newStockResult,
                      value: '$newStock',
                      color: AppTheme.primary),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: l.viewStockHistory,
                onPressed: () => context
                    .pushReplacement('/owner/products/$productId/stock-history'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SecondaryButton(
                label: l.backToProduct,
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StockStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: AppTheme.outline)),
      ],
    );
  }
}
