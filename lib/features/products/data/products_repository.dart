import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../domain/product_model.dart';

part 'products_repository.g.dart';

@riverpod
ProductsRepository productsRepository(Ref ref) =>
    ProductsRepository(dio: ref.watch(dioProvider));

class ProductsRepository {
  final Dio _dio;
  ProductsRepository({required Dio dio}) : _dio = dio;

  Future<List<ProductModel>> listProducts(String shopId, {int page = 1}) async {
    try {
      final res = await _dio.get(
        ApiConstants.products(shopId),
        queryParameters: {'page': page, 'page_size': 50},
      );
      final items = res.data['items'] as List;
      return items.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<List<ProductModel>> searchProducts(String shopId, String q) async {
    try {
      final res = await _dio.get(
        ApiConstants.productSearch(shopId),
        queryParameters: {'q': q},
      );
      final data = res.data as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<List<ProductModel>> getLowStock(String shopId) async {
    try {
      final res = await _dio.get(ApiConstants.lowStock(shopId));
      final data = res.data as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<ProductModel> getProduct(String shopId, String productId) async {
    try {
      final res = await _dio.get(ApiConstants.product(shopId, productId));
      return ProductModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<ProductModel> createProduct({
    required String shopId,
    required String name,
    required double sellingPrice,
    int initialStock = 0,
    int lowStockThreshold = 5,
    String? category,
    String? photoUrl,
  }) async {
    try {
      final res = await _dio.post(ApiConstants.products(shopId), data: {
        'name': name,
        'selling_price': sellingPrice,
        'initial_stock': initialStock,
        'low_stock_threshold': lowStockThreshold,
        if (category != null) 'category': category,
        if (photoUrl != null) 'photo_url': photoUrl,
      });
      return ProductModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<ProductModel> updateProduct({
    required String shopId,
    required String productId,
    String? name,
    double? sellingPrice,
    int? lowStockThreshold,
    String? category,
    String? photoUrl,
    bool? isActive,
  }) async {
    try {
      final res = await _dio.patch(
        ApiConstants.product(shopId, productId),
        data: {
          if (name != null) 'name': name,
          if (sellingPrice != null) 'selling_price': sellingPrice,
          if (lowStockThreshold != null)
            'low_stock_threshold': lowStockThreshold,
          if (category != null) 'category': category,
          if (photoUrl != null) 'photo_url': photoUrl,
          if (isActive != null) 'is_active': isActive,
        },
      );
      return ProductModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<ProductModel> deactivateProduct(
      String shopId, String productId) async {
    try {
      final res = await _dio.delete(ApiConstants.product(shopId, productId));
      return ProductModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<ProductModel> restock({
    required String shopId,
    required String productId,
    required int quantity,
  }) async {
    try {
      final res = await _dio.post(
        ApiConstants.restock(shopId, productId),
        data: {'quantity': quantity},
      );
      return ProductModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}
