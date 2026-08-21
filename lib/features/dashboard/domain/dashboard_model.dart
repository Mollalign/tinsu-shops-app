import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
abstract class PaymentBreakdown with _$PaymentBreakdown {
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
  const factory TodayReport({
    required String date,
    required String totalSales,
    required int numberOfSales,
    required int itemsSold,
    required PaymentBreakdown paymentBreakdown,
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
  const factory WorkerTodayReport({
    required String totalSales,
    required int numberOfSales,
    required int itemsSold,
    required PaymentBreakdown paymentBreakdown,
  }) = _WorkerTodayReport;

  factory WorkerTodayReport.fromJson(Map<String, dynamic> json) =>
      _$WorkerTodayReportFromJson(json);
}

extension WorkerTodayReportX on WorkerTodayReport {
  double get total => double.tryParse(totalSales) ?? 0;
}

@freezed
abstract class ShopDailySummary with _$ShopDailySummary {
  const factory ShopDailySummary({
    required String shopId,
    required String shopName,
    required String todaySales,
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
  const factory OwnerDashboard({
    required List<ShopDailySummary> shops,
    required String totalTodaySales,
  }) = _OwnerDashboard;

  factory OwnerDashboard.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardFromJson(json);
}

extension OwnerDashboardX on OwnerDashboard {
  double get grandTotal => double.tryParse(totalTodaySales) ?? 0;
}
