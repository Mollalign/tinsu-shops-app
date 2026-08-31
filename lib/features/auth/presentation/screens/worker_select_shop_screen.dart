import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/states.dart';
import '../../../shops/domain/shop_model.dart';

part 'worker_select_shop_screen.g.dart';

/// Fetches shops via the public (no-auth) endpoint.
/// Workers haven't logged in yet, so we must NOT use the auth-injected Dio.
@riverpod
Future<List<ShopModel>> publicShops(Ref ref) async {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );
  try {
    final res = await dio.get(ApiConstants.publicShops);
    final data = res.data as List;
    return data.map((e) => ShopModel.fromJson(e as Map<String, dynamic>)).toList();
  } on DioException catch (e) {
    final status = e.response?.statusCode;
    if (status != null && status >= 500) throw ServerError(status);
    throw const NetworkError();
  }
}

class WorkerSelectShopScreen extends ConsumerWidget {
  const WorkerSelectShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopsAsync = ref.watch(publicShopsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.storefront,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Tinsu-Shops',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Select Shop',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Which shop are you working at today?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: shopsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => ErrorState(
                  message: e is AppError
                      ? e.toUserMessage()
                      : 'Could not load shops.',
                  onRetry: () => ref.invalidate(publicShopsProvider),
                ),
                data: (shops) => ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: shops.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final shop = shops[i];
                    return _ShopTile(shop: shop);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.admin_panel_settings_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Owner Login'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopTile extends StatelessWidget {
  final ShopModel shop;
  const _ShopTile({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: () {
          context.go('/worker/select-worker'
              '?shopId=${shop.id}&shopName=${Uri.encodeComponent(shop.name)}');
        },
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
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.store, color: AppTheme.primary),
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
                          ),
                    ),
                    if (shop.location != null && shop.location!.isNotEmpty)
                      Text(
                        shop.location!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
