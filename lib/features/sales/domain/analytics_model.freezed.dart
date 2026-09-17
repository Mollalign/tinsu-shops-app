// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsDataPoint {

 String get period; double get totalAmount; int get salesCount; int get itemsSold;
/// Create a copy of AnalyticsDataPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsDataPointCopyWith<AnalyticsDataPoint> get copyWith => _$AnalyticsDataPointCopyWithImpl<AnalyticsDataPoint>(this as AnalyticsDataPoint, _$identity);

  /// Serializes this AnalyticsDataPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsDataPoint&&(identical(other.period, period) || other.period == period)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,totalAmount,salesCount,itemsSold);

@override
String toString() {
  return 'AnalyticsDataPoint(period: $period, totalAmount: $totalAmount, salesCount: $salesCount, itemsSold: $itemsSold)';
}


}

/// @nodoc
abstract mixin class $AnalyticsDataPointCopyWith<$Res>  {
  factory $AnalyticsDataPointCopyWith(AnalyticsDataPoint value, $Res Function(AnalyticsDataPoint) _then) = _$AnalyticsDataPointCopyWithImpl;
@useResult
$Res call({
 String period, double totalAmount, int salesCount, int itemsSold
});




}
/// @nodoc
class _$AnalyticsDataPointCopyWithImpl<$Res>
    implements $AnalyticsDataPointCopyWith<$Res> {
  _$AnalyticsDataPointCopyWithImpl(this._self, this._then);

  final AnalyticsDataPoint _self;
  final $Res Function(AnalyticsDataPoint) _then;

/// Create a copy of AnalyticsDataPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? totalAmount = null,Object? salesCount = null,Object? itemsSold = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsDataPoint].
extension AnalyticsDataPointPatterns on AnalyticsDataPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsDataPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsDataPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsDataPoint value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsDataPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsDataPoint value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsDataPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  double totalAmount,  int salesCount,  int itemsSold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsDataPoint() when $default != null:
return $default(_that.period,_that.totalAmount,_that.salesCount,_that.itemsSold);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  double totalAmount,  int salesCount,  int itemsSold)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsDataPoint():
return $default(_that.period,_that.totalAmount,_that.salesCount,_that.itemsSold);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  double totalAmount,  int salesCount,  int itemsSold)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsDataPoint() when $default != null:
return $default(_that.period,_that.totalAmount,_that.salesCount,_that.itemsSold);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _AnalyticsDataPoint implements AnalyticsDataPoint {
  const _AnalyticsDataPoint({required this.period, this.totalAmount = 0.0, this.salesCount = 0, this.itemsSold = 0});
  factory _AnalyticsDataPoint.fromJson(Map<String, dynamic> json) => _$AnalyticsDataPointFromJson(json);

@override final  String period;
@override@JsonKey() final  double totalAmount;
@override@JsonKey() final  int salesCount;
@override@JsonKey() final  int itemsSold;

/// Create a copy of AnalyticsDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsDataPointCopyWith<_AnalyticsDataPoint> get copyWith => __$AnalyticsDataPointCopyWithImpl<_AnalyticsDataPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsDataPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsDataPoint&&(identical(other.period, period) || other.period == period)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,totalAmount,salesCount,itemsSold);

@override
String toString() {
  return 'AnalyticsDataPoint(period: $period, totalAmount: $totalAmount, salesCount: $salesCount, itemsSold: $itemsSold)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsDataPointCopyWith<$Res> implements $AnalyticsDataPointCopyWith<$Res> {
  factory _$AnalyticsDataPointCopyWith(_AnalyticsDataPoint value, $Res Function(_AnalyticsDataPoint) _then) = __$AnalyticsDataPointCopyWithImpl;
@override @useResult
$Res call({
 String period, double totalAmount, int salesCount, int itemsSold
});




}
/// @nodoc
class __$AnalyticsDataPointCopyWithImpl<$Res>
    implements _$AnalyticsDataPointCopyWith<$Res> {
  __$AnalyticsDataPointCopyWithImpl(this._self, this._then);

  final _AnalyticsDataPoint _self;
  final $Res Function(_AnalyticsDataPoint) _then;

/// Create a copy of AnalyticsDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? totalAmount = null,Object? salesCount = null,Object? itemsSold = null,}) {
  return _then(_AnalyticsDataPoint(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SalesAnalytics {

 String get period; String get startDate; String get endDate; double get totalAmount; int get salesCount; int get itemsSold; List<AnalyticsDataPoint> get data;
/// Create a copy of SalesAnalytics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesAnalyticsCopyWith<SalesAnalytics> get copyWith => _$SalesAnalyticsCopyWithImpl<SalesAnalytics>(this as SalesAnalytics, _$identity);

  /// Serializes this SalesAnalytics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesAnalytics&&(identical(other.period, period) || other.period == period)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,startDate,endDate,totalAmount,salesCount,itemsSold,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'SalesAnalytics(period: $period, startDate: $startDate, endDate: $endDate, totalAmount: $totalAmount, salesCount: $salesCount, itemsSold: $itemsSold, data: $data)';
}


}

/// @nodoc
abstract mixin class $SalesAnalyticsCopyWith<$Res>  {
  factory $SalesAnalyticsCopyWith(SalesAnalytics value, $Res Function(SalesAnalytics) _then) = _$SalesAnalyticsCopyWithImpl;
@useResult
$Res call({
 String period, String startDate, String endDate, double totalAmount, int salesCount, int itemsSold, List<AnalyticsDataPoint> data
});




}
/// @nodoc
class _$SalesAnalyticsCopyWithImpl<$Res>
    implements $SalesAnalyticsCopyWith<$Res> {
  _$SalesAnalyticsCopyWithImpl(this._self, this._then);

  final SalesAnalytics _self;
  final $Res Function(SalesAnalytics) _then;

/// Create a copy of SalesAnalytics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? startDate = null,Object? endDate = null,Object? totalAmount = null,Object? salesCount = null,Object? itemsSold = null,Object? data = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<AnalyticsDataPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesAnalytics].
extension SalesAnalyticsPatterns on SalesAnalytics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesAnalytics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesAnalytics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesAnalytics value)  $default,){
final _that = this;
switch (_that) {
case _SalesAnalytics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesAnalytics value)?  $default,){
final _that = this;
switch (_that) {
case _SalesAnalytics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  String startDate,  String endDate,  double totalAmount,  int salesCount,  int itemsSold,  List<AnalyticsDataPoint> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesAnalytics() when $default != null:
return $default(_that.period,_that.startDate,_that.endDate,_that.totalAmount,_that.salesCount,_that.itemsSold,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  String startDate,  String endDate,  double totalAmount,  int salesCount,  int itemsSold,  List<AnalyticsDataPoint> data)  $default,) {final _that = this;
switch (_that) {
case _SalesAnalytics():
return $default(_that.period,_that.startDate,_that.endDate,_that.totalAmount,_that.salesCount,_that.itemsSold,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  String startDate,  String endDate,  double totalAmount,  int salesCount,  int itemsSold,  List<AnalyticsDataPoint> data)?  $default,) {final _that = this;
switch (_that) {
case _SalesAnalytics() when $default != null:
return $default(_that.period,_that.startDate,_that.endDate,_that.totalAmount,_that.salesCount,_that.itemsSold,_that.data);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SalesAnalytics implements SalesAnalytics {
  const _SalesAnalytics({required this.period, required this.startDate, required this.endDate, this.totalAmount = 0.0, this.salesCount = 0, this.itemsSold = 0, final  List<AnalyticsDataPoint> data = const []}): _data = data;
  factory _SalesAnalytics.fromJson(Map<String, dynamic> json) => _$SalesAnalyticsFromJson(json);

@override final  String period;
@override final  String startDate;
@override final  String endDate;
@override@JsonKey() final  double totalAmount;
@override@JsonKey() final  int salesCount;
@override@JsonKey() final  int itemsSold;
 final  List<AnalyticsDataPoint> _data;
@override@JsonKey() List<AnalyticsDataPoint> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of SalesAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesAnalyticsCopyWith<_SalesAnalytics> get copyWith => __$SalesAnalyticsCopyWithImpl<_SalesAnalytics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesAnalyticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesAnalytics&&(identical(other.period, period) || other.period == period)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,startDate,endDate,totalAmount,salesCount,itemsSold,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'SalesAnalytics(period: $period, startDate: $startDate, endDate: $endDate, totalAmount: $totalAmount, salesCount: $salesCount, itemsSold: $itemsSold, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SalesAnalyticsCopyWith<$Res> implements $SalesAnalyticsCopyWith<$Res> {
  factory _$SalesAnalyticsCopyWith(_SalesAnalytics value, $Res Function(_SalesAnalytics) _then) = __$SalesAnalyticsCopyWithImpl;
@override @useResult
$Res call({
 String period, String startDate, String endDate, double totalAmount, int salesCount, int itemsSold, List<AnalyticsDataPoint> data
});




}
/// @nodoc
class __$SalesAnalyticsCopyWithImpl<$Res>
    implements _$SalesAnalyticsCopyWith<$Res> {
  __$SalesAnalyticsCopyWithImpl(this._self, this._then);

  final _SalesAnalytics _self;
  final $Res Function(_SalesAnalytics) _then;

/// Create a copy of SalesAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? startDate = null,Object? endDate = null,Object? totalAmount = null,Object? salesCount = null,Object? itemsSold = null,Object? data = null,}) {
  return _then(_SalesAnalytics(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<AnalyticsDataPoint>,
  ));
}


}


/// @nodoc
mixin _$WorkerAnalyticsItem {

 String get workerId; String get workerName; String get soldByType; int get salesCount; double get totalAmount; int get itemsSold;
/// Create a copy of WorkerAnalyticsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerAnalyticsItemCopyWith<WorkerAnalyticsItem> get copyWith => _$WorkerAnalyticsItemCopyWithImpl<WorkerAnalyticsItem>(this as WorkerAnalyticsItem, _$identity);

  /// Serializes this WorkerAnalyticsItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerAnalyticsItem&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.workerName, workerName) || other.workerName == workerName)&&(identical(other.soldByType, soldByType) || other.soldByType == soldByType)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workerId,workerName,soldByType,salesCount,totalAmount,itemsSold);

@override
String toString() {
  return 'WorkerAnalyticsItem(workerId: $workerId, workerName: $workerName, soldByType: $soldByType, salesCount: $salesCount, totalAmount: $totalAmount, itemsSold: $itemsSold)';
}


}

/// @nodoc
abstract mixin class $WorkerAnalyticsItemCopyWith<$Res>  {
  factory $WorkerAnalyticsItemCopyWith(WorkerAnalyticsItem value, $Res Function(WorkerAnalyticsItem) _then) = _$WorkerAnalyticsItemCopyWithImpl;
@useResult
$Res call({
 String workerId, String workerName, String soldByType, int salesCount, double totalAmount, int itemsSold
});




}
/// @nodoc
class _$WorkerAnalyticsItemCopyWithImpl<$Res>
    implements $WorkerAnalyticsItemCopyWith<$Res> {
  _$WorkerAnalyticsItemCopyWithImpl(this._self, this._then);

  final WorkerAnalyticsItem _self;
  final $Res Function(WorkerAnalyticsItem) _then;

/// Create a copy of WorkerAnalyticsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workerId = null,Object? workerName = null,Object? soldByType = null,Object? salesCount = null,Object? totalAmount = null,Object? itemsSold = null,}) {
  return _then(_self.copyWith(
workerId: null == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String,workerName: null == workerName ? _self.workerName : workerName // ignore: cast_nullable_to_non_nullable
as String,soldByType: null == soldByType ? _self.soldByType : soldByType // ignore: cast_nullable_to_non_nullable
as String,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerAnalyticsItem].
extension WorkerAnalyticsItemPatterns on WorkerAnalyticsItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerAnalyticsItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerAnalyticsItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerAnalyticsItem value)  $default,){
final _that = this;
switch (_that) {
case _WorkerAnalyticsItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerAnalyticsItem value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerAnalyticsItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workerId,  String workerName,  String soldByType,  int salesCount,  double totalAmount,  int itemsSold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerAnalyticsItem() when $default != null:
return $default(_that.workerId,_that.workerName,_that.soldByType,_that.salesCount,_that.totalAmount,_that.itemsSold);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workerId,  String workerName,  String soldByType,  int salesCount,  double totalAmount,  int itemsSold)  $default,) {final _that = this;
switch (_that) {
case _WorkerAnalyticsItem():
return $default(_that.workerId,_that.workerName,_that.soldByType,_that.salesCount,_that.totalAmount,_that.itemsSold);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workerId,  String workerName,  String soldByType,  int salesCount,  double totalAmount,  int itemsSold)?  $default,) {final _that = this;
switch (_that) {
case _WorkerAnalyticsItem() when $default != null:
return $default(_that.workerId,_that.workerName,_that.soldByType,_that.salesCount,_that.totalAmount,_that.itemsSold);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _WorkerAnalyticsItem implements WorkerAnalyticsItem {
  const _WorkerAnalyticsItem({required this.workerId, required this.workerName, required this.soldByType, this.salesCount = 0, this.totalAmount = 0.0, this.itemsSold = 0});
  factory _WorkerAnalyticsItem.fromJson(Map<String, dynamic> json) => _$WorkerAnalyticsItemFromJson(json);

@override final  String workerId;
@override final  String workerName;
@override final  String soldByType;
@override@JsonKey() final  int salesCount;
@override@JsonKey() final  double totalAmount;
@override@JsonKey() final  int itemsSold;

/// Create a copy of WorkerAnalyticsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerAnalyticsItemCopyWith<_WorkerAnalyticsItem> get copyWith => __$WorkerAnalyticsItemCopyWithImpl<_WorkerAnalyticsItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerAnalyticsItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerAnalyticsItem&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.workerName, workerName) || other.workerName == workerName)&&(identical(other.soldByType, soldByType) || other.soldByType == soldByType)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workerId,workerName,soldByType,salesCount,totalAmount,itemsSold);

@override
String toString() {
  return 'WorkerAnalyticsItem(workerId: $workerId, workerName: $workerName, soldByType: $soldByType, salesCount: $salesCount, totalAmount: $totalAmount, itemsSold: $itemsSold)';
}


}

/// @nodoc
abstract mixin class _$WorkerAnalyticsItemCopyWith<$Res> implements $WorkerAnalyticsItemCopyWith<$Res> {
  factory _$WorkerAnalyticsItemCopyWith(_WorkerAnalyticsItem value, $Res Function(_WorkerAnalyticsItem) _then) = __$WorkerAnalyticsItemCopyWithImpl;
@override @useResult
$Res call({
 String workerId, String workerName, String soldByType, int salesCount, double totalAmount, int itemsSold
});




}
/// @nodoc
class __$WorkerAnalyticsItemCopyWithImpl<$Res>
    implements _$WorkerAnalyticsItemCopyWith<$Res> {
  __$WorkerAnalyticsItemCopyWithImpl(this._self, this._then);

  final _WorkerAnalyticsItem _self;
  final $Res Function(_WorkerAnalyticsItem) _then;

/// Create a copy of WorkerAnalyticsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workerId = null,Object? workerName = null,Object? soldByType = null,Object? salesCount = null,Object? totalAmount = null,Object? itemsSold = null,}) {
  return _then(_WorkerAnalyticsItem(
workerId: null == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String,workerName: null == workerName ? _self.workerName : workerName // ignore: cast_nullable_to_non_nullable
as String,soldByType: null == soldByType ? _self.soldByType : soldByType // ignore: cast_nullable_to_non_nullable
as String,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WorkerAnalytics {

 String get startDate; String get endDate; List<WorkerAnalyticsItem> get workers;
/// Create a copy of WorkerAnalytics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerAnalyticsCopyWith<WorkerAnalytics> get copyWith => _$WorkerAnalyticsCopyWithImpl<WorkerAnalytics>(this as WorkerAnalytics, _$identity);

  /// Serializes this WorkerAnalytics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerAnalytics&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.workers, workers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,const DeepCollectionEquality().hash(workers));

@override
String toString() {
  return 'WorkerAnalytics(startDate: $startDate, endDate: $endDate, workers: $workers)';
}


}

/// @nodoc
abstract mixin class $WorkerAnalyticsCopyWith<$Res>  {
  factory $WorkerAnalyticsCopyWith(WorkerAnalytics value, $Res Function(WorkerAnalytics) _then) = _$WorkerAnalyticsCopyWithImpl;
@useResult
$Res call({
 String startDate, String endDate, List<WorkerAnalyticsItem> workers
});




}
/// @nodoc
class _$WorkerAnalyticsCopyWithImpl<$Res>
    implements $WorkerAnalyticsCopyWith<$Res> {
  _$WorkerAnalyticsCopyWithImpl(this._self, this._then);

  final WorkerAnalytics _self;
  final $Res Function(WorkerAnalytics) _then;

/// Create a copy of WorkerAnalytics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? endDate = null,Object? workers = null,}) {
  return _then(_self.copyWith(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,workers: null == workers ? _self.workers : workers // ignore: cast_nullable_to_non_nullable
as List<WorkerAnalyticsItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerAnalytics].
extension WorkerAnalyticsPatterns on WorkerAnalytics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerAnalytics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerAnalytics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerAnalytics value)  $default,){
final _that = this;
switch (_that) {
case _WorkerAnalytics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerAnalytics value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerAnalytics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String startDate,  String endDate,  List<WorkerAnalyticsItem> workers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerAnalytics() when $default != null:
return $default(_that.startDate,_that.endDate,_that.workers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String startDate,  String endDate,  List<WorkerAnalyticsItem> workers)  $default,) {final _that = this;
switch (_that) {
case _WorkerAnalytics():
return $default(_that.startDate,_that.endDate,_that.workers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String startDate,  String endDate,  List<WorkerAnalyticsItem> workers)?  $default,) {final _that = this;
switch (_that) {
case _WorkerAnalytics() when $default != null:
return $default(_that.startDate,_that.endDate,_that.workers);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _WorkerAnalytics implements WorkerAnalytics {
  const _WorkerAnalytics({required this.startDate, required this.endDate, final  List<WorkerAnalyticsItem> workers = const []}): _workers = workers;
  factory _WorkerAnalytics.fromJson(Map<String, dynamic> json) => _$WorkerAnalyticsFromJson(json);

@override final  String startDate;
@override final  String endDate;
 final  List<WorkerAnalyticsItem> _workers;
@override@JsonKey() List<WorkerAnalyticsItem> get workers {
  if (_workers is EqualUnmodifiableListView) return _workers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workers);
}


/// Create a copy of WorkerAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerAnalyticsCopyWith<_WorkerAnalytics> get copyWith => __$WorkerAnalyticsCopyWithImpl<_WorkerAnalytics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerAnalyticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerAnalytics&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._workers, _workers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,const DeepCollectionEquality().hash(_workers));

@override
String toString() {
  return 'WorkerAnalytics(startDate: $startDate, endDate: $endDate, workers: $workers)';
}


}

/// @nodoc
abstract mixin class _$WorkerAnalyticsCopyWith<$Res> implements $WorkerAnalyticsCopyWith<$Res> {
  factory _$WorkerAnalyticsCopyWith(_WorkerAnalytics value, $Res Function(_WorkerAnalytics) _then) = __$WorkerAnalyticsCopyWithImpl;
@override @useResult
$Res call({
 String startDate, String endDate, List<WorkerAnalyticsItem> workers
});




}
/// @nodoc
class __$WorkerAnalyticsCopyWithImpl<$Res>
    implements _$WorkerAnalyticsCopyWith<$Res> {
  __$WorkerAnalyticsCopyWithImpl(this._self, this._then);

  final _WorkerAnalytics _self;
  final $Res Function(_WorkerAnalytics) _then;

/// Create a copy of WorkerAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,Object? workers = null,}) {
  return _then(_WorkerAnalytics(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,workers: null == workers ? _self._workers : workers // ignore: cast_nullable_to_non_nullable
as List<WorkerAnalyticsItem>,
  ));
}


}

// dart format on
