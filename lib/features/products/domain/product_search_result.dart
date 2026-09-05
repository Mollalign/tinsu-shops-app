import 'product_model.dart';

/// A category whose name matched the search query.
class CategorySearchMatch {
  final String id;
  final String name;
  final int productCount;

  const CategorySearchMatch({
    required this.id,
    required this.name,
    required this.productCount,
  });

  factory CategorySearchMatch.fromJson(Map<String, dynamic> json) =>
      CategorySearchMatch(
        id: json['id'] as String,
        name: json['name'] as String,
        productCount: json['product_count'] as int,
      );
}

/// Combined result returned by `GET /products/search`.
///
/// [matchedCategory] is non-null when the search query matches a category
/// name in the shop (and no category filter was active).
/// [items] contains products whose names match the query.
class ProductSearchResult {
  final CategorySearchMatch? matchedCategory;
  final List<ProductModel> items;

  const ProductSearchResult({this.matchedCategory, required this.items});

  factory ProductSearchResult.fromJson(Map<String, dynamic> json) =>
      ProductSearchResult(
        matchedCategory: json['matched_category'] != null
            ? CategorySearchMatch.fromJson(
                json['matched_category'] as Map<String, dynamic>)
            : null,
        items: (json['items'] as List)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
