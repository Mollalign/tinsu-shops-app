// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleItemModel _$SaleItemModelFromJson(Map<String, dynamic> json) =>
    _SaleItemModel(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: _numToString(json['unit_price']),
      subtotal: _numToString(json['subtotal']),
    );

Map<String, dynamic> _$SaleItemModelToJson(_SaleItemModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'subtotal': instance.subtotal,
    };

_SoldByModel _$SoldByModelFromJson(Map<String, dynamic> json) => _SoldByModel(
  type: json['type'] as String,
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$SoldByModelToJson(_SoldByModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'name': instance.name,
    };

_SaleModel _$SaleModelFromJson(Map<String, dynamic> json) => _SaleModel(
  id: json['id'] as String,
  shopId: json['shop_id'] as String,
  totalAmount: _numToString(json['total_amount']),
  items: (json['items'] as List<dynamic>)
      .map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  soldBy: SoldByModel.fromJson(json['sold_by'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$SaleModelToJson(_SaleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'total_amount': instance.totalAmount,
      'items': instance.items,
      'sold_by': instance.soldBy,
      'created_at': instance.createdAt.toIso8601String(),
    };

_SaleListItem _$SaleListItemFromJson(Map<String, dynamic> json) =>
    _SaleListItem(
      id: json['id'] as String,
      shopId: json['shop_id'] as String,
      totalAmount: _numToString(json['total_amount']),
      itemsCount: (json['items_count'] as num).toInt(),
      soldByName: json['sold_by_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SaleListItemToJson(_SaleListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'total_amount': instance.totalAmount,
      'items_count': instance.itemsCount,
      'sold_by_name': instance.soldByName,
      'created_at': instance.createdAt.toIso8601String(),
    };
