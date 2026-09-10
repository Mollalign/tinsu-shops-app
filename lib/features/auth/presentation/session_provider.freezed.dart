// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState()';
}


}

/// @nodoc
class $SessionStateCopyWith<$Res>  {
$SessionStateCopyWith(SessionState _, $Res Function(SessionState) __);
}


/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Authenticated value)?  authenticated,TResult Function( _Unauthenticated value)?  unauthenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Authenticated value)  authenticated,required TResult Function( _Unauthenticated value)  unauthenticated,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Authenticated():
return authenticated(_that);case _Unauthenticated():
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Authenticated value)?  authenticated,TResult? Function( _Unauthenticated value)?  unauthenticated,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserModel user,  String? currentShopId)?  authenticated,TResult Function( String? rememberedPhone,  String? rememberedName,  bool isSessionExpired,  UserRole? lastRole)?  unauthenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Authenticated() when authenticated != null:
return authenticated(_that.user,_that.currentShopId);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.rememberedPhone,_that.rememberedName,_that.isSessionExpired,_that.lastRole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserModel user,  String? currentShopId)  authenticated,required TResult Function( String? rememberedPhone,  String? rememberedName,  bool isSessionExpired,  UserRole? lastRole)  unauthenticated,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Authenticated():
return authenticated(_that.user,_that.currentShopId);case _Unauthenticated():
return unauthenticated(_that.rememberedPhone,_that.rememberedName,_that.isSessionExpired,_that.lastRole);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserModel user,  String? currentShopId)?  authenticated,TResult? Function( String? rememberedPhone,  String? rememberedName,  bool isSessionExpired,  UserRole? lastRole)?  unauthenticated,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Authenticated() when authenticated != null:
return authenticated(_that.user,_that.currentShopId);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.rememberedPhone,_that.rememberedName,_that.isSessionExpired,_that.lastRole);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements SessionState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState.initial()';
}


}




/// @nodoc


class _Loading implements SessionState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState.loading()';
}


}




/// @nodoc


class _Authenticated implements SessionState {
  const _Authenticated({required this.user, this.currentShopId});
  

 final  UserModel user;
 final  String? currentShopId;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedCopyWith<_Authenticated> get copyWith => __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated&&(identical(other.user, user) || other.user == user)&&(identical(other.currentShopId, currentShopId) || other.currentShopId == currentShopId));
}


@override
int get hashCode => Object.hash(runtimeType,user,currentShopId);

@override
String toString() {
  return 'SessionState.authenticated(user: $user, currentShopId: $currentShopId)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(_Authenticated value, $Res Function(_Authenticated) _then) = __$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 UserModel user, String? currentShopId
});


$UserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(this._self, this._then);

  final _Authenticated _self;
  final $Res Function(_Authenticated) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? currentShopId = freezed,}) {
  return _then(_Authenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,currentShopId: freezed == currentShopId ? _self.currentShopId : currentShopId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class _Unauthenticated implements SessionState {
  const _Unauthenticated({this.rememberedPhone, this.rememberedName, this.isSessionExpired = false, this.lastRole});
  

 final  String? rememberedPhone;
 final  String? rememberedName;
@JsonKey() final  bool isSessionExpired;
 final  UserRole? lastRole;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnauthenticatedCopyWith<_Unauthenticated> get copyWith => __$UnauthenticatedCopyWithImpl<_Unauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthenticated&&(identical(other.rememberedPhone, rememberedPhone) || other.rememberedPhone == rememberedPhone)&&(identical(other.rememberedName, rememberedName) || other.rememberedName == rememberedName)&&(identical(other.isSessionExpired, isSessionExpired) || other.isSessionExpired == isSessionExpired)&&(identical(other.lastRole, lastRole) || other.lastRole == lastRole));
}


@override
int get hashCode => Object.hash(runtimeType,rememberedPhone,rememberedName,isSessionExpired,lastRole);

@override
String toString() {
  return 'SessionState.unauthenticated(rememberedPhone: $rememberedPhone, rememberedName: $rememberedName, isSessionExpired: $isSessionExpired, lastRole: $lastRole)';
}


}

/// @nodoc
abstract mixin class _$UnauthenticatedCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory _$UnauthenticatedCopyWith(_Unauthenticated value, $Res Function(_Unauthenticated) _then) = __$UnauthenticatedCopyWithImpl;
@useResult
$Res call({
 String? rememberedPhone, String? rememberedName, bool isSessionExpired, UserRole? lastRole
});




}
/// @nodoc
class __$UnauthenticatedCopyWithImpl<$Res>
    implements _$UnauthenticatedCopyWith<$Res> {
  __$UnauthenticatedCopyWithImpl(this._self, this._then);

  final _Unauthenticated _self;
  final $Res Function(_Unauthenticated) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rememberedPhone = freezed,Object? rememberedName = freezed,Object? isSessionExpired = null,Object? lastRole = freezed,}) {
  return _then(_Unauthenticated(
rememberedPhone: freezed == rememberedPhone ? _self.rememberedPhone : rememberedPhone // ignore: cast_nullable_to_non_nullable
as String?,rememberedName: freezed == rememberedName ? _self.rememberedName : rememberedName // ignore: cast_nullable_to_non_nullable
as String?,isSessionExpired: null == isSessionExpired ? _self.isSessionExpired : isSessionExpired // ignore: cast_nullable_to_non_nullable
as bool,lastRole: freezed == lastRole ? _self.lastRole : lastRole // ignore: cast_nullable_to_non_nullable
as UserRole?,
  ));
}


}

// dart format on
