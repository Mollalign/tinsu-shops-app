// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_movement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryMovementModel _$InventoryMovementModelFromJson(
  Map<String, dynamic> json,
) => _InventoryMovementModel(
  id: json['id'] as String,
  shopId: json['shop_id'] as String,
  productId: json['product_id'] as String,
  type: json['type'] as String,
  quantity: (json['quantity'] as num).toInt(),
  reason: json['reason'] as String?,
  createdByType: json['created_by_type'] as String,
  createdById: json['created_by_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$InventoryMovementModelToJson(
  _InventoryMovementModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'shop_id': instance.shopId,
  'product_id': instance.productId,
  'type': instance.type,
  'quantity': instance.quantity,
  'reason': instance.reason,
  'created_by_type': instance.createdByType,
  'created_by_id': instance.createdById,
  'created_at': instance.createdAt.toIso8601String(),
};
