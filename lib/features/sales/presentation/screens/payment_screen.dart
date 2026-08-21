import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../../sales/data/sales_repository.dart';
import '../cart_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _pay(String method) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final cart = ref.read(cartProvider);
    final session = ref.read(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (user, shopId) => shopId ?? user.shopId ?? '',
      orElse: () => '',
    );

    try {
      final sale = await ref.read(salesRepositoryProvider).createSale(
            shopId: shopId,
            paymentMethod: method,
            items: cart.items
                .map((i) => {
                      'product_id': i.product.id,
                      'quantity': i.quantity,
                    })
                .toList(),
          );

      ref.read(cartProvider.notifier).clear();

      if (mounted) {
        context.go('/worker/sale-complete', extra: {
          'total': sale.totalAmount,
          'payment': sale.paymentMethod,
          'saleId': sale.id,
          'productCount': sale.items.length,
          'itemCount': sale.itemCount,
        });
      }
    } on InsufficientStockError catch (e) {
      setState(() => _error = e.toUserMessage());
    } on AppError catch (e) {
      setState(() => _error = e.toUserMessage());
    } catch (_) {
      setState(() => _error = "We couldn't complete the sale. Please try again.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing sale...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.primary),
                            ),
                            Text(
                              Formatters.currency(cart.totalAmount),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          '${cart.totalItems} item${cart.totalItems > 1 ? 's' : ''}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppTheme.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'How did the customer pay?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.errorContainer,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppTheme.error, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _error!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppTheme.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Payment methods
                  _PaymentOption(
                    icon: Icons.payments_outlined,
                    label: 'Cash',
                    color: AppTheme.success,
                    onTap: () => _pay('CASH'),
                  ),
                  const SizedBox(height: 10),
                  _PaymentOption(
                    icon: Icons.phone_android_outlined,
                    label: 'Telebirr',
                    color: const Color(0xFF1565C0),
                    onTap: () => _pay('TELEBIRR'),
                  ),
                  const SizedBox(height: 10),
                  _PaymentOption(
                    icon: Icons.account_balance_outlined,
                    label: 'CBE Birr',
                    color: const Color(0xFF6A1B9A),
                    onTap: () => _pay('CBE_BIRR'),
                  ),
                  const SizedBox(height: 10),
                  _PaymentOption(
                    icon: Icons.more_horiz,
                    label: 'Other',
                    color: AppTheme.outline,
                    onTap: () => _pay('OTHER'),
                  ),
                ],
              ),
            ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.divider),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Icon(Icons.chevron_right, color: AppTheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
