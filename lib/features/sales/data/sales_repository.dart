import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../domain/sale_model.dart';

part 'sales_repository.g.dart';

@riverpod
SalesRepository salesRepository(Ref ref) =>
    SalesRepository(dio: ref.watch(dioProvider));

class SalesRepository {
  final Dio _dio;
  SalesRepository({required Dio dio}) : _dio = dio;

  /// Submit a completed sale. Payment method defaults to CASH since the UI
  /// no longer asks workers to select one. The idempotency key prevents
  /// duplicate sales on retries.
  Future<SaleModel> createSale({
    required String shopId,
    required List<Map<String, dynamic>> items,
    required String idempotencyKey,
  }) async {
    try {
      final res = await _dio.post(
        ApiConstants.sales(shopId),
        data: {
          'items': items,
        },
        options: Options(
          headers: {'Idempotency-Key': idempotencyKey},
        ),
      );
      return SaleModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<List<SaleListItem>> listSales(String shopId, {int page = 1}) async {
    try {
      final res = await _dio.get(
        ApiConstants.sales(shopId),
        queryParameters: {'page': page, 'page_size': 30},
      );
      final items = res.data['items'] as List;
      return items.map((e) => SaleListItem.fromJson(e)).toList();
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<SaleModel> getSale(String shopId, String saleId) async {
    try {
      final res = await _dio.get(ApiConstants.sale(shopId, saleId));
      return SaleModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}
