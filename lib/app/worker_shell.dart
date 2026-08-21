import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/formatters.dart';
import '../features/auth/presentation/session_provider.dart';
import '../features/sales/presentation/cart_provider.dart';
import 'theme/app_theme.dart';

/// Worker shell — only two tabs: Sell and Today
class WorkerShell extends ConsumerWidget {
  final Widget child;
  const WorkerShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final location = GoRouterState.of(context).matchedLocation;

    int currentIndex = 0;
    if (location == '/worker/today') currentIndex = 1;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.divider, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (i) {
            if (i == 0) context.go('/worker/sell');
            if (i == 1) context.go('/worker/today');
          },
          destinations: [
            NavigationDestination(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.storefront_outlined),
                  if (!cart.isEmpty)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppTheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.totalItems}',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              selectedIcon: const Icon(Icons.storefront),
              label: 'Sell',
            ),
            const NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: 'Today',
            ),
          ],
        ),
      ),
    );
  }
}
