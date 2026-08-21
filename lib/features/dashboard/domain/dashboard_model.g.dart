// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentBreakdown _$PaymentBreakdownFromJson(Map<String, dynamic> json) =>
    _PaymentBreakdown(
      cash: json['cash'] as String? ?? '0',
      telebirr: json['telebirr'] as String? ?? '0',
      cbeBirr: json['cbeBirr'] as String? ?? '0',
      other: json['other'] as String? ?? '0',
    );

Map<String, dynamic> _$PaymentBreakdownToJson(_PaymentBreakdown instance) =>
    <String, dynamic>{
      'cash': instance.cash,
      'telebirr': instance.telebirr,
      'cbeBirr': instance.cbeBirr,
      'other': instance.other,
    };

_TodayReport _$TodayReportFromJson(Map<String, dynamic> json) => _TodayReport(
  date: json['date'] as String,
  totalSales: json['totalSales'] as String,
  numberOfSales: (json['numberOfSales'] as num).toInt(),
  itemsSold: (json['itemsSold'] as num).toInt(),
  paymentBreakdown: PaymentBreakdown.fromJson(
    json['paymentBreakdown'] as Map<String, dynamic>,
  ),
  lowStockCount: (json['lowStockCount'] as num).toInt(),
);

Map<String, dynamic> _$TodayReportToJson(_TodayReport instance) =>
    <String, dynamic>{
      'date': instance.date,
      'totalSales': instance.totalSales,
      'numberOfSales': instance.numberOfSales,
      'itemsSold': instance.itemsSold,
      'paymentBreakdown': instance.paymentBreakdown,
      'lowStockCount': instance.lowStockCount,
    };

_WorkerTodayReport _$WorkerTodayReportFromJson(Map<String, dynamic> json) =>
    _WorkerTodayReport(
      totalSales: json['totalSales'] as String,
      numberOfSales: (json['numberOfSales'] as num).toInt(),
      itemsSold: (json['itemsSold'] as num).toInt(),
      paymentBreakdown: PaymentBreakdown.fromJson(
        json['paymentBreakdown'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$WorkerTodayReportToJson(_WorkerTodayReport instance) =>
    <String, dynamic>{
      'totalSales': instance.totalSales,
      'numberOfSales': instance.numberOfSales,
      'itemsSold': instance.itemsSold,
      'paymentBreakdown': instance.paymentBreakdown,
    };

_ShopDailySummary _$ShopDailySummaryFromJson(Map<String, dynamic> json) =>
    _ShopDailySummary(
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      todaySales: json['todaySales'] as String,
      numberOfSales: (json['numberOfSales'] as num).toInt(),
    );

Map<String, dynamic> _$ShopDailySummaryToJson(_ShopDailySummary instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'todaySales': instance.todaySales,
      'numberOfSales': instance.numberOfSales,
    };

_OwnerDashboard _$OwnerDashboardFromJson(Map<String, dynamic> json) =>
    _OwnerDashboard(
      shops: (json['shops'] as List<dynamic>)
          .map((e) => ShopDailySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalTodaySales: json['totalTodaySales'] as String,
    );

Map<String, dynamic> _$OwnerDashboardToJson(_OwnerDashboard instance) =>
    <String, dynamic>{
      'shops': instance.shops,
      'totalTodaySales': instance.totalTodaySales,
    };
