// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_model.freezed.dart';
part 'analytics_model.g.dart';

// ─── Period enum ──────────────────────────────────────────────────────────────

enum AnalyticsPeriod {
  daily,
  weekly,
  monthly,
  yearly;

  String get apiValue => name; // 'daily', 'weekly', etc.
}

// ─── A single time-bucketed data point ────────────────────────────────────────

@freezed
abstract class AnalyticsDataPoint with _$AnalyticsDataPoint {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AnalyticsDataPoint({
    required String period,
    @Default(0.0) double totalAmount,
    @Default(0) int salesCount,
    @Default(0) int itemsSold,
  }) = _AnalyticsDataPoint;

  factory AnalyticsDataPoint.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataPointFromJson(json);
}

// ─── Full analytics summary ───────────────────────────────────────────────────

@freezed
abstract class SalesAnalytics with _$SalesAnalytics {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SalesAnalytics({
    required String period,
    required String startDate,
    required String endDate,
    @Default(0.0) double totalAmount,
    @Default(0) int salesCount,
    @Default(0) int itemsSold,
    @Default([]) List<AnalyticsDataPoint> data,
  }) = _SalesAnalytics;

  factory SalesAnalytics.fromJson(Map<String, dynamic> json) =>
      _$SalesAnalyticsFromJson(json);
}

/// Empty/zero analytics for a given period — used as fallback.
SalesAnalytics emptyAnalytics(AnalyticsPeriod period) => SalesAnalytics(
      period: period.apiValue,
      startDate: '',
      endDate: '',
    );

// ─── Per-worker analytics entry ───────────────────────────────────────────────

@freezed
abstract class WorkerAnalyticsItem with _$WorkerAnalyticsItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WorkerAnalyticsItem({
    required String workerId,
    required String workerName,
    required String soldByType,
    @Default(0) int salesCount,
    @Default(0.0) double totalAmount,
    @Default(0) int itemsSold,
  }) = _WorkerAnalyticsItem;

  factory WorkerAnalyticsItem.fromJson(Map<String, dynamic> json) =>
      _$WorkerAnalyticsItemFromJson(json);
}

// ─── Worker analytics response ────────────────────────────────────────────────

@freezed
abstract class WorkerAnalytics with _$WorkerAnalytics {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WorkerAnalytics({
    required String startDate,
    required String endDate,
    @Default([]) List<WorkerAnalyticsItem> workers,
  }) = _WorkerAnalytics;

  factory WorkerAnalytics.fromJson(Map<String, dynamic> json) =>
      _$WorkerAnalyticsFromJson(json);
}
