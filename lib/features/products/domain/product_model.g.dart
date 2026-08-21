// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      sellingPrice: json['sellingPrice'] as String,
      stockQuantity: (json['stockQuantity'] as num).toInt(),
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 5,
      category: json['category'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopId': instance.shopId,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'sellingPrice': instance.sellingPrice,
      'stockQuantity': instance.stockQuantity,
      'lowStockThreshold': instance.lowStockThreshold,
      'category': instance.category,
      'isActive': instance.isActive,
    };
