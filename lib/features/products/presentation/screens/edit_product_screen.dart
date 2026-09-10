import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/categories_repository.dart';
import '../../data/product_image_io.dart';
import '../../data/products_repository.dart';
import '../../domain/category_model.dart';
import '../../domain/product_model.dart';
import '../widgets/category_picker.dart';
import '../widgets/product_image_picker.dart';
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
  final _imageKey = GlobalKey<ProductImagePickerState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  bool _loading = false;
  bool _uploading = false;
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
    final l = AppLocalizations.of(context)!;
    try {
      Object? photoUrl = _absent;
      final sel = _imageKey.currentState?.selection;
      if (sel != null && sel.hasNewImage) {
        setState(() => _uploading = true);
        try {
          final compressed = await compressProductImage(sel.localFile!);
          photoUrl = await ref.read(productsRepositoryProvider).uploadProductImage(
                shopId: shopId,
                filePath: compressed.path,
              );
        } on AppError catch (e) {
          if (mounted) {
            setState(() => _error = _uploadAwareMessage(e, l, uploading: true));
          }
          return;
        } finally {
          if (mounted) setState(() => _uploading = false);
        }
      } else if (sel != null && sel.shouldClearRemote) {
        photoUrl = null;
      }

      await ref.read(productsRepositoryProvider).updateProduct(
            shopId: shopId,
            productId: widget.productId,
            name: _nameCtrl.text.trim(),
            sellingPrice: double.parse(_priceCtrl.text.trim()),
            categoryId: _categoryCleared
                ? null
                : (_selectedCategory != null ? _selectedCategory!.id : _absent),
            photoUrl: photoUrl,
          );
      ref.invalidate(productDetailProvider(shopId, widget.productId));
      ref.invalidate(ownerProductsProvider(shopId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.productUpdated)),
        );
        context.pop();
      }
    } on ImageTooLargeFailed {
      if (mounted) setState(() => _error = l.imageTooLarge);
    } on AppError catch (e) {
      if (mounted) {
        setState(() => _error = _uploadAwareMessage(e, l, uploading: false));
      }
    } finally {
      if (mounted) setState(() { _loading = false; _uploading = false; });
    }
  }

  String _uploadAwareMessage(
    AppError e,
    AppLocalizations l, {
    required bool uploading,
  }) {
    return switch (e) {
      ValidationError(:final message) => message,
      NetworkError() || ServerError() =>
        uploading ? l.imageUploadFailed : e.toUserMessage(l),
      _ => e.toUserMessage(l),
    };
  }

  Future<void> _deactivate(String shopId) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.deactivateProductTitle),
        content: Text(l.deactivateProductContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: Text(l.deactivate,
                style: const TextStyle(color: AppTheme.error)),
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
      if (mounted) setState(() => _error = e.toUserMessage(AppLocalizations.of(context)!));
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
      appBar: AppBar(title: Text(l.editProduct)),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message:
              e is AppError ? e.toUserMessage(l) : l.couldNotLoadProducts,
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
                      ProductImagePicker(
                        key: _imageKey,
                        existingUrl: product.photoUrl,
                        uploading: _uploading,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration:
                            InputDecoration(labelText: l.productName),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? l.nameRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: l.sellingPrice,
                          suffixText: 'ETB',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l.priceRequired;
                          }
                          if (double.tryParse(v.trim()) == null) {
                            return l.priceInvalid;
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
                                        l.categoryOptional,
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
                        label: l.saveChanges,
                        onPressed: () => _save(shopId, cats),
                        loading: _loading,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed:
                              _loading ? null : () => _deactivate(shopId),
                          child: Text(
                            l.deactivate,
                            style: const TextStyle(color: AppTheme.error),
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
