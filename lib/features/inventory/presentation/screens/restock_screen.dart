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

  Future<void> _confirm(String shopId, int currentStock) async {
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(productsRepositoryProvider).restock(
            shopId: shopId,
            productId: widget.productId,
            quantity: _qty,
          );
      ref.invalidate(productDetailProvider(shopId, widget.productId));
      ref.invalidate(ownerProductsProvider(shopId));
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.stockUpdated)));
        context.pop();
      }
    } on AppError catch (e) {
      if (mounted) setState(() => _error = e.toUserMessage(AppLocalizations.of(context)!));
    } catch (_) {
      if (mounted) setState(() => _error = const GenericError().toUserMessage(AppLocalizations.of(context)!));
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
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: e is AppError ? e.toUserMessage(l) : l.couldNotLoadProducts,
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
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: '${l.newStock}: '),
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
              const SizedBox(height: 32),
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(_error!, style: const TextStyle(color: AppTheme.error)),
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
