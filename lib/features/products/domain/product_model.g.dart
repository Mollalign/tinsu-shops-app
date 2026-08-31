// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String,
      shopId: json['shop_id'] as String,
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
      sellingPrice: _numToString(json['selling_price']),
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      lowStockThreshold: (json['low_stock_threshold'] as num?)?.toInt() ?? 5,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'name': instance.name,
      'photo_url': instance.photoUrl,
      'selling_price': instance.sellingPrice,
      'stock_quantity': instance.stockQuantity,
      'low_stock_threshold': instance.lowStockThreshold,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'is_active': instance.isActive,
    };
