// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Converts a backend numeric value (int or double) to a String.
/// Used for monetary fields that the backend serializes as JSON numbers
/// but Flutter stores as String for precision-safe display.
String _numToString(dynamic v) => v?.toString() ?? '0';

@freezed
abstract class ProductModel with _$ProductModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProductModel({
    required String id,
    required String shopId,
    required String name,
    String? photoUrl,
    @JsonKey(fromJson: _numToString) required String sellingPrice,
    required int stockQuantity,
    @Default(5) int lowStockThreshold,
    // New structured category fields
    String? categoryId,
    String? categoryName,
    @Default(true) bool isActive,
    // Denormalised cache from the backend: time of the last successful sale
    // for this product in its shop. Null = never sold.
    // Used for recent-first ordering on the backend; exposed here for tests
    // and any UI indicator that may need it.
    DateTime? lastSoldAt,
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
