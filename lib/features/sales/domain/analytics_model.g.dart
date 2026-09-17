// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsDataPoint _$AnalyticsDataPointFromJson(Map<String, dynamic> json) =>
    _AnalyticsDataPoint(
      period: json['period'] as String,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      salesCount: (json['sales_count'] as num?)?.toInt() ?? 0,
      itemsSold: (json['items_sold'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AnalyticsDataPointToJson(_AnalyticsDataPoint instance) =>
    <String, dynamic>{
      'period': instance.period,
      'total_amount': instance.totalAmount,
      'sales_count': instance.salesCount,
      'items_sold': instance.itemsSold,
    };

_SalesAnalytics _$SalesAnalyticsFromJson(Map<String, dynamic> json) =>
    _SalesAnalytics(
      period: json['period'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      salesCount: (json['sales_count'] as num?)?.toInt() ?? 0,
      itemsSold: (json['items_sold'] as num?)?.toInt() ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => AnalyticsDataPoint.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SalesAnalyticsToJson(_SalesAnalytics instance) =>
    <String, dynamic>{
      'period': instance.period,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'total_amount': instance.totalAmount,
      'sales_count': instance.salesCount,
      'items_sold': instance.itemsSold,
      'data': instance.data,
    };

_WorkerAnalyticsItem _$WorkerAnalyticsItemFromJson(Map<String, dynamic> json) =>
    _WorkerAnalyticsItem(
      workerId: json['worker_id'] as String,
      workerName: json['worker_name'] as String,
      soldByType: json['sold_by_type'] as String,
      salesCount: (json['sales_count'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      itemsSold: (json['items_sold'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$WorkerAnalyticsItemToJson(
  _WorkerAnalyticsItem instance,
) => <String, dynamic>{
  'worker_id': instance.workerId,
  'worker_name': instance.workerName,
  'sold_by_type': instance.soldByType,
  'sales_count': instance.salesCount,
  'total_amount': instance.totalAmount,
  'items_sold': instance.itemsSold,
};

_WorkerAnalytics _$WorkerAnalyticsFromJson(Map<String, dynamic> json) =>
    _WorkerAnalytics(
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      workers:
          (json['workers'] as List<dynamic>?)
              ?.map(
                (e) => WorkerAnalyticsItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WorkerAnalyticsToJson(_WorkerAnalytics instance) =>
    <String, dynamic>{
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'workers': instance.workers,
    };
