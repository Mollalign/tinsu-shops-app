import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../domain/shop_model.dart';

part 'shops_repository.g.dart';

@riverpod
ShopsRepository shopsRepository(Ref ref) =>
    ShopsRepository(dio: ref.watch(dioProvider));

class ShopsRepository {
  final Dio _dio;
  ShopsRepository({required Dio dio}) : _dio = dio;

  Future<List<ShopModel>> listShops() async {
    try {
      final res = await _dio.get(ApiConstants.shops);
      final data = res.data as List;
      return data.map((e) => ShopModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<ShopModel> createShop({
    required String name,
    String? location,
    String? phone,
  }) async {
    try {
      final res = await _dio.post(ApiConstants.shops, data: {
        'name': name,
        if (location != null) 'location': location,
        if (phone != null) 'phone': phone,
      });
      return ShopModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}
