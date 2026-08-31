import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../domain/worker_model.dart';

part 'workers_repository.g.dart';

@riverpod
WorkersRepository workersRepository(Ref ref) =>
    WorkersRepository(dio: ref.watch(dioProvider));

class WorkersRepository {
  final Dio _dio;
  WorkersRepository({required Dio dio}) : _dio = dio;

  Future<List<WorkerModel>> listWorkers(String shopId) async {
    try {
      final res = await _dio.get(ApiConstants.workers(shopId));
      // Backend returns Page[WorkerResponse]: {items: [...], page, total, ...}
      final items = (res.data['items'] as List);
      return items.map((e) => WorkerModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<WorkerCreatedModel> createWorker({
    required String shopId,
    required String name,
  }) async {
    try {
      final res = await _dio.post(ApiConstants.workers(shopId), data: {
        'name': name,
      });
      return WorkerCreatedModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<WorkerModel> getWorker(String shopId, String workerId) async {
    try {
      final res = await _dio.get(ApiConstants.worker(shopId, workerId));
      return WorkerModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<String> resetPin(String shopId, String workerId) async {
    try {
      // Backend requires a WorkerResetPin body; send null to auto-generate.
      final res = await _dio.post(
        ApiConstants.workerResetPin(shopId, workerId),
        data: {'new_pin': null},
      );
      return res.data['pin'] as String;
    } on DioException catch (e) {
      throw extractError(e);
    }
  }

  Future<WorkerModel> toggleWorker(
      String shopId, String workerId, bool enable) async {
    try {
      final res = await _dio.patch(
        ApiConstants.worker(shopId, workerId),
        data: {'is_active': enable},
      );
      return WorkerModel.fromJson(res.data);
    } on DioException catch (e) {
      throw extractError(e);
    }
  }
}
