import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/components.dart';
import '../../../../core/widgets/states.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/products_repository.dart';
import '../../domain/product_model.dart';

part 'products_screen.g.dart';

@riverpod
Future<List<ProductModel>> ownerProducts(Ref ref, String shopId) =>
    ref.watch(productsRepositoryProvider).listProducts(shopId);

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String v) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceMs),
      () { if (mounted) setState(() => _query = v.trim()); },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (user, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final productsAsync = ref.watch(ownerProductsProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/owner/products/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchField(
              hint: 'Search products...',
              controller: _searchCtrl,
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const ProductGridSkeleton(),
              error: (e, _) => ErrorState(
                message: e is AppError ? e.toUserMessage() : 'Could not load products.',
                onRetry: () => ref.invalidate(ownerProductsProvider(shopId)),
              ),
              data: (products) {
                var filtered = products.where((p) => p.isActive).toList();
                if (_query.isNotEmpty) {
                  filtered = filtered
                      .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
                      .toList();
                }
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: _query.isEmpty ? 'No products yet' : 'No results found',
                    description: _query.isEmpty
                        ? 'Add your first product to start selling.'
                        : 'Try a different search term.',
                    actionLabel: _query.isEmpty ? 'Add Product' : null,
                    onAction: _query.isEmpty
                        ? () => context.push('/owner/products/add')
                        : null,
                  );
                }
                return RefreshIndicator(
                  color: AppTheme.primary,
                  onRefresh: () async =>
                      ref.invalidate(ownerProductsProvider(shopId)),
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) => ProductCard(
                      product: filtered[i],
                      onTap: () =>
                          context.push('/owner/products/${filtered[i].id}'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
