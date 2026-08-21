import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../domain/dashboard_model.dart';

part 'dashboard_repository.g.dart';

@riverpod
DashboardRepository dashboardRepository(Ref ref) =>
    DashboardRepository(dio: ref.watch(dioProvider));

class DashboardRepository {
  final Dio _dio;
  DashboardRepository({required Dio dio}) : _dio = dio;

  Future<OwnerDashboard> getOwnerDashboard() async {
    try {
      final res = await _dio.get(ApiConstants.ownerDashboard);
      return OwnerDashboard.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<TodayReport> getShopToday(String shopId) async {
    try {
      final res = await _dio.get(ApiConstants.shopToday(shopId));
      return TodayReport.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<WorkerTodayReport> getWorkerToday(String shopId) async {
    try {
      final res = await _dio.get(ApiConstants.workerToday(shopId));
      return WorkerTodayReport.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}
