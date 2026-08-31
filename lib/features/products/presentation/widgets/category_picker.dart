import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/category_model.dart';

/// Shared bottom-sheet category picker used by Add and Edit product screens.
class CategoryPicker extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selected;
  const CategoryPicker({super.key, required this.categories, this.selected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Choose Category',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            title: const Text('No Category'),
            leading: const Icon(Icons.clear),
            selected: selected == null,
            onTap: () => Navigator.pop(context, null),
          ),
          const Divider(height: 1),
          ...categories.map((c) => ListTile(
                title: Text(c.name),
                selected: selected?.id == c.id,
                selectedColor: AppTheme.primary,
                onTap: () => Navigator.pop(context, c),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
