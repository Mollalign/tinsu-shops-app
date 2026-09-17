// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_analytics_model.freezed.dart';
part 'stock_analytics_model.g.dart';

// ─── A single time-bucketed data point ────────────────────────────────────────

@freezed
abstract class StockAnalyticsDataPoint with _$StockAnalyticsDataPoint {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StockAnalyticsDataPoint({
    required String date,
    @Default(0) int restockedUnits,
    @Default(0) int soldUnits,
  }) = _StockAnalyticsDataPoint;

  factory StockAnalyticsDataPoint.fromJson(Map<String, dynamic> json) =>
      _$StockAnalyticsDataPointFromJson(json);
}

// ─── Top product entry ────────────────────────────────────────────────────────

@freezed
abstract class TopStockItem with _$TopStockItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TopStockItem({
    required String productId,
    required String productName,
    @Default(0) int quantity,
  }) = _TopStockItem;

  factory TopStockItem.fromJson(Map<String, dynamic> json) =>
      _$TopStockItemFromJson(json);
}

// ─── Shop-level stock analytics response ─────────────────────────────────────

@freezed
abstract class StockAnalytics with _$StockAnalytics {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StockAnalytics({
    required String period,
    required String startDate,
    required String endDate,
    @Default(0) int restockedUnits,
    @Default(0) int soldUnits,
    @Default(0) int currentStock,
    @Default([]) List<StockAnalyticsDataPoint> data,
    @Default([]) List<TopStockItem> topRestocked,
    @Default([]) List<TopStockItem> topSold,
  }) = _StockAnalytics;

  factory StockAnalytics.fromJson(Map<String, dynamic> json) =>
      _$StockAnalyticsFromJson(json);
}

// ─── Product-level stock analytics response ───────────────────────────────────

@freezed
abstract class ProductStockAnalytics with _$ProductStockAnalytics {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProductStockAnalytics({
    required String productId,
    required String productName,
    required String period,
    required String startDate,
    required String endDate,
    @Default(0) int currentStock,
    @Default(0) int restockedUnits,
    @Default(0) int soldUnits,
    @Default([]) List<StockAnalyticsDataPoint> data,
  }) = _ProductStockAnalytics;

  factory ProductStockAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ProductStockAnalyticsFromJson(json);
}
