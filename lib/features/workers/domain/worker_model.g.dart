// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerModel _$WorkerModelFromJson(Map<String, dynamic> json) => _WorkerModel(
  id: json['id'] as String,
  shopId: json['shopId'] as String,
  name: json['name'] as String,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$WorkerModelToJson(_WorkerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopId': instance.shopId,
      'name': instance.name,
      'isActive': instance.isActive,
    };

_WorkerCreatedModel _$WorkerCreatedModelFromJson(Map<String, dynamic> json) =>
    _WorkerCreatedModel(
      worker: WorkerModel.fromJson(json['worker'] as Map<String, dynamic>),
      pin: json['pin'] as String,
    );

Map<String, dynamic> _$WorkerCreatedModelToJson(_WorkerCreatedModel instance) =>
    <String, dynamic>{'worker': instance.worker, 'pin': instance.pin};
