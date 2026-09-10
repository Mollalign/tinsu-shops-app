import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import 'theme/app_theme.dart';

/// Owner shell — five main tabs: Home, Products, Sales, Categories, More
class OwnerShell extends ConsumerWidget {
  final Widget child;
  const OwnerShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final l = AppLocalizations.of(context)!;

    int currentIndex = 0;
    if (location == '/owner/shops') currentIndex = 0;
    if (location == '/owner/dashboard') currentIndex = 0;
    if (location == '/owner/products') currentIndex = 1;
    if (location == '/owner/sales') currentIndex = 2;
    if (location == '/owner/categories') currentIndex = 3;
    if (location == '/owner/stock' ||
        location == '/owner/workers' ||
        location == '/owner/settings') {
      currentIndex = 4;
    }

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
            switch (i) {
              case 0:
                context.go('/owner/dashboard');
                break;
              case 1:
                context.go('/owner/products');
                break;
              case 2:
                context.go('/owner/sales');
                break;
              case 3:
                context.go('/owner/categories');
                break;
              case 4:
                context.go('/owner/settings');
                break;
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.inventory_2_outlined),
              selectedIcon: const Icon(Icons.inventory_2),
              label: l.products,
            ),
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long),
              label: l.sales,
            ),
            NavigationDestination(
              icon: const Icon(Icons.label_outlined),
              selectedIcon: const Icon(Icons.label),
              label: l.categories,
            ),
            NavigationDestination(
              icon: const Icon(Icons.more_horiz_outlined),
              selectedIcon: const Icon(Icons.more_horiz),
              label: l.more,
            ),
          ],
        ),
      ),
    );
  }
}
