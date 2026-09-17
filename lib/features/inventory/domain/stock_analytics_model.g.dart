// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockAnalyticsDataPoint _$StockAnalyticsDataPointFromJson(
  Map<String, dynamic> json,
) => _StockAnalyticsDataPoint(
  date: json['date'] as String,
  restockedUnits: (json['restocked_units'] as num?)?.toInt() ?? 0,
  soldUnits: (json['sold_units'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StockAnalyticsDataPointToJson(
  _StockAnalyticsDataPoint instance,
) => <String, dynamic>{
  'date': instance.date,
  'restocked_units': instance.restockedUnits,
  'sold_units': instance.soldUnits,
};

_TopStockItem _$TopStockItemFromJson(Map<String, dynamic> json) =>
    _TopStockItem(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TopStockItemToJson(_TopStockItem instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'quantity': instance.quantity,
    };

_StockAnalytics _$StockAnalyticsFromJson(Map<String, dynamic> json) =>
    _StockAnalytics(
      period: json['period'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      restockedUnits: (json['restocked_units'] as num?)?.toInt() ?? 0,
      soldUnits: (json['sold_units'] as num?)?.toInt() ?? 0,
      currentStock: (json['current_stock'] as num?)?.toInt() ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => StockAnalyticsDataPoint.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      topRestocked:
          (json['top_restocked'] as List<dynamic>?)
              ?.map((e) => TopStockItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topSold:
          (json['top_sold'] as List<dynamic>?)
              ?.map((e) => TopStockItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$StockAnalyticsToJson(_StockAnalytics instance) =>
    <String, dynamic>{
      'period': instance.period,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'restocked_units': instance.restockedUnits,
      'sold_units': instance.soldUnits,
      'current_stock': instance.currentStock,
      'data': instance.data,
      'top_restocked': instance.topRestocked,
      'top_sold': instance.topSold,
    };

_ProductStockAnalytics _$ProductStockAnalyticsFromJson(
  Map<String, dynamic> json,
) => _ProductStockAnalytics(
  productId: json['product_id'] as String,
  productName: json['product_name'] as String,
  period: json['period'] as String,
  startDate: json['start_date'] as String,
  endDate: json['end_date'] as String,
  currentStock: (json['current_stock'] as num?)?.toInt() ?? 0,
  restockedUnits: (json['restocked_units'] as num?)?.toInt() ?? 0,
  soldUnits: (json['sold_units'] as num?)?.toInt() ?? 0,
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) => StockAnalyticsDataPoint.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProductStockAnalyticsToJson(
  _ProductStockAnalytics instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'product_name': instance.productName,
  'period': instance.period,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'current_stock': instance.currentStock,
  'restocked_units': instance.restockedUnits,
  'sold_units': instance.soldUnits,
  'data': instance.data,
};
