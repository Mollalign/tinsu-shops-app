// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerModel {

 String get id; String get shopId; String get name; bool get isActive;
/// Create a copy of WorkerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerModelCopyWith<WorkerModel> get copyWith => _$WorkerModelCopyWithImpl<WorkerModel>(this as WorkerModel, _$identity);

  /// Serializes this WorkerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shopId,name,isActive);

@override
String toString() {
  return 'WorkerModel(id: $id, shopId: $shopId, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $WorkerModelCopyWith<$Res>  {
  factory $WorkerModelCopyWith(WorkerModel value, $Res Function(WorkerModel) _then) = _$WorkerModelCopyWithImpl;
@useResult
$Res call({
 String id, String shopId, String name, bool isActive
});




}
/// @nodoc
class _$WorkerModelCopyWithImpl<$Res>
    implements $WorkerModelCopyWith<$Res> {
  _$WorkerModelCopyWithImpl(this._self, this._then);

  final WorkerModel _self;
  final $Res Function(WorkerModel) _then;

/// Create a copy of WorkerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shopId = null,Object? name = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerModel].
extension WorkerModelPatterns on WorkerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String shopId,  String name,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerModel() when $default != null:
return $default(_that.id,_that.shopId,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String shopId,  String name,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _WorkerModel():
return $default(_that.id,_that.shopId,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String shopId,  String name,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _WorkerModel() when $default != null:
return $default(_that.id,_that.shopId,_that.name,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _WorkerModel implements WorkerModel {
  const _WorkerModel({required this.id, required this.shopId, required this.name, this.isActive = true});
  factory _WorkerModel.fromJson(Map<String, dynamic> json) => _$WorkerModelFromJson(json);

@override final  String id;
@override final  String shopId;
@override final  String name;
@override@JsonKey() final  bool isActive;

/// Create a copy of WorkerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerModelCopyWith<_WorkerModel> get copyWith => __$WorkerModelCopyWithImpl<_WorkerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shopId,name,isActive);

@override
String toString() {
  return 'WorkerModel(id: $id, shopId: $shopId, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$WorkerModelCopyWith<$Res> implements $WorkerModelCopyWith<$Res> {
  factory _$WorkerModelCopyWith(_WorkerModel value, $Res Function(_WorkerModel) _then) = __$WorkerModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String shopId, String name, bool isActive
});




}
/// @nodoc
class __$WorkerModelCopyWithImpl<$Res>
    implements _$WorkerModelCopyWith<$Res> {
  __$WorkerModelCopyWithImpl(this._self, this._then);

  final _WorkerModel _self;
  final $Res Function(_WorkerModel) _then;

/// Create a copy of WorkerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shopId = null,Object? name = null,Object? isActive = null,}) {
  return _then(_WorkerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$WorkerCreatedModel {

 WorkerModel get worker; String get pin;
/// Create a copy of WorkerCreatedModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerCreatedModelCopyWith<WorkerCreatedModel> get copyWith => _$WorkerCreatedModelCopyWithImpl<WorkerCreatedModel>(this as WorkerCreatedModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerCreatedModel&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.pin, pin) || other.pin == pin));
}


@override
int get hashCode => Object.hash(runtimeType,worker,pin);

@override
String toString() {
  return 'WorkerCreatedModel(worker: $worker, pin: $pin)';
}


}

/// @nodoc
abstract mixin class $WorkerCreatedModelCopyWith<$Res>  {
  factory $WorkerCreatedModelCopyWith(WorkerCreatedModel value, $Res Function(WorkerCreatedModel) _then) = _$WorkerCreatedModelCopyWithImpl;
@useResult
$Res call({
 WorkerModel worker, String pin
});


$WorkerModelCopyWith<$Res> get worker;

}
/// @nodoc
class _$WorkerCreatedModelCopyWithImpl<$Res>
    implements $WorkerCreatedModelCopyWith<$Res> {
  _$WorkerCreatedModelCopyWithImpl(this._self, this._then);

  final WorkerCreatedModel _self;
  final $Res Function(WorkerCreatedModel) _then;

/// Create a copy of WorkerCreatedModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? worker = null,Object? pin = null,}) {
  return _then(_self.copyWith(
worker: null == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as WorkerModel,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of WorkerCreatedModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkerModelCopyWith<$Res> get worker {
  
  return $WorkerModelCopyWith<$Res>(_self.worker, (value) {
    return _then(_self.copyWith(worker: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkerCreatedModel].
extension WorkerCreatedModelPatterns on WorkerCreatedModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerCreatedModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerCreatedModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerCreatedModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerCreatedModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerCreatedModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerCreatedModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WorkerModel worker,  String pin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerCreatedModel() when $default != null:
return $default(_that.worker,_that.pin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WorkerModel worker,  String pin)  $default,) {final _that = this;
switch (_that) {
case _WorkerCreatedModel():
return $default(_that.worker,_that.pin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WorkerModel worker,  String pin)?  $default,) {final _that = this;
switch (_that) {
case _WorkerCreatedModel() when $default != null:
return $default(_that.worker,_that.pin);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _WorkerCreatedModel implements WorkerCreatedModel {
  const _WorkerCreatedModel({required this.worker, required this.pin});
  

@override final  WorkerModel worker;
@override final  String pin;

/// Create a copy of WorkerCreatedModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerCreatedModelCopyWith<_WorkerCreatedModel> get copyWith => __$WorkerCreatedModelCopyWithImpl<_WorkerCreatedModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerCreatedModel&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.pin, pin) || other.pin == pin));
}


@override
int get hashCode => Object.hash(runtimeType,worker,pin);

@override
String toString() {
  return 'WorkerCreatedModel(worker: $worker, pin: $pin)';
}


}

/// @nodoc
abstract mixin class _$WorkerCreatedModelCopyWith<$Res> implements $WorkerCreatedModelCopyWith<$Res> {
  factory _$WorkerCreatedModelCopyWith(_WorkerCreatedModel value, $Res Function(_WorkerCreatedModel) _then) = __$WorkerCreatedModelCopyWithImpl;
@override @useResult
$Res call({
 WorkerModel worker, String pin
});


@override $WorkerModelCopyWith<$Res> get worker;

}
/// @nodoc
class __$WorkerCreatedModelCopyWithImpl<$Res>
    implements _$WorkerCreatedModelCopyWith<$Res> {
  __$WorkerCreatedModelCopyWithImpl(this._self, this._then);

  final _WorkerCreatedModel _self;
  final $Res Function(_WorkerCreatedModel) _then;

/// Create a copy of WorkerCreatedModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? worker = null,Object? pin = null,}) {
  return _then(_WorkerCreatedModel(
worker: null == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as WorkerModel,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of WorkerCreatedModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkerModelCopyWith<$Res> get worker {
  
  return $WorkerModelCopyWith<$Res>(_self.worker, (value) {
    return _then(_self.copyWith(worker: value));
  });
}
}

// dart format on
