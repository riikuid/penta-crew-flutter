// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResetPasswordState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResetPasswordState()';
}


}

/// @nodoc
class $ResetPasswordStateCopyWith<$Res>  {
$ResetPasswordStateCopyWith(ResetPasswordState _, $Res Function(ResetPasswordState) __);
}


/// Adds pattern-matching-related methods to [ResetPasswordState].
extension ResetPasswordStatePatterns on ResetPasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResetPasswordIdle value)?  idle,TResult Function( ResetPasswordSubmitting value)?  submitting,TResult Function( ResetPasswordSuccess value)?  success,TResult Function( ResetPasswordExpired value)?  expired,TResult Function( ResetPasswordFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResetPasswordIdle() when idle != null:
return idle(_that);case ResetPasswordSubmitting() when submitting != null:
return submitting(_that);case ResetPasswordSuccess() when success != null:
return success(_that);case ResetPasswordExpired() when expired != null:
return expired(_that);case ResetPasswordFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResetPasswordIdle value)  idle,required TResult Function( ResetPasswordSubmitting value)  submitting,required TResult Function( ResetPasswordSuccess value)  success,required TResult Function( ResetPasswordExpired value)  expired,required TResult Function( ResetPasswordFailure value)  failure,}){
final _that = this;
switch (_that) {
case ResetPasswordIdle():
return idle(_that);case ResetPasswordSubmitting():
return submitting(_that);case ResetPasswordSuccess():
return success(_that);case ResetPasswordExpired():
return expired(_that);case ResetPasswordFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResetPasswordIdle value)?  idle,TResult? Function( ResetPasswordSubmitting value)?  submitting,TResult? Function( ResetPasswordSuccess value)?  success,TResult? Function( ResetPasswordExpired value)?  expired,TResult? Function( ResetPasswordFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ResetPasswordIdle() when idle != null:
return idle(_that);case ResetPasswordSubmitting() when submitting != null:
return submitting(_that);case ResetPasswordSuccess() when success != null:
return success(_that);case ResetPasswordExpired() when expired != null:
return expired(_that);case ResetPasswordFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function()?  success,TResult Function()?  expired,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResetPasswordIdle() when idle != null:
return idle();case ResetPasswordSubmitting() when submitting != null:
return submitting();case ResetPasswordSuccess() when success != null:
return success();case ResetPasswordExpired() when expired != null:
return expired();case ResetPasswordFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function()  success,required TResult Function()  expired,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case ResetPasswordIdle():
return idle();case ResetPasswordSubmitting():
return submitting();case ResetPasswordSuccess():
return success();case ResetPasswordExpired():
return expired();case ResetPasswordFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function()?  success,TResult? Function()?  expired,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case ResetPasswordIdle() when idle != null:
return idle();case ResetPasswordSubmitting() when submitting != null:
return submitting();case ResetPasswordSuccess() when success != null:
return success();case ResetPasswordExpired() when expired != null:
return expired();case ResetPasswordFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ResetPasswordIdle implements ResetPasswordState {
  const ResetPasswordIdle();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResetPasswordState.idle()';
}


}




/// @nodoc


class ResetPasswordSubmitting implements ResetPasswordState {
  const ResetPasswordSubmitting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResetPasswordState.submitting()';
}


}




/// @nodoc


class ResetPasswordSuccess implements ResetPasswordState {
  const ResetPasswordSuccess();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResetPasswordState.success()';
}


}




/// @nodoc


class ResetPasswordExpired implements ResetPasswordState {
  const ResetPasswordExpired();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResetPasswordState.expired()';
}


}




/// @nodoc


class ResetPasswordFailure implements ResetPasswordState {
  const ResetPasswordFailure(this.message);
  

 final  String message;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordFailureCopyWith<ResetPasswordFailure> get copyWith => _$ResetPasswordFailureCopyWithImpl<ResetPasswordFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ResetPasswordState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $ResetPasswordFailureCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory $ResetPasswordFailureCopyWith(ResetPasswordFailure value, $Res Function(ResetPasswordFailure) _then) = _$ResetPasswordFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ResetPasswordFailureCopyWithImpl<$Res>
    implements $ResetPasswordFailureCopyWith<$Res> {
  _$ResetPasswordFailureCopyWithImpl(this._self, this._then);

  final ResetPasswordFailure _self;
  final $Res Function(ResetPasswordFailure) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ResetPasswordFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
