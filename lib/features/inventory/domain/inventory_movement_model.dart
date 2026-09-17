// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_movement_model.freezed.dart';
part 'inventory_movement_model.g.dart';

@freezed
abstract class InventoryMovementModel with _$InventoryMovementModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory InventoryMovementModel({
    required String id,
    required String shopId,
    required String productId,
    required String type,
    required int quantity,
    String? reason,
    required String createdByType,
    String? createdById,
    required DateTime createdAt,
  }) = _InventoryMovementModel;

  factory InventoryMovementModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryMovementModelFromJson(json);
}

extension InventoryMovementModelX on InventoryMovementModel {
  bool get isPositive => quantity >= 0;
  String get quantityDisplay => quantity >= 0 ? '+$quantity' : '$quantity';
}
