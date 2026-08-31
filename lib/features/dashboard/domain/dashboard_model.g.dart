// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentBreakdown _$PaymentBreakdownFromJson(Map<String, dynamic> json) =>
    _PaymentBreakdown(
      cash: json['cash'] as String? ?? '0',
      telebirr: json['telebirr'] as String? ?? '0',
      cbeBirr: json['cbe_birr'] as String? ?? '0',
      other: json['other'] as String? ?? '0',
    );

Map<String, dynamic> _$PaymentBreakdownToJson(_PaymentBreakdown instance) =>
    <String, dynamic>{
      'cash': instance.cash,
      'telebirr': instance.telebirr,
      'cbe_birr': instance.cbeBirr,
      'other': instance.other,
    };

_TodayReport _$TodayReportFromJson(Map<String, dynamic> json) => _TodayReport(
  date: json['date'] as String,
  totalSales: _numToString(json['total_sales']),
  numberOfSales: (json['number_of_sales'] as num).toInt(),
  itemsSold: (json['items_sold'] as num).toInt(),
  lowStockCount: (json['low_stock_count'] as num).toInt(),
);

Map<String, dynamic> _$TodayReportToJson(_TodayReport instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total_sales': instance.totalSales,
      'number_of_sales': instance.numberOfSales,
      'items_sold': instance.itemsSold,
      'low_stock_count': instance.lowStockCount,
    };

_WorkerTodayReport _$WorkerTodayReportFromJson(Map<String, dynamic> json) =>
    _WorkerTodayReport(
      totalSales: _numToString(json['total_sales']),
      numberOfSales: (json['number_of_sales'] as num).toInt(),
      itemsSold: (json['items_sold'] as num).toInt(),
    );

Map<String, dynamic> _$WorkerTodayReportToJson(_WorkerTodayReport instance) =>
    <String, dynamic>{
      'total_sales': instance.totalSales,
      'number_of_sales': instance.numberOfSales,
      'items_sold': instance.itemsSold,
    };

_ShopDailySummary _$ShopDailySummaryFromJson(Map<String, dynamic> json) =>
    _ShopDailySummary(
      shopId: json['shop_id'] as String,
      shopName: json['shop_name'] as String,
      todaySales: _numToString(json['today_sales']),
      numberOfSales: (json['number_of_sales'] as num).toInt(),
    );

Map<String, dynamic> _$ShopDailySummaryToJson(_ShopDailySummary instance) =>
    <String, dynamic>{
      'shop_id': instance.shopId,
      'shop_name': instance.shopName,
      'today_sales': instance.todaySales,
      'number_of_sales': instance.numberOfSales,
    };

_OwnerDashboard _$OwnerDashboardFromJson(Map<String, dynamic> json) =>
    _OwnerDashboard(
      shops: (json['shops'] as List<dynamic>)
          .map((e) => ShopDailySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalTodaySales: _numToString(json['total_today_sales']),
    );

Map<String, dynamic> _$OwnerDashboardToJson(_OwnerDashboard instance) =>
    <String, dynamic>{
      'shops': instance.shops,
      'total_today_sales': instance.totalTodaySales,
    };
