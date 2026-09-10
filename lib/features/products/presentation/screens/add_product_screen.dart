import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/categories_repository.dart';
import '../../data/product_image_io.dart';
import '../../data/products_repository.dart';
import '../../domain/category_model.dart';
import '../widgets/category_picker.dart';
import '../widgets/product_image_picker.dart';
import 'products_screen.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imageKey = GlobalKey<ProductImagePickerState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '0');
  CategoryModel? _selectedCategory;
  bool _loading = false;
  bool _uploading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _loading = true; _error = null; });

    final session = ref.read(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );
    final l = AppLocalizations.of(context)!;

    try {
      String? photoUrl;
      final local = _imageKey.currentState?.selection.localFile;
      if (local != null) {
        setState(() => _uploading = true);
        try {
          final compressed = await compressProductImage(local);
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
      }
      await ref.read(productsRepositoryProvider).createProduct(
            shopId: shopId,
            name: _nameCtrl.text.trim(),
            sellingPrice: double.parse(_priceCtrl.text.trim()),
            initialStock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
            categoryId: _selectedCategory?.id,
            photoUrl: photoUrl,
          );
      ref.invalidate(ownerProductsProvider(shopId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.productSaved)),
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

  Future<void> _pickCategory(List<CategoryModel> cats) async {
    final picked = await showModalBottomSheet<CategoryModel?>(
      context: context,
      builder: (_) => CategoryPicker(
        categories: cats,
        selected: _selectedCategory,
      ),
    );
    if (mounted) setState(() => _selectedCategory = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.addProduct)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImagePicker(
                key: _imageKey,
                uploading: _uploading,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: l.productName),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? l.nameRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l.sellingPrice,
                  suffixText: 'ETB',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l.priceRequired;
                  if (double.tryParse(v.trim()) == null ||
                      double.parse(v.trim()) <= 0) {
                    return l.priceInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.startingStock),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (int.tryParse(v.trim()) == null) {
                    return l.stockInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Category picker
              FutureBuilder<List<CategoryModel>>(
                future: ref
                    .read(categoriesRepositoryProvider)
                    .listCategories(shopId),
                builder: (context, snap) {
                  final cats = snap.data ?? [];
                  return InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    onTap: cats.isEmpty ? null : () => _pickCategory(cats),
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
                                  (cats.isEmpty
                                      ? l.noCategoriesForProducts
                                      : l.categoryOptional),
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
                  );
                },
              ),
              const SizedBox(height: 28),
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(_error!,
                      style: const TextStyle(color: AppTheme.error)),
                ),
                const SizedBox(height: 16),
              ],
              PrimaryButton(
                label: l.saveProduct,
                onPressed: _save,
                loading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
