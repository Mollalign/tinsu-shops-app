import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/paged_result.dart';
import '../domain/inventory_movement_model.dart';

part 'inventory_repository.g.dart';

@riverpod
InventoryRepository inventoryRepository(Ref ref) =>
    InventoryRepository(dio: ref.watch(dioProvider));

class InventoryRepository {
  final Dio _dio;
  InventoryRepository({required Dio dio}) : _dio = dio;

  Future<PagedResult<InventoryMovementModel>> getMovements(
    String shopId,
    String productId, {
    int page = 1,
    int pageSize = 30,
  }) async {
    try {
      final res = await _dio.get(
        ApiConstants.productMovements(shopId, productId),
        queryParameters: {'page': page, 'page_size': pageSize},
      );
      return PagedResult.fromJson(
        res.data as Map<String, dynamic>,
        InventoryMovementModel.fromJson,
      );
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}
