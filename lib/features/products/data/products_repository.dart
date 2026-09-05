import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../domain/product_model.dart';
import '../domain/product_search_result.dart';

part 'products_repository.g.dart';

@riverpod
ProductsRepository productsRepository(Ref ref) =>
    ProductsRepository(dio: ref.watch(dioProvider));

class ProductsRepository {
  final Dio _dio;
  ProductsRepository({required Dio dio}) : _dio = dio;

  Future<List<ProductModel>> listProducts(
    String shopId, {
    int page = 1,
    String? categoryId,
  }) async {
    try {
      final res = await _dio.get(
        ApiConstants.products(shopId),
        queryParameters: {
          'page': page,
          'page_size': 50,
          if (categoryId != null) 'category_id': categoryId,
        },
      );
      final items = res.data['items'] as List;
      return items.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<ProductSearchResult> searchProducts(
    String shopId,
    String q, {
    String? categoryId,
  }) async {
    try {
      final res = await _dio.get(
        ApiConstants.productSearch(shopId),
        queryParameters: {
          'q': q,
          if (categoryId != null) 'category_id': categoryId,
        },
      );
      return ProductSearchResult.fromJson(res.data as Map<String, dynamic>);
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
    String? categoryId,
    String? photoUrl,
  }) async {
    try {
      final res = await _dio.post(ApiConstants.products(shopId), data: {
        'name': name,
        'selling_price': sellingPrice,
        'initial_stock': initialStock,
        'low_stock_threshold': lowStockThreshold,
        if (categoryId != null) 'category_id': categoryId,
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
    // Pass null explicitly to clear; don't include key to leave unchanged
    Object? categoryId = _absent,
    String? photoUrl,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{
        if (name != null) 'name': name,
        if (sellingPrice != null) 'selling_price': sellingPrice,
        if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
        if (photoUrl != null) 'photo_url': photoUrl,
        if (isActive != null) 'is_active': isActive,
      };
      // Only include category_id in the payload when the caller explicitly passed it
      if (!identical(categoryId, _absent)) {
        data['category_id'] = categoryId; // may be null (to clear)
      }
      final res = await _dio.patch(
        ApiConstants.product(shopId, productId),
        data: data,
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

  Future<void> restock({
    required String shopId,
    required String productId,
    required int quantity,
  }) async {
    try {
      await _dio.post(
        ApiConstants.restock(shopId, productId),
        data: {'quantity': quantity},
      );
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}

/// Sentinel object to distinguish "not provided" from explicit null for categoryId.
const Object _absent = Object();
