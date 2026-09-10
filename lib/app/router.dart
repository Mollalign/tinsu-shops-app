import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/screens/owner_login_screen.dart';
import '../features/auth/presentation/screens/owner_quick_login_screen.dart';
import '../features/auth/presentation/screens/worker_select_shop_screen.dart';
import '../features/auth/presentation/screens/worker_select_worker_screen.dart';
import '../features/auth/presentation/screens/worker_pin_screen.dart';
import '../features/auth/presentation/session_provider.dart';
import '../features/dashboard/presentation/screens/owner_dashboard_screen.dart';
import '../features/products/presentation/screens/products_screen.dart';
import '../features/products/presentation/screens/add_product_screen.dart';
import '../features/products/presentation/screens/categories_screen.dart';
import '../features/products/presentation/screens/edit_product_screen.dart';
import '../features/products/presentation/screens/product_detail_screen.dart';
import '../features/inventory/presentation/screens/stock_screen.dart';
import '../features/inventory/presentation/screens/restock_screen.dart';
import '../features/inventory/presentation/screens/low_stock_screen.dart';
import '../features/sales/presentation/screens/sell_screen.dart';
import '../features/sales/presentation/screens/cart_screen.dart';
import '../features/sales/presentation/screens/sale_complete_screen.dart';
import '../features/sales/presentation/screens/sales_history_screen.dart';
import '../features/sales/presentation/screens/sale_detail_screen.dart';
import '../features/workers/presentation/screens/workers_screen.dart';
import '../features/workers/presentation/screens/add_worker_screen.dart';
import '../features/workers/presentation/screens/worker_detail_screen.dart';
import '../features/shops/presentation/screens/shops_screen.dart';
import '../features/shops/presentation/screens/add_shop_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/domain/user_model.dart';
import 'owner_shell.dart';
import 'worker_shell.dart';

part 'router.g.dart';

/// A [ChangeNotifier] that wraps [SessionState] so GoRouter's
/// [refreshListenable] can trigger redirect re-evaluation without
/// recreating the router object on every session change.
class _SessionNotifier extends ChangeNotifier {
  _SessionNotifier(this._state);

  SessionState _state;

  SessionState get state => _state;

  void update(SessionState next) {
    if (_state == next) return;
    _state = next;
    notifyListeners();
  }
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // Keep a stable ChangeNotifier that mirrors sessionProvider.
  final notifier = _SessionNotifier(ref.read(sessionProvider));

  // Sync the notifier whenever the session changes — this tells
  // GoRouter to re-run the redirect without recreating the router.
  ref.listen<SessionState>(sessionProvider, (_, next) {
    notifier.update(next);
  });

  // Make sure the notifier is disposed with the provider.
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final path = state.matchedLocation;
      final session = notifier.state;

      return session.when(
        // Still initialising — stay on splash
        initial: () => path == '/splash' ? null : '/splash',
        loading: () => path == '/splash' ? null : '/splash',

        // Logged out
        unauthenticated: (rememberedPhone, rememberedName) {
          // Splash always navigates away
          if (path == '/splash') {
            // If we have a remembered owner phone, go to quick login
            if (rememberedPhone != null && rememberedPhone.isNotEmpty) {
              return '/owner/quick-login';
            }
            return '/login';
          }
          if (path.startsWith('/owner') ||
              path.startsWith('/worker/sell')) {
            if (rememberedPhone != null && rememberedPhone.isNotEmpty) {
              return '/owner/quick-login';
            }
            return '/login';
          }
          return null;
        },

        // Logged in
        authenticated: (user, shopId) {
          if (path == '/splash') {
            return user.role == UserRole.owner
                ? '/owner/shops'
                : '/worker/sell';
          }
          if (path == '/login' ||
              path == '/owner/quick-login' ||
              path == '/worker/select' ||
              path == '/worker/pin') {
            return user.role == UserRole.owner
                ? '/owner/shops'
                : '/worker/sell';
          }
          if (user.role == UserRole.worker && path.startsWith('/owner')) {
            return '/worker/sell';
          }
          if (user.role == UserRole.owner &&
              path == '/worker/sell') {
            return '/owner/shops';
          }
          // Owner has no shop selected yet — redirect non-shops routes to
          // /owner/shops so they must pick a shop before accessing any data.
          if (user.role == UserRole.owner &&
              (shopId == null || shopId.isEmpty) &&
              path != '/owner/shops' &&
              path != '/owner/shops/add' &&
              path != '/owner/settings' &&
              path != '/owner/dashboard') {
            return '/owner/shops';
          }
          return null;
        },
      );
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const OwnerLoginScreen()),
      GoRoute(
        path: '/owner/quick-login',
        builder: (_, state) {
          // Read current session for remembered phone/name
          final session = ref.read(sessionProvider);
          final phone = session.maybeWhen(
            unauthenticated: (phone, _) => phone ?? '',
            orElse: () => '',
          );
          final name = session.maybeWhen(
            unauthenticated: (_, name) => name ?? '',
            orElse: () => '',
          );
          return OwnerQuickLoginScreen(ownerPhone: phone, ownerName: name);
        },
      ),
      GoRoute(
          path: '/worker/select',
          builder: (_, __) => const WorkerSelectShopScreen()),
      GoRoute(
        path: '/worker/select-worker',
        builder: (context, state) {
          final shopId = state.uri.queryParameters['shopId']!;
          final shopName = state.uri.queryParameters['shopName'] ?? '';
          return WorkerSelectWorkerScreen(shopId: shopId, shopName: shopName);
        },
      ),
      GoRoute(
        path: '/worker/pin',
        builder: (context, state) {
          final shopId = state.uri.queryParameters['shopId']!;
          final workerId = state.uri.queryParameters['workerId']!;
          final workerName = state.uri.queryParameters['workerName'] ?? '';
          return WorkerPinScreen(
            shopId: shopId,
            workerId: workerId,
            workerName: workerName,
          );
        },
      ),

      // ── Worker shell (Sell only) ──
      ShellRoute(
        builder: (context, state, child) => WorkerShell(child: child),
        routes: [
          GoRoute(path: '/worker/sell', builder: (_, __) => const SellScreen()),
        ],
      ),

      // Cart — full-screen, outside shell
      GoRoute(path: '/worker/cart', builder: (_, __) => const CartScreen()),

      // Sale complete
      GoRoute(
        path: '/worker/sale-complete',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return SaleCompleteScreen(saleData: extra);
        },
      ),

      // ── Owner shell ──
      ShellRoute(
        builder: (context, state, child) => OwnerShell(child: child),
        routes: [
          GoRoute(
              path: '/owner/shops', builder: (_, __) => const ShopsScreen()),
          GoRoute(
              path: '/owner/dashboard',
              builder: (_, __) => const OwnerDashboardScreen()),
          GoRoute(
              path: '/owner/products',
              builder: (_, __) => const ProductsScreen()),
          GoRoute(
              path: '/owner/sales',
              builder: (_, __) => const SalesHistoryScreen()),
          GoRoute(
              path: '/owner/stock', builder: (_, __) => const StockScreen()),
          GoRoute(
              path: '/owner/workers',
              builder: (_, __) => const WorkersScreen()),
          GoRoute(
              path: '/owner/settings',
              builder: (_, __) => const SettingsScreen()),
        ],
      ),

      // ── Owner detail routes (outside shell) ──
      GoRoute(
          path: '/owner/categories',
          builder: (_, __) => const CategoriesScreen()),
      GoRoute(
          path: '/owner/products/add',
          builder: (_, __) => const AddProductScreen()),
      GoRoute(
        path: '/owner/products/:id',
        builder: (_, state) =>
            ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/owner/products/:id/edit',
        builder: (_, state) =>
            EditProductScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/owner/products/:id/restock',
        builder: (_, state) =>
            RestockScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(
          path: '/owner/low-stock',
          builder: (_, __) => const LowStockScreen()),
      GoRoute(
        path: '/owner/sales/:id',
        builder: (_, state) =>
            SaleDetailScreen(saleId: state.pathParameters['id']!),
      ),
      GoRoute(
          path: '/owner/workers/add',
          builder: (_, __) => const AddWorkerScreen()),
      GoRoute(
        path: '/owner/workers/:id',
        builder: (_, state) =>
            WorkerDetailScreen(workerId: state.pathParameters['id']!),
      ),
      GoRoute(
          path: '/owner/shops/add',
          builder: (_, __) => const AddShopScreen()),
    ],
  );
}
