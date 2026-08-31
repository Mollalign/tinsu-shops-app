import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../domain/category_model.dart';

part 'categories_repository.g.dart';

@riverpod
CategoriesRepository categoriesRepository(Ref ref) =>
    CategoriesRepository(dio: ref.watch(dioProvider));

class CategoriesRepository {
  final Dio _dio;
  CategoriesRepository({required Dio dio}) : _dio = dio;

  Future<List<CategoryModel>> listCategories(String shopId) async {
    try {
      final res = await _dio.get(ApiConstants.categories(shopId));
      final data = res.data as List;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<CategoryModel> createCategory(String shopId, String name) async {
    try {
      final res = await _dio.post(
        ApiConstants.categories(shopId),
        data: {'name': name},
      );
      return CategoryModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<CategoryModel> updateCategory(
      String shopId, String categoryId, String name) async {
    try {
      final res = await _dio.patch(
        ApiConstants.category(shopId, categoryId),
        data: {'name': name},
      );
      return CategoryModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<void> deleteCategory(String shopId, String categoryId) async {
    try {
      await _dio.delete(ApiConstants.category(shopId, categoryId));
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}
