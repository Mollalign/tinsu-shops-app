import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_model.freezed.dart';
part 'sale_model.g.dart';

/// Converts a backend numeric value (int or double) to a String.
/// Used for monetary fields serialized as JSON numbers by FastAPI/Pydantic
/// but stored as String in Flutter for precision-safe display.
String _numToString(dynamic v) => v?.toString() ?? '0';

@freezed
abstract class SaleItemModel with _$SaleItemModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SaleItemModel({
    required String productId,
    required String productName,
    required int quantity,
    @JsonKey(fromJson: _numToString) required String unitPrice,
    @JsonKey(fromJson: _numToString) required String subtotal,
  }) = _SaleItemModel;

  factory SaleItemModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemModelFromJson(json);
}

@freezed
abstract class SoldByModel with _$SoldByModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SoldByModel({
    required String type,
    required String id,
    required String name,
  }) = _SoldByModel;

  factory SoldByModel.fromJson(Map<String, dynamic> json) =>
      _$SoldByModelFromJson(json);
}

@freezed
abstract class SaleModel with _$SaleModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SaleModel({
    required String id,
    required String shopId,
    @JsonKey(fromJson: _numToString) required String totalAmount,
    required List<SaleItemModel> items,
    required SoldByModel soldBy,
    required DateTime createdAt,
  }) = _SaleModel;

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);
}

extension SaleModelX on SaleModel {
  double get total => double.tryParse(totalAmount) ?? 0.0;
  int get itemCount => items.fold(0, (s, i) => s + i.quantity);
}

@freezed
abstract class SaleListItem with _$SaleListItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SaleListItem({
    required String id,
    required String shopId,
    @JsonKey(fromJson: _numToString) required String totalAmount,
    required int itemsCount,
    required String soldByName,
    required DateTime createdAt,
  }) = _SaleListItem;

  factory SaleListItem.fromJson(Map<String, dynamic> json) =>
      _$SaleListItemFromJson(json);
}

extension SaleListItemX on SaleListItem {
  double get total => double.tryParse(totalAmount) ?? 0.0;
}
