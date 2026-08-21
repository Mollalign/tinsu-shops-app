import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_model.freezed.dart';
part 'worker_model.g.dart';

@freezed
abstract class WorkerModel with _$WorkerModel {
  const factory WorkerModel({
    required String id,
    required String shopId,
    required String name,
    @Default(true) bool isActive,
  }) = _WorkerModel;

  factory WorkerModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerModelFromJson(json);
}

@freezed
abstract class WorkerCreatedModel with _$WorkerCreatedModel {
  const factory WorkerCreatedModel({
    required WorkerModel worker,
    required String pin,
  }) = _WorkerCreatedModel;

  factory WorkerCreatedModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerCreatedModelFromJson(json);
}
