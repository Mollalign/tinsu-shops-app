import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../sales/domain/analytics_model.dart';
import '../domain/stock_analytics_model.dart';

part 'stock_analytics_repository.g.dart';

@riverpod
StockAnalyticsRepository stockAnalyticsRepository(Ref ref) =>
    StockAnalyticsRepository(dio: ref.watch(dioProvider));

class StockAnalyticsRepository {
  final Dio _dio;
  StockAnalyticsRepository({required Dio dio}) : _dio = dio;

  /// Fetch aggregated stock movement analytics for [shopId].
  /// [period] is one of daily/weekly/monthly/yearly.
  /// [date] is an optional YYYY-MM-DD reference date.
  Future<StockAnalytics> getStockAnalytics(
    String shopId,
    AnalyticsPeriod period, {
    String? date,
  }) async {
    try {
      final params = <String, dynamic>{'period': period.apiValue};
      if (date != null && date.isNotEmpty) params['date'] = date;

      final res = await _dio.get(
        ApiConstants.analyticsShopStock(shopId),
        queryParameters: params,
      );
      return StockAnalytics.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  /// Fetch product-level stock analytics for [productId] in [shopId].
  Future<ProductStockAnalytics> getProductStockAnalytics(
    String shopId,
    String productId,
    AnalyticsPeriod period, {
    String? date,
  }) async {
    try {
      final params = <String, dynamic>{'period': period.apiValue};
      if (date != null && date.isNotEmpty) params['date'] = date;

      final res = await _dio.get(
        ApiConstants.productAnalyticsStock(shopId, productId),
        queryParameters: params,
      );
      return ProductStockAnalytics.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}
