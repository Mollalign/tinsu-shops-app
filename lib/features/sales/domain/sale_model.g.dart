// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleItemModel _$SaleItemModelFromJson(Map<String, dynamic> json) =>
    _SaleItemModel(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: json['unitPrice'] as String,
      subtotal: json['subtotal'] as String,
    );

Map<String, dynamic> _$SaleItemModelToJson(_SaleItemModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
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
  shopId: json['shopId'] as String,
  paymentMethod: json['paymentMethod'] as String,
  totalAmount: json['totalAmount'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  soldBy: SoldByModel.fromJson(json['soldBy'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$SaleModelToJson(_SaleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopId': instance.shopId,
      'paymentMethod': instance.paymentMethod,
      'totalAmount': instance.totalAmount,
      'items': instance.items,
      'soldBy': instance.soldBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_SaleListItem _$SaleListItemFromJson(Map<String, dynamic> json) =>
    _SaleListItem(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      totalAmount: json['totalAmount'] as String,
      soldByType: json['soldByType'] as String,
      soldById: json['soldById'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SaleListItemToJson(_SaleListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopId': instance.shopId,
      'paymentMethod': instance.paymentMethod,
      'totalAmount': instance.totalAmount,
      'soldByType': instance.soldByType,
      'soldById': instance.soldById,
      'createdAt': instance.createdAt.toIso8601String(),
    };
