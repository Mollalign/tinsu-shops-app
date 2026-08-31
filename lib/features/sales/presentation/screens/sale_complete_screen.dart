import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class SaleCompleteScreen extends StatelessWidget {
  final Map<String, dynamic>? saleData;

  const SaleCompleteScreen({super.key, this.saleData});

  @override
  Widget build(BuildContext context) {
    final totalStr = saleData?['total'] as String? ?? '0';
    final productCount = saleData?['productCount'] as int? ?? 0;
    final itemCount = saleData?['itemCount'] as int? ?? 0;
    final amount = double.tryParse(totalStr) ?? 0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Animated check ──
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (_, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 60,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Sale Complete',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 28),
              // ── Total from backend ──
              Text(
                Formatters.currency(amount),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                '$itemCount item${itemCount != 1 ? 's' : ''}  ·  $productCount product${productCount != 1 ? 's' : ''}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppTheme.outline),
              ),
              const SizedBox(height: 48),
              // ── Done → back to sell ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/worker/sell'),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
