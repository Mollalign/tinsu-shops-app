import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/states.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/categories_repository.dart';
import '../../data/products_repository.dart';
import '../../domain/category_model.dart';
import '../../domain/product_model.dart';
import '../widgets/category_picker.dart';
import 'product_detail_screen.dart';
import 'products_screen.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final String productId;
  const EditProductScreen({super.key, required this.productId});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  bool _loading = false;
  String? _error;
  bool _initialized = false;
  CategoryModel? _selectedCategory;
  bool _categoryCleared = false; // user explicitly cleared it

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _initialize(ProductModel product, List<CategoryModel> cats) {
    if (!_initialized) {
      _nameCtrl.text = product.name;
      _priceCtrl.text = product.price.toStringAsFixed(2);
      if (product.categoryId != null) {
        _selectedCategory = cats.where((c) => c.id == product.categoryId).firstOrNull;
      }
      _initialized = true;
    }
  }

  Future<void> _pickCategory(List<CategoryModel> cats) async {
    final picked = await showModalBottomSheet<CategoryModel?>(
      context: context,
      builder: (_) => CategoryPicker(
        categories: cats,
        selected: _selectedCategory,
      ),
    );
    if (mounted) {
      setState(() {
        _selectedCategory = picked;
        _categoryCleared = picked == null;
      });
    }
  }

  Future<void> _save(String shopId, List<CategoryModel> cats) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(productsRepositoryProvider).updateProduct(
            shopId: shopId,
            productId: widget.productId,
            name: _nameCtrl.text.trim(),
            sellingPrice: double.parse(_priceCtrl.text.trim()),
            // Send category_id only if user touched it
            categoryId: _categoryCleared
                ? null // explicit null to clear
                : (_selectedCategory != null ? _selectedCategory!.id : _absent),
          );
      ref.invalidate(productDetailProvider(shopId, widget.productId));
      ref.invalidate(ownerProductsProvider(shopId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated')),
        );
        context.pop();
      }
    } on AppError catch (e) {
      setState(() => _error = e.toUserMessage());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deactivate(String shopId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Deactivate Product?'),
        content: const Text(
            'This product will be hidden. Historical sales are preserved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text('Deactivate',
                style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _loading = true);
    try {
      await ref
          .read(productsRepositoryProvider)
          .deactivateProduct(shopId, widget.productId);
      ref.invalidate(ownerProductsProvider(shopId));
      if (mounted) context.go('/owner/products');
    } on AppError catch (e) {
      setState(() => _error = e.toUserMessage());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    final productAsync =
        ref.watch(productDetailProvider(shopId, widget.productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message:
              e is AppError ? e.toUserMessage() : 'Could not load product.',
        ),
        data: (product) {
          return FutureBuilder<List<CategoryModel>>(
            future: ref
                .read(categoriesRepositoryProvider)
                .listCategories(shopId),
            builder: (context, snap) {
              final cats = snap.data ?? [];
              _initialize(product, cats);
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Product name'),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Selling price',
                          suffixText: 'ETB',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Price is required';
                          }
                          if (double.tryParse(v.trim()) == null) {
                            return 'Enter a valid price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (cats.isNotEmpty)
                        InkWell(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                          onTap: () => _pickCategory(cats),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                              border: Border.all(color: AppTheme.divider),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedCategory?.name ??
                                        'Category (optional)',
                                    style: TextStyle(
                                      color: _selectedCategory != null
                                          ? AppTheme.onBackground
                                          : AppTheme.outline,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down,
                                    color: AppTheme.outline),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 28),
                      if (_error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.errorContainer,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                          ),
                          child: Text(_error!,
                              style:
                                  const TextStyle(color: AppTheme.error)),
                        ),
                        const SizedBox(height: 16),
                      ],
                      PrimaryButton(
                        label: 'Save Changes',
                        onPressed: () => _save(shopId, cats),
                        loading: _loading,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed:
                              _loading ? null : () => _deactivate(shopId),
                          child: const Text(
                            'Deactivate Product',
                            style: TextStyle(color: AppTheme.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Sentinel — same instance used in products_repository.dart.
const Object _absent = Object();
