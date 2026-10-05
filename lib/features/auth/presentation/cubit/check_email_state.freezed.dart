// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_email_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckEmailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckEmailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckEmailState()';
}


}

/// @nodoc
class $CheckEmailStateCopyWith<$Res>  {
$CheckEmailStateCopyWith(CheckEmailState _, $Res Function(CheckEmailState) __);
}


/// Adds pattern-matching-related methods to [CheckEmailState].
extension CheckEmailStatePatterns on CheckEmailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CheckEmailCoolingDown value)?  coolingDown,TResult Function( CheckEmailReady value)?  ready,TResult Function( CheckEmailResending value)?  resending,TResult Function( CheckEmailResent value)?  resent,TResult Function( CheckEmailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CheckEmailCoolingDown() when coolingDown != null:
return coolingDown(_that);case CheckEmailReady() when ready != null:
return ready(_that);case CheckEmailResending() when resending != null:
return resending(_that);case CheckEmailResent() when resent != null:
return resent(_that);case CheckEmailFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CheckEmailCoolingDown value)  coolingDown,required TResult Function( CheckEmailReady value)  ready,required TResult Function( CheckEmailResending value)  resending,required TResult Function( CheckEmailResent value)  resent,required TResult Function( CheckEmailFailure value)  failure,}){
final _that = this;
switch (_that) {
case CheckEmailCoolingDown():
return coolingDown(_that);case CheckEmailReady():
return ready(_that);case CheckEmailResending():
return resending(_that);case CheckEmailResent():
return resent(_that);case CheckEmailFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CheckEmailCoolingDown value)?  coolingDown,TResult? Function( CheckEmailReady value)?  ready,TResult? Function( CheckEmailResending value)?  resending,TResult? Function( CheckEmailResent value)?  resent,TResult? Function( CheckEmailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case CheckEmailCoolingDown() when coolingDown != null:
return coolingDown(_that);case CheckEmailReady() when ready != null:
return ready(_that);case CheckEmailResending() when resending != null:
return resending(_that);case CheckEmailResent() when resent != null:
return resent(_that);case CheckEmailFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int secondsLeft)?  coolingDown,TResult Function()?  ready,TResult Function()?  resending,TResult Function()?  resent,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CheckEmailCoolingDown() when coolingDown != null:
return coolingDown(_that.secondsLeft);case CheckEmailReady() when ready != null:
return ready();case CheckEmailResending() when resending != null:
return resending();case CheckEmailResent() when resent != null:
return resent();case CheckEmailFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int secondsLeft)  coolingDown,required TResult Function()  ready,required TResult Function()  resending,required TResult Function()  resent,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case CheckEmailCoolingDown():
return coolingDown(_that.secondsLeft);case CheckEmailReady():
return ready();case CheckEmailResending():
return resending();case CheckEmailResent():
return resent();case CheckEmailFailure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int secondsLeft)?  coolingDown,TResult? Function()?  ready,TResult? Function()?  resending,TResult? Function()?  resent,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case CheckEmailCoolingDown() when coolingDown != null:
return coolingDown(_that.secondsLeft);case CheckEmailReady() when ready != null:
return ready();case CheckEmailResending() when resending != null:
return resending();case CheckEmailResent() when resent != null:
return resent();case CheckEmailFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CheckEmailCoolingDown implements CheckEmailState {
  const CheckEmailCoolingDown(this.secondsLeft);
  

 final  int secondsLeft;

/// Create a copy of CheckEmailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckEmailCoolingDownCopyWith<CheckEmailCoolingDown> get copyWith => _$CheckEmailCoolingDownCopyWithImpl<CheckEmailCoolingDown>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckEmailCoolingDown&&(identical(other.secondsLeft, secondsLeft) || other.secondsLeft == secondsLeft));
}


@override
int get hashCode {
    return Object.hash(runtimeType,secondsLeft);
}

@override
String toString() {
    return 'CheckEmailState.coolingDown(secondsLeft: $secondsLeft)';
}


}

/// @nodoc
abstract mixin class $CheckEmailCoolingDownCopyWith<$Res> implements $CheckEmailStateCopyWith<$Res> {
  factory $CheckEmailCoolingDownCopyWith(CheckEmailCoolingDown value, $Res Function(CheckEmailCoolingDown) _then) = _$CheckEmailCoolingDownCopyWithImpl;
@useResult
$Res call({
 int secondsLeft
});




}
/// @nodoc
class _$CheckEmailCoolingDownCopyWithImpl<$Res>
    implements $CheckEmailCoolingDownCopyWith<$Res> {
  _$CheckEmailCoolingDownCopyWithImpl(this._self, this._then);

  final CheckEmailCoolingDown _self;
  final $Res Function(CheckEmailCoolingDown) _then;

/// Create a copy of CheckEmailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? secondsLeft = null,}) {
  return _then(CheckEmailCoolingDown(
null == secondsLeft ? _self.secondsLeft : secondsLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class CheckEmailReady implements CheckEmailState {
  const CheckEmailReady();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckEmailReady);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckEmailState.ready()';
}


}




/// @nodoc


class CheckEmailResending implements CheckEmailState {
  const CheckEmailResending();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckEmailResending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckEmailState.resending()';
}


}




/// @nodoc


class CheckEmailResent implements CheckEmailState {
  const CheckEmailResent();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckEmailResent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CheckEmailState.resent()';
}


}




/// @nodoc


class CheckEmailFailure implements CheckEmailState {
  const CheckEmailFailure(this.message);
  

 final  String message;

/// Create a copy of CheckEmailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckEmailFailureCopyWith<CheckEmailFailure> get copyWith => _$CheckEmailFailureCopyWithImpl<CheckEmailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckEmailFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CheckEmailState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $CheckEmailFailureCopyWith<$Res> implements $CheckEmailStateCopyWith<$Res> {
  factory $CheckEmailFailureCopyWith(CheckEmailFailure value, $Res Function(CheckEmailFailure) _then) = _$CheckEmailFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CheckEmailFailureCopyWithImpl<$Res>
    implements $CheckEmailFailureCopyWith<$Res> {
  _$CheckEmailFailureCopyWithImpl(this._self, this._then);

  final CheckEmailFailure _self;
  final $Res Function(CheckEmailFailure) _then;

/// Create a copy of CheckEmailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CheckEmailFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
