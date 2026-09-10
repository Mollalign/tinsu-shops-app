import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/widgets/states.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/session_provider.dart';
import '../../data/categories_repository.dart';
import '../../domain/category_model.dart';

part 'categories_screen.g.dart';

@riverpod
Future<List<CategoryModel>> ownerCategories(Ref ref, String shopId) =>
    ref.watch(categoriesRepositoryProvider).listCategories(shopId);

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final session = ref.watch(sessionProvider);
    final shopId = session.maybeWhen(
      authenticated: (u, shopId) => shopId ?? '',
      orElse: () => '',
    );
    final catsAsync = ref.watch(ownerCategoriesProvider(shopId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(l.categories)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref, shopId, l),
        icon: const Icon(Icons.add),
        label: Text(l.addCategory),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        top: false,
        child: catsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(
            message: e is AppError ? e.toUserMessage(l) : l.couldNotLoadCategories,
            onRetry: () => ref.invalidate(ownerCategoriesProvider(shopId)),
          ),
          data: (cats) {
            if (cats.isEmpty) {
              return EmptyState(
                icon: Icons.label_outline,
                title: l.noCategoriesYet,
                description: l.noCategoriesDesc,
              );
            }
            final bottomPad = MediaQuery.viewPaddingOf(context).bottom + 88;
            return ListView.separated(
              padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad),
              itemCount: cats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) => _CategoryTile(
                category: cats[i],
                shopId: shopId,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref, String shopId, AppLocalizations l) {
    final ctrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.addCategory),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l.categoryName,
            hintText: l.categoryHint,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel)),
          TextButton(
            onPressed: () async {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(ctx);
              try {
                await ref
                    .read(categoriesRepositoryProvider)
                    .createCategory(shopId, name);
                ref.invalidate(ownerCategoriesProvider(shopId));
              } on AppError catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toUserMessage(AppLocalizations.of(context)!))),
                  );
                }
              }
            },
            child: Text(l.save),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  final CategoryModel category;
  final String shopId;
  const _CategoryTile({required this.category, required this.shopId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.label_outline, color: AppTheme.primary),
        title: Text(category.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _showRenameDialog(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: 20, color: AppTheme.error),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final ctrl = TextEditingController(text: category.name);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.renameCategory),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l.newName),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel)),
          TextButton(
            onPressed: () async {
              final name = ctrl.text.trim();
              if (name.isEmpty || name == category.name) {
                Navigator.pop(ctx);
                return;
              }
              Navigator.pop(ctx);
              try {
                await ref
                    .read(categoriesRepositoryProvider)
                    .updateCategory(shopId, category.id, name);
                ref.invalidate(ownerCategoriesProvider(shopId));
              } on AppError catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toUserMessage(AppLocalizations.of(context)!))),
                  );
                }
              }
            },
            child: Text(l.rename),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteCategoryTitle(category.name)),
        content: Text(l.deleteCategoryContent),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete,
                style: const TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(categoriesRepositoryProvider)
          .deleteCategory(shopId, category.id);
      ref.invalidate(ownerCategoriesProvider(shopId));
    } on AppError catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toUserMessage(AppLocalizations.of(context)!))),
        );
      }
    }
  }
}
