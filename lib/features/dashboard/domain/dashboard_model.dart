// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

/// Converts a backend numeric Decimal to a String for display.
String _numToString(dynamic v) => v?.toString() ?? '0';

@freezed
abstract class PaymentBreakdown with _$PaymentBreakdown {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PaymentBreakdown({
    @Default('0') String cash,
    @Default('0') String telebirr,
    @Default('0') String cbeBirr,
    @Default('0') String other,
  }) = _PaymentBreakdown;

  factory PaymentBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PaymentBreakdownFromJson(json);
}

extension PaymentBreakdownX on PaymentBreakdown {
  double get cashAmt => double.tryParse(cash) ?? 0;
  double get telebirrAmt => double.tryParse(telebirr) ?? 0;
  double get cbeBirrAmt => double.tryParse(cbeBirr) ?? 0;
  double get otherAmt => double.tryParse(other) ?? 0;
}

@freezed
abstract class TodayReport with _$TodayReport {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TodayReport({
    required String date,
    @JsonKey(fromJson: _numToString) required String totalSales,
    required int numberOfSales,
    required int itemsSold,
    // paymentBreakdown is not returned by the backend — kept for UI compat only.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(PaymentBreakdown())
    PaymentBreakdown paymentBreakdown,
    required int lowStockCount,
  }) = _TodayReport;

  factory TodayReport.fromJson(Map<String, dynamic> json) =>
      _$TodayReportFromJson(json);
}

extension TodayReportX on TodayReport {
  double get total => double.tryParse(totalSales) ?? 0;
}

@freezed
abstract class WorkerTodayReport with _$WorkerTodayReport {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WorkerTodayReport({
    @JsonKey(fromJson: _numToString) required String totalSales,
    required int numberOfSales,
    required int itemsSold,
    // paymentBreakdown is not returned by the backend — kept for UI compat only.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(PaymentBreakdown())
    PaymentBreakdown paymentBreakdown,
  }) = _WorkerTodayReport;

  factory WorkerTodayReport.fromJson(Map<String, dynamic> json) =>
      _$WorkerTodayReportFromJson(json);
}

extension WorkerTodayReportX on WorkerTodayReport {
  double get total => double.tryParse(totalSales) ?? 0;
}

@freezed
abstract class ShopDailySummary with _$ShopDailySummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShopDailySummary({
    required String shopId,
    required String shopName,
    @JsonKey(fromJson: _numToString) required String todaySales,
    required int numberOfSales,
  }) = _ShopDailySummary;

  factory ShopDailySummary.fromJson(Map<String, dynamic> json) =>
      _$ShopDailySummaryFromJson(json);
}

extension ShopDailySummaryX on ShopDailySummary {
  double get total => double.tryParse(todaySales) ?? 0;
}

@freezed
abstract class OwnerDashboard with _$OwnerDashboard {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OwnerDashboard({
    required List<ShopDailySummary> shops,
    @JsonKey(fromJson: _numToString) required String totalTodaySales,
  }) = _OwnerDashboard;

  factory OwnerDashboard.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardFromJson(json);
}

extension OwnerDashboardX on OwnerDashboard {
  double get grandTotal => double.tryParse(totalTodaySales) ?? 0;
}

@freezed
abstract class HomeLowStockItem with _$HomeLowStockItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HomeLowStockItem({
    required String id,
    required String name,
    required int stockQuantity,
    required int lowStockThreshold,
    @Default(false) bool isOutOfStock,
  }) = _HomeLowStockItem;

  factory HomeLowStockItem.fromJson(Map<String, dynamic> json) =>
      _$HomeLowStockItemFromJson(json);
}

@freezed
abstract class HomeRecentSaleItem with _$HomeRecentSaleItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HomeRecentSaleItem({
    required String id,
    required DateTime createdAt,
    required String soldByName,
    @JsonKey(fromJson: _numToString) required String totalAmount,
    required int itemsCount,
  }) = _HomeRecentSaleItem;

  factory HomeRecentSaleItem.fromJson(Map<String, dynamic> json) =>
      _$HomeRecentSaleItemFromJson(json);
}

extension HomeRecentSaleItemX on HomeRecentSaleItem {
  double get total => double.tryParse(totalAmount) ?? 0;
}

@freezed
abstract class HomeSummary with _$HomeSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HomeSummary({
    required TodayReport today,
    @Default([]) List<HomeLowStockItem> lowStock,
    @Default([]) List<HomeRecentSaleItem> recentSales,
  }) = _HomeSummary;

  factory HomeSummary.fromJson(Map<String, dynamic> json) =>
      _$HomeSummaryFromJson(json);
}

