// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_movement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryMovementModel {

 String get id; String get shopId; String get productId; String get type; int get quantity; String? get reason; String get createdByType; String? get createdById; DateTime get createdAt;
/// Create a copy of InventoryMovementModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryMovementModelCopyWith<InventoryMovementModel> get copyWith => _$InventoryMovementModelCopyWithImpl<InventoryMovementModel>(this as InventoryMovementModel, _$identity);

  /// Serializes this InventoryMovementModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryMovementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdByType, createdByType) || other.createdByType == createdByType)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shopId,productId,type,quantity,reason,createdByType,createdById,createdAt);

@override
String toString() {
  return 'InventoryMovementModel(id: $id, shopId: $shopId, productId: $productId, type: $type, quantity: $quantity, reason: $reason, createdByType: $createdByType, createdById: $createdById, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $InventoryMovementModelCopyWith<$Res>  {
  factory $InventoryMovementModelCopyWith(InventoryMovementModel value, $Res Function(InventoryMovementModel) _then) = _$InventoryMovementModelCopyWithImpl;
@useResult
$Res call({
 String id, String shopId, String productId, String type, int quantity, String? reason, String createdByType, String? createdById, DateTime createdAt
});




}
/// @nodoc
class _$InventoryMovementModelCopyWithImpl<$Res>
    implements $InventoryMovementModelCopyWith<$Res> {
  _$InventoryMovementModelCopyWithImpl(this._self, this._then);

  final InventoryMovementModel _self;
  final $Res Function(InventoryMovementModel) _then;

/// Create a copy of InventoryMovementModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shopId = null,Object? productId = null,Object? type = null,Object? quantity = null,Object? reason = freezed,Object? createdByType = null,Object? createdById = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,createdByType: null == createdByType ? _self.createdByType : createdByType // ignore: cast_nullable_to_non_nullable
as String,createdById: freezed == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryMovementModel].
extension InventoryMovementModelPatterns on InventoryMovementModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryMovementModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryMovementModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryMovementModel value)  $default,){
final _that = this;
switch (_that) {
case _InventoryMovementModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryMovementModel value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryMovementModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String shopId,  String productId,  String type,  int quantity,  String? reason,  String createdByType,  String? createdById,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryMovementModel() when $default != null:
return $default(_that.id,_that.shopId,_that.productId,_that.type,_that.quantity,_that.reason,_that.createdByType,_that.createdById,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String shopId,  String productId,  String type,  int quantity,  String? reason,  String createdByType,  String? createdById,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _InventoryMovementModel():
return $default(_that.id,_that.shopId,_that.productId,_that.type,_that.quantity,_that.reason,_that.createdByType,_that.createdById,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String shopId,  String productId,  String type,  int quantity,  String? reason,  String createdByType,  String? createdById,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _InventoryMovementModel() when $default != null:
return $default(_that.id,_that.shopId,_that.productId,_that.type,_that.quantity,_that.reason,_that.createdByType,_that.createdById,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _InventoryMovementModel implements InventoryMovementModel {
  const _InventoryMovementModel({required this.id, required this.shopId, required this.productId, required this.type, required this.quantity, this.reason, required this.createdByType, this.createdById, required this.createdAt});
  factory _InventoryMovementModel.fromJson(Map<String, dynamic> json) => _$InventoryMovementModelFromJson(json);

@override final  String id;
@override final  String shopId;
@override final  String productId;
@override final  String type;
@override final  int quantity;
@override final  String? reason;
@override final  String createdByType;
@override final  String? createdById;
@override final  DateTime createdAt;

/// Create a copy of InventoryMovementModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryMovementModelCopyWith<_InventoryMovementModel> get copyWith => __$InventoryMovementModelCopyWithImpl<_InventoryMovementModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryMovementModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryMovementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdByType, createdByType) || other.createdByType == createdByType)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shopId,productId,type,quantity,reason,createdByType,createdById,createdAt);

@override
String toString() {
  return 'InventoryMovementModel(id: $id, shopId: $shopId, productId: $productId, type: $type, quantity: $quantity, reason: $reason, createdByType: $createdByType, createdById: $createdById, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InventoryMovementModelCopyWith<$Res> implements $InventoryMovementModelCopyWith<$Res> {
  factory _$InventoryMovementModelCopyWith(_InventoryMovementModel value, $Res Function(_InventoryMovementModel) _then) = __$InventoryMovementModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String shopId, String productId, String type, int quantity, String? reason, String createdByType, String? createdById, DateTime createdAt
});




}
/// @nodoc
class __$InventoryMovementModelCopyWithImpl<$Res>
    implements _$InventoryMovementModelCopyWith<$Res> {
  __$InventoryMovementModelCopyWithImpl(this._self, this._then);

  final _InventoryMovementModel _self;
  final $Res Function(_InventoryMovementModel) _then;

/// Create a copy of InventoryMovementModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shopId = null,Object? productId = null,Object? type = null,Object? quantity = null,Object? reason = freezed,Object? createdByType = null,Object? createdById = freezed,Object? createdAt = null,}) {
  return _then(_InventoryMovementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,createdByType: null == createdByType ? _self.createdByType : createdByType // ignore: cast_nullable_to_non_nullable
as String,createdById: freezed == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
