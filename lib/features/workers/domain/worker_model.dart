import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_model.freezed.dart';
part 'worker_model.g.dart';

@freezed
abstract class WorkerModel with _$WorkerModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
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
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WorkerCreatedModel({
    required WorkerModel worker,
    required String pin,
  }) = _WorkerCreatedModel;

  /// The backend returns a flat object (id, name, shop_id, pin, …) rather than
  /// a nested {worker: {…}, pin: "…"} wrapper. This factory handles both.
  factory WorkerCreatedModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('worker')) {
      return _$WorkerCreatedModelFromJson(json);
    }
    return WorkerCreatedModel(
      worker: WorkerModel.fromJson(json),
      pin: json['pin'] as String? ?? '',
    );
  }
}
