// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_model.freezed.dart';
part 'shop_model.g.dart';

@freezed
abstract class ShopModel with _$ShopModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShopModel({
    required String id,
    required String name,
    String? location,
    String? phone,
    @Default(true) bool isActive,
  }) = _ShopModel;

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);
}
