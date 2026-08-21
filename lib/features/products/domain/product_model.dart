import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String shopId,
    required String name,
    String? photoUrl,
    required String sellingPrice,
    required int stockQuantity,
    @Default(5) int lowStockThreshold,
    String? category,
    @Default(true) bool isActive,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

extension ProductModelX on ProductModel {
  bool get isLowStock =>
      stockQuantity > 0 && stockQuantity <= lowStockThreshold;
  bool get isOutOfStock => stockQuantity <= 0;
  double get price => double.tryParse(sellingPrice) ?? 0.0;
}
