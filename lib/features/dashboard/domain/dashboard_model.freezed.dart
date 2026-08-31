// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentBreakdown {

 String get cash; String get telebirr; String get cbeBirr; String get other;
/// Create a copy of PaymentBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentBreakdownCopyWith<PaymentBreakdown> get copyWith => _$PaymentBreakdownCopyWithImpl<PaymentBreakdown>(this as PaymentBreakdown, _$identity);

  /// Serializes this PaymentBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentBreakdown&&(identical(other.cash, cash) || other.cash == cash)&&(identical(other.telebirr, telebirr) || other.telebirr == telebirr)&&(identical(other.cbeBirr, cbeBirr) || other.cbeBirr == cbeBirr)&&(identical(other.other, this.other) || other.other == this.other));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cash,telebirr,cbeBirr,other);

@override
String toString() {
  return 'PaymentBreakdown(cash: $cash, telebirr: $telebirr, cbeBirr: $cbeBirr, other: $other)';
}


}

/// @nodoc
abstract mixin class $PaymentBreakdownCopyWith<$Res>  {
  factory $PaymentBreakdownCopyWith(PaymentBreakdown value, $Res Function(PaymentBreakdown) _then) = _$PaymentBreakdownCopyWithImpl;
@useResult
$Res call({
 String cash, String telebirr, String cbeBirr, String other
});




}
/// @nodoc
class _$PaymentBreakdownCopyWithImpl<$Res>
    implements $PaymentBreakdownCopyWith<$Res> {
  _$PaymentBreakdownCopyWithImpl(this._self, this._then);

  final PaymentBreakdown _self;
  final $Res Function(PaymentBreakdown) _then;

/// Create a copy of PaymentBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cash = null,Object? telebirr = null,Object? cbeBirr = null,Object? other = null,}) {
  return _then(_self.copyWith(
cash: null == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as String,telebirr: null == telebirr ? _self.telebirr : telebirr // ignore: cast_nullable_to_non_nullable
as String,cbeBirr: null == cbeBirr ? _self.cbeBirr : cbeBirr // ignore: cast_nullable_to_non_nullable
as String,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentBreakdown].
extension PaymentBreakdownPatterns on PaymentBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _PaymentBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cash,  String telebirr,  String cbeBirr,  String other)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentBreakdown() when $default != null:
return $default(_that.cash,_that.telebirr,_that.cbeBirr,_that.other);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cash,  String telebirr,  String cbeBirr,  String other)  $default,) {final _that = this;
switch (_that) {
case _PaymentBreakdown():
return $default(_that.cash,_that.telebirr,_that.cbeBirr,_that.other);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cash,  String telebirr,  String cbeBirr,  String other)?  $default,) {final _that = this;
switch (_that) {
case _PaymentBreakdown() when $default != null:
return $default(_that.cash,_that.telebirr,_that.cbeBirr,_that.other);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _PaymentBreakdown implements PaymentBreakdown {
  const _PaymentBreakdown({this.cash = '0', this.telebirr = '0', this.cbeBirr = '0', this.other = '0'});
  factory _PaymentBreakdown.fromJson(Map<String, dynamic> json) => _$PaymentBreakdownFromJson(json);

@override@JsonKey() final  String cash;
@override@JsonKey() final  String telebirr;
@override@JsonKey() final  String cbeBirr;
@override@JsonKey() final  String other;

/// Create a copy of PaymentBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentBreakdownCopyWith<_PaymentBreakdown> get copyWith => __$PaymentBreakdownCopyWithImpl<_PaymentBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentBreakdown&&(identical(other.cash, cash) || other.cash == cash)&&(identical(other.telebirr, telebirr) || other.telebirr == telebirr)&&(identical(other.cbeBirr, cbeBirr) || other.cbeBirr == cbeBirr)&&(identical(other.other, this.other) || other.other == this.other));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cash,telebirr,cbeBirr,other);

@override
String toString() {
  return 'PaymentBreakdown(cash: $cash, telebirr: $telebirr, cbeBirr: $cbeBirr, other: $other)';
}


}

/// @nodoc
abstract mixin class _$PaymentBreakdownCopyWith<$Res> implements $PaymentBreakdownCopyWith<$Res> {
  factory _$PaymentBreakdownCopyWith(_PaymentBreakdown value, $Res Function(_PaymentBreakdown) _then) = __$PaymentBreakdownCopyWithImpl;
@override @useResult
$Res call({
 String cash, String telebirr, String cbeBirr, String other
});




}
/// @nodoc
class __$PaymentBreakdownCopyWithImpl<$Res>
    implements _$PaymentBreakdownCopyWith<$Res> {
  __$PaymentBreakdownCopyWithImpl(this._self, this._then);

  final _PaymentBreakdown _self;
  final $Res Function(_PaymentBreakdown) _then;

/// Create a copy of PaymentBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cash = null,Object? telebirr = null,Object? cbeBirr = null,Object? other = null,}) {
  return _then(_PaymentBreakdown(
cash: null == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as String,telebirr: null == telebirr ? _self.telebirr : telebirr // ignore: cast_nullable_to_non_nullable
as String,cbeBirr: null == cbeBirr ? _self.cbeBirr : cbeBirr // ignore: cast_nullable_to_non_nullable
as String,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TodayReport {

 String get date;@JsonKey(fromJson: _numToString) String get totalSales; int get numberOfSales; int get itemsSold;// paymentBreakdown is not returned by the backend — kept for UI compat only.
@JsonKey(includeFromJson: false, includeToJson: false) PaymentBreakdown get paymentBreakdown; int get lowStockCount;
/// Create a copy of TodayReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayReportCopyWith<TodayReport> get copyWith => _$TodayReportCopyWithImpl<TodayReport>(this as TodayReport, _$identity);

  /// Serializes this TodayReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayReport&&(identical(other.date, date) || other.date == date)&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.numberOfSales, numberOfSales) || other.numberOfSales == numberOfSales)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&(identical(other.paymentBreakdown, paymentBreakdown) || other.paymentBreakdown == paymentBreakdown)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalSales,numberOfSales,itemsSold,paymentBreakdown,lowStockCount);

@override
String toString() {
  return 'TodayReport(date: $date, totalSales: $totalSales, numberOfSales: $numberOfSales, itemsSold: $itemsSold, paymentBreakdown: $paymentBreakdown, lowStockCount: $lowStockCount)';
}


}

/// @nodoc
abstract mixin class $TodayReportCopyWith<$Res>  {
  factory $TodayReportCopyWith(TodayReport value, $Res Function(TodayReport) _then) = _$TodayReportCopyWithImpl;
@useResult
$Res call({
 String date,@JsonKey(fromJson: _numToString) String totalSales, int numberOfSales, int itemsSold,@JsonKey(includeFromJson: false, includeToJson: false) PaymentBreakdown paymentBreakdown, int lowStockCount
});


$PaymentBreakdownCopyWith<$Res> get paymentBreakdown;

}
/// @nodoc
class _$TodayReportCopyWithImpl<$Res>
    implements $TodayReportCopyWith<$Res> {
  _$TodayReportCopyWithImpl(this._self, this._then);

  final TodayReport _self;
  final $Res Function(TodayReport) _then;

/// Create a copy of TodayReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? totalSales = null,Object? numberOfSales = null,Object? itemsSold = null,Object? paymentBreakdown = null,Object? lowStockCount = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as String,numberOfSales: null == numberOfSales ? _self.numberOfSales : numberOfSales // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,paymentBreakdown: null == paymentBreakdown ? _self.paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as PaymentBreakdown,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TodayReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentBreakdownCopyWith<$Res> get paymentBreakdown {
  
  return $PaymentBreakdownCopyWith<$Res>(_self.paymentBreakdown, (value) {
    return _then(_self.copyWith(paymentBreakdown: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodayReport].
extension TodayReportPatterns on TodayReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayReport value)  $default,){
final _that = this;
switch (_that) {
case _TodayReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayReport value)?  $default,){
final _that = this;
switch (_that) {
case _TodayReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date, @JsonKey(fromJson: _numToString)  String totalSales,  int numberOfSales,  int itemsSold, @JsonKey(includeFromJson: false, includeToJson: false)  PaymentBreakdown paymentBreakdown,  int lowStockCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayReport() when $default != null:
return $default(_that.date,_that.totalSales,_that.numberOfSales,_that.itemsSold,_that.paymentBreakdown,_that.lowStockCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date, @JsonKey(fromJson: _numToString)  String totalSales,  int numberOfSales,  int itemsSold, @JsonKey(includeFromJson: false, includeToJson: false)  PaymentBreakdown paymentBreakdown,  int lowStockCount)  $default,) {final _that = this;
switch (_that) {
case _TodayReport():
return $default(_that.date,_that.totalSales,_that.numberOfSales,_that.itemsSold,_that.paymentBreakdown,_that.lowStockCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date, @JsonKey(fromJson: _numToString)  String totalSales,  int numberOfSales,  int itemsSold, @JsonKey(includeFromJson: false, includeToJson: false)  PaymentBreakdown paymentBreakdown,  int lowStockCount)?  $default,) {final _that = this;
switch (_that) {
case _TodayReport() when $default != null:
return $default(_that.date,_that.totalSales,_that.numberOfSales,_that.itemsSold,_that.paymentBreakdown,_that.lowStockCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TodayReport implements TodayReport {
  const _TodayReport({required this.date, @JsonKey(fromJson: _numToString) required this.totalSales, required this.numberOfSales, required this.itemsSold, @JsonKey(includeFromJson: false, includeToJson: false) this.paymentBreakdown = const PaymentBreakdown(), required this.lowStockCount});
  factory _TodayReport.fromJson(Map<String, dynamic> json) => _$TodayReportFromJson(json);

@override final  String date;
@override@JsonKey(fromJson: _numToString) final  String totalSales;
@override final  int numberOfSales;
@override final  int itemsSold;
// paymentBreakdown is not returned by the backend — kept for UI compat only.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  PaymentBreakdown paymentBreakdown;
@override final  int lowStockCount;

/// Create a copy of TodayReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayReportCopyWith<_TodayReport> get copyWith => __$TodayReportCopyWithImpl<_TodayReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodayReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayReport&&(identical(other.date, date) || other.date == date)&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.numberOfSales, numberOfSales) || other.numberOfSales == numberOfSales)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&(identical(other.paymentBreakdown, paymentBreakdown) || other.paymentBreakdown == paymentBreakdown)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalSales,numberOfSales,itemsSold,paymentBreakdown,lowStockCount);

@override
String toString() {
  return 'TodayReport(date: $date, totalSales: $totalSales, numberOfSales: $numberOfSales, itemsSold: $itemsSold, paymentBreakdown: $paymentBreakdown, lowStockCount: $lowStockCount)';
}


}

/// @nodoc
abstract mixin class _$TodayReportCopyWith<$Res> implements $TodayReportCopyWith<$Res> {
  factory _$TodayReportCopyWith(_TodayReport value, $Res Function(_TodayReport) _then) = __$TodayReportCopyWithImpl;
@override @useResult
$Res call({
 String date,@JsonKey(fromJson: _numToString) String totalSales, int numberOfSales, int itemsSold,@JsonKey(includeFromJson: false, includeToJson: false) PaymentBreakdown paymentBreakdown, int lowStockCount
});


@override $PaymentBreakdownCopyWith<$Res> get paymentBreakdown;

}
/// @nodoc
class __$TodayReportCopyWithImpl<$Res>
    implements _$TodayReportCopyWith<$Res> {
  __$TodayReportCopyWithImpl(this._self, this._then);

  final _TodayReport _self;
  final $Res Function(_TodayReport) _then;

/// Create a copy of TodayReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? totalSales = null,Object? numberOfSales = null,Object? itemsSold = null,Object? paymentBreakdown = null,Object? lowStockCount = null,}) {
  return _then(_TodayReport(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as String,numberOfSales: null == numberOfSales ? _self.numberOfSales : numberOfSales // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,paymentBreakdown: null == paymentBreakdown ? _self.paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as PaymentBreakdown,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TodayReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentBreakdownCopyWith<$Res> get paymentBreakdown {
  
  return $PaymentBreakdownCopyWith<$Res>(_self.paymentBreakdown, (value) {
    return _then(_self.copyWith(paymentBreakdown: value));
  });
}
}


/// @nodoc
mixin _$WorkerTodayReport {

@JsonKey(fromJson: _numToString) String get totalSales; int get numberOfSales; int get itemsSold;// paymentBreakdown is not returned by the backend — kept for UI compat only.
@JsonKey(includeFromJson: false, includeToJson: false) PaymentBreakdown get paymentBreakdown;
/// Create a copy of WorkerTodayReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerTodayReportCopyWith<WorkerTodayReport> get copyWith => _$WorkerTodayReportCopyWithImpl<WorkerTodayReport>(this as WorkerTodayReport, _$identity);

  /// Serializes this WorkerTodayReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerTodayReport&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.numberOfSales, numberOfSales) || other.numberOfSales == numberOfSales)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&(identical(other.paymentBreakdown, paymentBreakdown) || other.paymentBreakdown == paymentBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSales,numberOfSales,itemsSold,paymentBreakdown);

@override
String toString() {
  return 'WorkerTodayReport(totalSales: $totalSales, numberOfSales: $numberOfSales, itemsSold: $itemsSold, paymentBreakdown: $paymentBreakdown)';
}


}

/// @nodoc
abstract mixin class $WorkerTodayReportCopyWith<$Res>  {
  factory $WorkerTodayReportCopyWith(WorkerTodayReport value, $Res Function(WorkerTodayReport) _then) = _$WorkerTodayReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _numToString) String totalSales, int numberOfSales, int itemsSold,@JsonKey(includeFromJson: false, includeToJson: false) PaymentBreakdown paymentBreakdown
});


$PaymentBreakdownCopyWith<$Res> get paymentBreakdown;

}
/// @nodoc
class _$WorkerTodayReportCopyWithImpl<$Res>
    implements $WorkerTodayReportCopyWith<$Res> {
  _$WorkerTodayReportCopyWithImpl(this._self, this._then);

  final WorkerTodayReport _self;
  final $Res Function(WorkerTodayReport) _then;

/// Create a copy of WorkerTodayReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSales = null,Object? numberOfSales = null,Object? itemsSold = null,Object? paymentBreakdown = null,}) {
  return _then(_self.copyWith(
totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as String,numberOfSales: null == numberOfSales ? _self.numberOfSales : numberOfSales // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,paymentBreakdown: null == paymentBreakdown ? _self.paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as PaymentBreakdown,
  ));
}
/// Create a copy of WorkerTodayReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentBreakdownCopyWith<$Res> get paymentBreakdown {
  
  return $PaymentBreakdownCopyWith<$Res>(_self.paymentBreakdown, (value) {
    return _then(_self.copyWith(paymentBreakdown: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkerTodayReport].
extension WorkerTodayReportPatterns on WorkerTodayReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerTodayReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerTodayReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerTodayReport value)  $default,){
final _that = this;
switch (_that) {
case _WorkerTodayReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerTodayReport value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerTodayReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _numToString)  String totalSales,  int numberOfSales,  int itemsSold, @JsonKey(includeFromJson: false, includeToJson: false)  PaymentBreakdown paymentBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerTodayReport() when $default != null:
return $default(_that.totalSales,_that.numberOfSales,_that.itemsSold,_that.paymentBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _numToString)  String totalSales,  int numberOfSales,  int itemsSold, @JsonKey(includeFromJson: false, includeToJson: false)  PaymentBreakdown paymentBreakdown)  $default,) {final _that = this;
switch (_that) {
case _WorkerTodayReport():
return $default(_that.totalSales,_that.numberOfSales,_that.itemsSold,_that.paymentBreakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _numToString)  String totalSales,  int numberOfSales,  int itemsSold, @JsonKey(includeFromJson: false, includeToJson: false)  PaymentBreakdown paymentBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _WorkerTodayReport() when $default != null:
return $default(_that.totalSales,_that.numberOfSales,_that.itemsSold,_that.paymentBreakdown);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _WorkerTodayReport implements WorkerTodayReport {
  const _WorkerTodayReport({@JsonKey(fromJson: _numToString) required this.totalSales, required this.numberOfSales, required this.itemsSold, @JsonKey(includeFromJson: false, includeToJson: false) this.paymentBreakdown = const PaymentBreakdown()});
  factory _WorkerTodayReport.fromJson(Map<String, dynamic> json) => _$WorkerTodayReportFromJson(json);

@override@JsonKey(fromJson: _numToString) final  String totalSales;
@override final  int numberOfSales;
@override final  int itemsSold;
// paymentBreakdown is not returned by the backend — kept for UI compat only.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  PaymentBreakdown paymentBreakdown;

/// Create a copy of WorkerTodayReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerTodayReportCopyWith<_WorkerTodayReport> get copyWith => __$WorkerTodayReportCopyWithImpl<_WorkerTodayReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerTodayReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerTodayReport&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.numberOfSales, numberOfSales) || other.numberOfSales == numberOfSales)&&(identical(other.itemsSold, itemsSold) || other.itemsSold == itemsSold)&&(identical(other.paymentBreakdown, paymentBreakdown) || other.paymentBreakdown == paymentBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSales,numberOfSales,itemsSold,paymentBreakdown);

@override
String toString() {
  return 'WorkerTodayReport(totalSales: $totalSales, numberOfSales: $numberOfSales, itemsSold: $itemsSold, paymentBreakdown: $paymentBreakdown)';
}


}

/// @nodoc
abstract mixin class _$WorkerTodayReportCopyWith<$Res> implements $WorkerTodayReportCopyWith<$Res> {
  factory _$WorkerTodayReportCopyWith(_WorkerTodayReport value, $Res Function(_WorkerTodayReport) _then) = __$WorkerTodayReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _numToString) String totalSales, int numberOfSales, int itemsSold,@JsonKey(includeFromJson: false, includeToJson: false) PaymentBreakdown paymentBreakdown
});


@override $PaymentBreakdownCopyWith<$Res> get paymentBreakdown;

}
/// @nodoc
class __$WorkerTodayReportCopyWithImpl<$Res>
    implements _$WorkerTodayReportCopyWith<$Res> {
  __$WorkerTodayReportCopyWithImpl(this._self, this._then);

  final _WorkerTodayReport _self;
  final $Res Function(_WorkerTodayReport) _then;

/// Create a copy of WorkerTodayReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSales = null,Object? numberOfSales = null,Object? itemsSold = null,Object? paymentBreakdown = null,}) {
  return _then(_WorkerTodayReport(
totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as String,numberOfSales: null == numberOfSales ? _self.numberOfSales : numberOfSales // ignore: cast_nullable_to_non_nullable
as int,itemsSold: null == itemsSold ? _self.itemsSold : itemsSold // ignore: cast_nullable_to_non_nullable
as int,paymentBreakdown: null == paymentBreakdown ? _self.paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as PaymentBreakdown,
  ));
}

/// Create a copy of WorkerTodayReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentBreakdownCopyWith<$Res> get paymentBreakdown {
  
  return $PaymentBreakdownCopyWith<$Res>(_self.paymentBreakdown, (value) {
    return _then(_self.copyWith(paymentBreakdown: value));
  });
}
}


/// @nodoc
mixin _$ShopDailySummary {

 String get shopId; String get shopName;@JsonKey(fromJson: _numToString) String get todaySales; int get numberOfSales;
/// Create a copy of ShopDailySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopDailySummaryCopyWith<ShopDailySummary> get copyWith => _$ShopDailySummaryCopyWithImpl<ShopDailySummary>(this as ShopDailySummary, _$identity);

  /// Serializes this ShopDailySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopDailySummary&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.shopName, shopName) || other.shopName == shopName)&&(identical(other.todaySales, todaySales) || other.todaySales == todaySales)&&(identical(other.numberOfSales, numberOfSales) || other.numberOfSales == numberOfSales));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shopId,shopName,todaySales,numberOfSales);

@override
String toString() {
  return 'ShopDailySummary(shopId: $shopId, shopName: $shopName, todaySales: $todaySales, numberOfSales: $numberOfSales)';
}


}

/// @nodoc
abstract mixin class $ShopDailySummaryCopyWith<$Res>  {
  factory $ShopDailySummaryCopyWith(ShopDailySummary value, $Res Function(ShopDailySummary) _then) = _$ShopDailySummaryCopyWithImpl;
@useResult
$Res call({
 String shopId, String shopName,@JsonKey(fromJson: _numToString) String todaySales, int numberOfSales
});




}
/// @nodoc
class _$ShopDailySummaryCopyWithImpl<$Res>
    implements $ShopDailySummaryCopyWith<$Res> {
  _$ShopDailySummaryCopyWithImpl(this._self, this._then);

  final ShopDailySummary _self;
  final $Res Function(ShopDailySummary) _then;

/// Create a copy of ShopDailySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shopId = null,Object? shopName = null,Object? todaySales = null,Object? numberOfSales = null,}) {
  return _then(_self.copyWith(
shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,shopName: null == shopName ? _self.shopName : shopName // ignore: cast_nullable_to_non_nullable
as String,todaySales: null == todaySales ? _self.todaySales : todaySales // ignore: cast_nullable_to_non_nullable
as String,numberOfSales: null == numberOfSales ? _self.numberOfSales : numberOfSales // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopDailySummary].
extension ShopDailySummaryPatterns on ShopDailySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopDailySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopDailySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopDailySummary value)  $default,){
final _that = this;
switch (_that) {
case _ShopDailySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopDailySummary value)?  $default,){
final _that = this;
switch (_that) {
case _ShopDailySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String shopId,  String shopName, @JsonKey(fromJson: _numToString)  String todaySales,  int numberOfSales)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopDailySummary() when $default != null:
return $default(_that.shopId,_that.shopName,_that.todaySales,_that.numberOfSales);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String shopId,  String shopName, @JsonKey(fromJson: _numToString)  String todaySales,  int numberOfSales)  $default,) {final _that = this;
switch (_that) {
case _ShopDailySummary():
return $default(_that.shopId,_that.shopName,_that.todaySales,_that.numberOfSales);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String shopId,  String shopName, @JsonKey(fromJson: _numToString)  String todaySales,  int numberOfSales)?  $default,) {final _that = this;
switch (_that) {
case _ShopDailySummary() when $default != null:
return $default(_that.shopId,_that.shopName,_that.todaySales,_that.numberOfSales);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ShopDailySummary implements ShopDailySummary {
  const _ShopDailySummary({required this.shopId, required this.shopName, @JsonKey(fromJson: _numToString) required this.todaySales, required this.numberOfSales});
  factory _ShopDailySummary.fromJson(Map<String, dynamic> json) => _$ShopDailySummaryFromJson(json);

@override final  String shopId;
@override final  String shopName;
@override@JsonKey(fromJson: _numToString) final  String todaySales;
@override final  int numberOfSales;

/// Create a copy of ShopDailySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopDailySummaryCopyWith<_ShopDailySummary> get copyWith => __$ShopDailySummaryCopyWithImpl<_ShopDailySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShopDailySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopDailySummary&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.shopName, shopName) || other.shopName == shopName)&&(identical(other.todaySales, todaySales) || other.todaySales == todaySales)&&(identical(other.numberOfSales, numberOfSales) || other.numberOfSales == numberOfSales));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shopId,shopName,todaySales,numberOfSales);

@override
String toString() {
  return 'ShopDailySummary(shopId: $shopId, shopName: $shopName, todaySales: $todaySales, numberOfSales: $numberOfSales)';
}


}

/// @nodoc
abstract mixin class _$ShopDailySummaryCopyWith<$Res> implements $ShopDailySummaryCopyWith<$Res> {
  factory _$ShopDailySummaryCopyWith(_ShopDailySummary value, $Res Function(_ShopDailySummary) _then) = __$ShopDailySummaryCopyWithImpl;
@override @useResult
$Res call({
 String shopId, String shopName,@JsonKey(fromJson: _numToString) String todaySales, int numberOfSales
});




}
/// @nodoc
class __$ShopDailySummaryCopyWithImpl<$Res>
    implements _$ShopDailySummaryCopyWith<$Res> {
  __$ShopDailySummaryCopyWithImpl(this._self, this._then);

  final _ShopDailySummary _self;
  final $Res Function(_ShopDailySummary) _then;

/// Create a copy of ShopDailySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shopId = null,Object? shopName = null,Object? todaySales = null,Object? numberOfSales = null,}) {
  return _then(_ShopDailySummary(
shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,shopName: null == shopName ? _self.shopName : shopName // ignore: cast_nullable_to_non_nullable
as String,todaySales: null == todaySales ? _self.todaySales : todaySales // ignore: cast_nullable_to_non_nullable
as String,numberOfSales: null == numberOfSales ? _self.numberOfSales : numberOfSales // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OwnerDashboard {

 List<ShopDailySummary> get shops;@JsonKey(fromJson: _numToString) String get totalTodaySales;
/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerDashboardCopyWith<OwnerDashboard> get copyWith => _$OwnerDashboardCopyWithImpl<OwnerDashboard>(this as OwnerDashboard, _$identity);

  /// Serializes this OwnerDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerDashboard&&const DeepCollectionEquality().equals(other.shops, shops)&&(identical(other.totalTodaySales, totalTodaySales) || other.totalTodaySales == totalTodaySales));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(shops),totalTodaySales);

@override
String toString() {
  return 'OwnerDashboard(shops: $shops, totalTodaySales: $totalTodaySales)';
}


}

/// @nodoc
abstract mixin class $OwnerDashboardCopyWith<$Res>  {
  factory $OwnerDashboardCopyWith(OwnerDashboard value, $Res Function(OwnerDashboard) _then) = _$OwnerDashboardCopyWithImpl;
@useResult
$Res call({
 List<ShopDailySummary> shops,@JsonKey(fromJson: _numToString) String totalTodaySales
});




}
/// @nodoc
class _$OwnerDashboardCopyWithImpl<$Res>
    implements $OwnerDashboardCopyWith<$Res> {
  _$OwnerDashboardCopyWithImpl(this._self, this._then);

  final OwnerDashboard _self;
  final $Res Function(OwnerDashboard) _then;

/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shops = null,Object? totalTodaySales = null,}) {
  return _then(_self.copyWith(
shops: null == shops ? _self.shops : shops // ignore: cast_nullable_to_non_nullable
as List<ShopDailySummary>,totalTodaySales: null == totalTodaySales ? _self.totalTodaySales : totalTodaySales // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnerDashboard].
extension OwnerDashboardPatterns on OwnerDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerDashboard value)  $default,){
final _that = this;
switch (_that) {
case _OwnerDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ShopDailySummary> shops, @JsonKey(fromJson: _numToString)  String totalTodaySales)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerDashboard() when $default != null:
return $default(_that.shops,_that.totalTodaySales);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ShopDailySummary> shops, @JsonKey(fromJson: _numToString)  String totalTodaySales)  $default,) {final _that = this;
switch (_that) {
case _OwnerDashboard():
return $default(_that.shops,_that.totalTodaySales);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ShopDailySummary> shops, @JsonKey(fromJson: _numToString)  String totalTodaySales)?  $default,) {final _that = this;
switch (_that) {
case _OwnerDashboard() when $default != null:
return $default(_that.shops,_that.totalTodaySales);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _OwnerDashboard implements OwnerDashboard {
  const _OwnerDashboard({required final  List<ShopDailySummary> shops, @JsonKey(fromJson: _numToString) required this.totalTodaySales}): _shops = shops;
  factory _OwnerDashboard.fromJson(Map<String, dynamic> json) => _$OwnerDashboardFromJson(json);

 final  List<ShopDailySummary> _shops;
@override List<ShopDailySummary> get shops {
  if (_shops is EqualUnmodifiableListView) return _shops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shops);
}

@override@JsonKey(fromJson: _numToString) final  String totalTodaySales;

/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerDashboardCopyWith<_OwnerDashboard> get copyWith => __$OwnerDashboardCopyWithImpl<_OwnerDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerDashboard&&const DeepCollectionEquality().equals(other._shops, _shops)&&(identical(other.totalTodaySales, totalTodaySales) || other.totalTodaySales == totalTodaySales));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_shops),totalTodaySales);

@override
String toString() {
  return 'OwnerDashboard(shops: $shops, totalTodaySales: $totalTodaySales)';
}


}

/// @nodoc
abstract mixin class _$OwnerDashboardCopyWith<$Res> implements $OwnerDashboardCopyWith<$Res> {
  factory _$OwnerDashboardCopyWith(_OwnerDashboard value, $Res Function(_OwnerDashboard) _then) = __$OwnerDashboardCopyWithImpl;
@override @useResult
$Res call({
 List<ShopDailySummary> shops,@JsonKey(fromJson: _numToString) String totalTodaySales
});




}
/// @nodoc
class __$OwnerDashboardCopyWithImpl<$Res>
    implements _$OwnerDashboardCopyWith<$Res> {
  __$OwnerDashboardCopyWithImpl(this._self, this._then);

  final _OwnerDashboard _self;
  final $Res Function(_OwnerDashboard) _then;

/// Create a copy of OwnerDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shops = null,Object? totalTodaySales = null,}) {
  return _then(_OwnerDashboard(
shops: null == shops ? _self._shops : shops // ignore: cast_nullable_to_non_nullable
as List<ShopDailySummary>,totalTodaySales: null == totalTodaySales ? _self.totalTodaySales : totalTodaySales // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
