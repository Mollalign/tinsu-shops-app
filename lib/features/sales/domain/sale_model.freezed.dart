// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleItemModel {

 String get productId; String get productName; int get quantity;@JsonKey(fromJson: _numToString) String get unitPrice;@JsonKey(fromJson: _numToString) String get subtotal;
/// Create a copy of SaleItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleItemModelCopyWith<SaleItemModel> get copyWith => _$SaleItemModelCopyWithImpl<SaleItemModel>(this as SaleItemModel, _$identity);

  /// Serializes this SaleItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleItemModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity,unitPrice,subtotal);

@override
String toString() {
  return 'SaleItemModel(productId: $productId, productName: $productName, quantity: $quantity, unitPrice: $unitPrice, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $SaleItemModelCopyWith<$Res>  {
  factory $SaleItemModelCopyWith(SaleItemModel value, $Res Function(SaleItemModel) _then) = _$SaleItemModelCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, int quantity,@JsonKey(fromJson: _numToString) String unitPrice,@JsonKey(fromJson: _numToString) String subtotal
});




}
/// @nodoc
class _$SaleItemModelCopyWithImpl<$Res>
    implements $SaleItemModelCopyWith<$Res> {
  _$SaleItemModelCopyWithImpl(this._self, this._then);

  final SaleItemModel _self;
  final $Res Function(SaleItemModel) _then;

/// Create a copy of SaleItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? quantity = null,Object? unitPrice = null,Object? subtotal = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleItemModel].
extension SaleItemModelPatterns on SaleItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleItemModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  int quantity, @JsonKey(fromJson: _numToString)  String unitPrice, @JsonKey(fromJson: _numToString)  String subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleItemModel() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity,_that.unitPrice,_that.subtotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  int quantity, @JsonKey(fromJson: _numToString)  String unitPrice, @JsonKey(fromJson: _numToString)  String subtotal)  $default,) {final _that = this;
switch (_that) {
case _SaleItemModel():
return $default(_that.productId,_that.productName,_that.quantity,_that.unitPrice,_that.subtotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  int quantity, @JsonKey(fromJson: _numToString)  String unitPrice, @JsonKey(fromJson: _numToString)  String subtotal)?  $default,) {final _that = this;
switch (_that) {
case _SaleItemModel() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity,_that.unitPrice,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SaleItemModel implements SaleItemModel {
  const _SaleItemModel({required this.productId, required this.productName, required this.quantity, @JsonKey(fromJson: _numToString) required this.unitPrice, @JsonKey(fromJson: _numToString) required this.subtotal});
  factory _SaleItemModel.fromJson(Map<String, dynamic> json) => _$SaleItemModelFromJson(json);

@override final  String productId;
@override final  String productName;
@override final  int quantity;
@override@JsonKey(fromJson: _numToString) final  String unitPrice;
@override@JsonKey(fromJson: _numToString) final  String subtotal;

/// Create a copy of SaleItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleItemModelCopyWith<_SaleItemModel> get copyWith => __$SaleItemModelCopyWithImpl<_SaleItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleItemModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity,unitPrice,subtotal);

@override
String toString() {
  return 'SaleItemModel(productId: $productId, productName: $productName, quantity: $quantity, unitPrice: $unitPrice, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$SaleItemModelCopyWith<$Res> implements $SaleItemModelCopyWith<$Res> {
  factory _$SaleItemModelCopyWith(_SaleItemModel value, $Res Function(_SaleItemModel) _then) = __$SaleItemModelCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, int quantity,@JsonKey(fromJson: _numToString) String unitPrice,@JsonKey(fromJson: _numToString) String subtotal
});




}
/// @nodoc
class __$SaleItemModelCopyWithImpl<$Res>
    implements _$SaleItemModelCopyWith<$Res> {
  __$SaleItemModelCopyWithImpl(this._self, this._then);

  final _SaleItemModel _self;
  final $Res Function(_SaleItemModel) _then;

/// Create a copy of SaleItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? quantity = null,Object? unitPrice = null,Object? subtotal = null,}) {
  return _then(_SaleItemModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SoldByModel {

 String get type; String get id; String get name;
/// Create a copy of SoldByModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SoldByModelCopyWith<SoldByModel> get copyWith => _$SoldByModelCopyWithImpl<SoldByModel>(this as SoldByModel, _$identity);

  /// Serializes this SoldByModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SoldByModel&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,name);

@override
String toString() {
  return 'SoldByModel(type: $type, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SoldByModelCopyWith<$Res>  {
  factory $SoldByModelCopyWith(SoldByModel value, $Res Function(SoldByModel) _then) = _$SoldByModelCopyWithImpl;
@useResult
$Res call({
 String type, String id, String name
});




}
/// @nodoc
class _$SoldByModelCopyWithImpl<$Res>
    implements $SoldByModelCopyWith<$Res> {
  _$SoldByModelCopyWithImpl(this._self, this._then);

  final SoldByModel _self;
  final $Res Function(SoldByModel) _then;

/// Create a copy of SoldByModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SoldByModel].
extension SoldByModelPatterns on SoldByModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SoldByModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SoldByModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SoldByModel value)  $default,){
final _that = this;
switch (_that) {
case _SoldByModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SoldByModel value)?  $default,){
final _that = this;
switch (_that) {
case _SoldByModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SoldByModel() when $default != null:
return $default(_that.type,_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _SoldByModel():
return $default(_that.type,_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _SoldByModel() when $default != null:
return $default(_that.type,_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SoldByModel implements SoldByModel {
  const _SoldByModel({required this.type, required this.id, required this.name});
  factory _SoldByModel.fromJson(Map<String, dynamic> json) => _$SoldByModelFromJson(json);

@override final  String type;
@override final  String id;
@override final  String name;

/// Create a copy of SoldByModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SoldByModelCopyWith<_SoldByModel> get copyWith => __$SoldByModelCopyWithImpl<_SoldByModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SoldByModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SoldByModel&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,name);

@override
String toString() {
  return 'SoldByModel(type: $type, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SoldByModelCopyWith<$Res> implements $SoldByModelCopyWith<$Res> {
  factory _$SoldByModelCopyWith(_SoldByModel value, $Res Function(_SoldByModel) _then) = __$SoldByModelCopyWithImpl;
@override @useResult
$Res call({
 String type, String id, String name
});




}
/// @nodoc
class __$SoldByModelCopyWithImpl<$Res>
    implements _$SoldByModelCopyWith<$Res> {
  __$SoldByModelCopyWithImpl(this._self, this._then);

  final _SoldByModel _self;
  final $Res Function(_SoldByModel) _then;

/// Create a copy of SoldByModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = null,Object? name = null,}) {
  return _then(_SoldByModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SaleModel {

 String get id; String get shopId;@JsonKey(fromJson: _numToString) String get totalAmount; List<SaleItemModel> get items; SoldByModel get soldBy; DateTime get createdAt;
/// Create a copy of SaleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleModelCopyWith<SaleModel> get copyWith => _$SaleModelCopyWithImpl<SaleModel>(this as SaleModel, _$identity);

  /// Serializes this SaleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.soldBy, soldBy) || other.soldBy == soldBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shopId,totalAmount,const DeepCollectionEquality().hash(items),soldBy,createdAt);

@override
String toString() {
  return 'SaleModel(id: $id, shopId: $shopId, totalAmount: $totalAmount, items: $items, soldBy: $soldBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SaleModelCopyWith<$Res>  {
  factory $SaleModelCopyWith(SaleModel value, $Res Function(SaleModel) _then) = _$SaleModelCopyWithImpl;
@useResult
$Res call({
 String id, String shopId,@JsonKey(fromJson: _numToString) String totalAmount, List<SaleItemModel> items, SoldByModel soldBy, DateTime createdAt
});


$SoldByModelCopyWith<$Res> get soldBy;

}
/// @nodoc
class _$SaleModelCopyWithImpl<$Res>
    implements $SaleModelCopyWith<$Res> {
  _$SaleModelCopyWithImpl(this._self, this._then);

  final SaleModel _self;
  final $Res Function(SaleModel) _then;

/// Create a copy of SaleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shopId = null,Object? totalAmount = null,Object? items = null,Object? soldBy = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItemModel>,soldBy: null == soldBy ? _self.soldBy : soldBy // ignore: cast_nullable_to_non_nullable
as SoldByModel,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SaleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SoldByModelCopyWith<$Res> get soldBy {
  
  return $SoldByModelCopyWith<$Res>(_self.soldBy, (value) {
    return _then(_self.copyWith(soldBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [SaleModel].
extension SaleModelPatterns on SaleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleModel value)  $default,){
final _that = this;
switch (_that) {
case _SaleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleModel value)?  $default,){
final _that = this;
switch (_that) {
case _SaleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String shopId, @JsonKey(fromJson: _numToString)  String totalAmount,  List<SaleItemModel> items,  SoldByModel soldBy,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleModel() when $default != null:
return $default(_that.id,_that.shopId,_that.totalAmount,_that.items,_that.soldBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String shopId, @JsonKey(fromJson: _numToString)  String totalAmount,  List<SaleItemModel> items,  SoldByModel soldBy,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SaleModel():
return $default(_that.id,_that.shopId,_that.totalAmount,_that.items,_that.soldBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String shopId, @JsonKey(fromJson: _numToString)  String totalAmount,  List<SaleItemModel> items,  SoldByModel soldBy,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SaleModel() when $default != null:
return $default(_that.id,_that.shopId,_that.totalAmount,_that.items,_that.soldBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SaleModel implements SaleModel {
  const _SaleModel({required this.id, required this.shopId, @JsonKey(fromJson: _numToString) required this.totalAmount, required final  List<SaleItemModel> items, required this.soldBy, required this.createdAt}): _items = items;
  factory _SaleModel.fromJson(Map<String, dynamic> json) => _$SaleModelFromJson(json);

@override final  String id;
@override final  String shopId;
@override@JsonKey(fromJson: _numToString) final  String totalAmount;
 final  List<SaleItemModel> _items;
@override List<SaleItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  SoldByModel soldBy;
@override final  DateTime createdAt;

/// Create a copy of SaleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleModelCopyWith<_SaleModel> get copyWith => __$SaleModelCopyWithImpl<_SaleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.soldBy, soldBy) || other.soldBy == soldBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shopId,totalAmount,const DeepCollectionEquality().hash(_items),soldBy,createdAt);

@override
String toString() {
  return 'SaleModel(id: $id, shopId: $shopId, totalAmount: $totalAmount, items: $items, soldBy: $soldBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SaleModelCopyWith<$Res> implements $SaleModelCopyWith<$Res> {
  factory _$SaleModelCopyWith(_SaleModel value, $Res Function(_SaleModel) _then) = __$SaleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String shopId,@JsonKey(fromJson: _numToString) String totalAmount, List<SaleItemModel> items, SoldByModel soldBy, DateTime createdAt
});


@override $SoldByModelCopyWith<$Res> get soldBy;

}
/// @nodoc
class __$SaleModelCopyWithImpl<$Res>
    implements _$SaleModelCopyWith<$Res> {
  __$SaleModelCopyWithImpl(this._self, this._then);

  final _SaleModel _self;
  final $Res Function(_SaleModel) _then;

/// Create a copy of SaleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shopId = null,Object? totalAmount = null,Object? items = null,Object? soldBy = null,Object? createdAt = null,}) {
  return _then(_SaleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItemModel>,soldBy: null == soldBy ? _self.soldBy : soldBy // ignore: cast_nullable_to_non_nullable
as SoldByModel,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SaleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SoldByModelCopyWith<$Res> get soldBy {
  
  return $SoldByModelCopyWith<$Res>(_self.soldBy, (value) {
    return _then(_self.copyWith(soldBy: value));
  });
}
}


/// @nodoc
mixin _$SaleListItem {

 String get id; String get shopId;@JsonKey(fromJson: _numToString) String get totalAmount; int get itemsCount; String get soldByName; DateTime get createdAt;
/// Create a copy of SaleListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleListItemCopyWith<SaleListItem> get copyWith => _$SaleListItemCopyWithImpl<SaleListItem>(this as SaleListItem, _$identity);

  /// Serializes this SaleListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount)&&(identical(other.soldByName, soldByName) || other.soldByName == soldByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shopId,totalAmount,itemsCount,soldByName,createdAt);

@override
String toString() {
  return 'SaleListItem(id: $id, shopId: $shopId, totalAmount: $totalAmount, itemsCount: $itemsCount, soldByName: $soldByName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SaleListItemCopyWith<$Res>  {
  factory $SaleListItemCopyWith(SaleListItem value, $Res Function(SaleListItem) _then) = _$SaleListItemCopyWithImpl;
@useResult
$Res call({
 String id, String shopId,@JsonKey(fromJson: _numToString) String totalAmount, int itemsCount, String soldByName, DateTime createdAt
});




}
/// @nodoc
class _$SaleListItemCopyWithImpl<$Res>
    implements $SaleListItemCopyWith<$Res> {
  _$SaleListItemCopyWithImpl(this._self, this._then);

  final SaleListItem _self;
  final $Res Function(SaleListItem) _then;

/// Create a copy of SaleListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shopId = null,Object? totalAmount = null,Object? itemsCount = null,Object? soldByName = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,itemsCount: null == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int,soldByName: null == soldByName ? _self.soldByName : soldByName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleListItem].
extension SaleListItemPatterns on SaleListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleListItem value)  $default,){
final _that = this;
switch (_that) {
case _SaleListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleListItem value)?  $default,){
final _that = this;
switch (_that) {
case _SaleListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String shopId, @JsonKey(fromJson: _numToString)  String totalAmount,  int itemsCount,  String soldByName,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleListItem() when $default != null:
return $default(_that.id,_that.shopId,_that.totalAmount,_that.itemsCount,_that.soldByName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String shopId, @JsonKey(fromJson: _numToString)  String totalAmount,  int itemsCount,  String soldByName,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SaleListItem():
return $default(_that.id,_that.shopId,_that.totalAmount,_that.itemsCount,_that.soldByName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String shopId, @JsonKey(fromJson: _numToString)  String totalAmount,  int itemsCount,  String soldByName,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SaleListItem() when $default != null:
return $default(_that.id,_that.shopId,_that.totalAmount,_that.itemsCount,_that.soldByName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SaleListItem implements SaleListItem {
  const _SaleListItem({required this.id, required this.shopId, @JsonKey(fromJson: _numToString) required this.totalAmount, required this.itemsCount, required this.soldByName, required this.createdAt});
  factory _SaleListItem.fromJson(Map<String, dynamic> json) => _$SaleListItemFromJson(json);

@override final  String id;
@override final  String shopId;
@override@JsonKey(fromJson: _numToString) final  String totalAmount;
@override final  int itemsCount;
@override final  String soldByName;
@override final  DateTime createdAt;

/// Create a copy of SaleListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleListItemCopyWith<_SaleListItem> get copyWith => __$SaleListItemCopyWithImpl<_SaleListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleListItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount)&&(identical(other.soldByName, soldByName) || other.soldByName == soldByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shopId,totalAmount,itemsCount,soldByName,createdAt);

@override
String toString() {
  return 'SaleListItem(id: $id, shopId: $shopId, totalAmount: $totalAmount, itemsCount: $itemsCount, soldByName: $soldByName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SaleListItemCopyWith<$Res> implements $SaleListItemCopyWith<$Res> {
  factory _$SaleListItemCopyWith(_SaleListItem value, $Res Function(_SaleListItem) _then) = __$SaleListItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String shopId,@JsonKey(fromJson: _numToString) String totalAmount, int itemsCount, String soldByName, DateTime createdAt
});




}
/// @nodoc
class __$SaleListItemCopyWithImpl<$Res>
    implements _$SaleListItemCopyWith<$Res> {
  __$SaleListItemCopyWithImpl(this._self, this._then);

  final _SaleListItem _self;
  final $Res Function(_SaleListItem) _then;

/// Create a copy of SaleListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shopId = null,Object? totalAmount = null,Object? itemsCount = null,Object? soldByName = null,Object? createdAt = null,}) {
  return _then(_SaleListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,itemsCount: null == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int,soldByName: null == soldByName ? _self.soldByName : soldByName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
