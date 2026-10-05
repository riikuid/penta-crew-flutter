// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'EventDetailState()';
}


}

/// @nodoc
class $EventDetailStateCopyWith<$Res>  {
$EventDetailStateCopyWith(EventDetailState _, $Res Function(EventDetailState) __);
}


/// Adds pattern-matching-related methods to [EventDetailState].
extension EventDetailStatePatterns on EventDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EventDetailInitial value)?  initial,TResult Function( EventDetailLoading value)?  loading,TResult Function( EventDetailLoaded value)?  loaded,TResult Function( EventDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EventDetailInitial() when initial != null:
return initial(_that);case EventDetailLoading() when loading != null:
return loading(_that);case EventDetailLoaded() when loaded != null:
return loaded(_that);case EventDetailError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EventDetailInitial value)  initial,required TResult Function( EventDetailLoading value)  loading,required TResult Function( EventDetailLoaded value)  loaded,required TResult Function( EventDetailError value)  error,}){
final _that = this;
switch (_that) {
case EventDetailInitial():
return initial(_that);case EventDetailLoading():
return loading(_that);case EventDetailLoaded():
return loaded(_that);case EventDetailError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EventDetailInitial value)?  initial,TResult? Function( EventDetailLoading value)?  loading,TResult? Function( EventDetailLoaded value)?  loaded,TResult? Function( EventDetailError value)?  error,}){
final _that = this;
switch (_that) {
case EventDetailInitial() when initial != null:
return initial(_that);case EventDetailLoading() when loading != null:
return loading(_that);case EventDetailLoaded() when loaded != null:
return loaded(_that);case EventDetailError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( EventDetail detail,  bool busy,  EventDetailNotice? notice)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EventDetailInitial() when initial != null:
return initial();case EventDetailLoading() when loading != null:
return loading();case EventDetailLoaded() when loaded != null:
return loaded(_that.detail,_that.busy,_that.notice);case EventDetailError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( EventDetail detail,  bool busy,  EventDetailNotice? notice)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case EventDetailInitial():
return initial();case EventDetailLoading():
return loading();case EventDetailLoaded():
return loaded(_that.detail,_that.busy,_that.notice);case EventDetailError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( EventDetail detail,  bool busy,  EventDetailNotice? notice)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case EventDetailInitial() when initial != null:
return initial();case EventDetailLoading() when loading != null:
return loading();case EventDetailLoaded() when loaded != null:
return loaded(_that.detail,_that.busy,_that.notice);case EventDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class EventDetailInitial implements EventDetailState {
  const EventDetailInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'EventDetailState.initial()';
}


}




/// @nodoc


class EventDetailLoading implements EventDetailState {
  const EventDetailLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'EventDetailState.loading()';
}


}




/// @nodoc


class EventDetailLoaded implements EventDetailState {
  const EventDetailLoaded({required this.detail, this.busy = false, this.notice});
  

 final  EventDetail detail;
@JsonKey() final  bool busy;
 final  EventDetailNotice? notice;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailLoadedCopyWith<EventDetailLoaded> get copyWith => _$EventDetailLoadedCopyWithImpl<EventDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetailLoaded&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.notice, notice) || other.notice == notice));
}


@override
int get hashCode {
    return Object.hash(runtimeType,detail,busy,notice);
}

@override
String toString() {
    return 'EventDetailState.loaded(detail: $detail, busy: $busy, notice: $notice)';
}


}

/// @nodoc
abstract mixin class $EventDetailLoadedCopyWith<$Res> implements $EventDetailStateCopyWith<$Res> {
  factory $EventDetailLoadedCopyWith(EventDetailLoaded value, $Res Function(EventDetailLoaded) _then) = _$EventDetailLoadedCopyWithImpl;
@useResult
$Res call({
 EventDetail detail, bool busy, EventDetailNotice? notice
});


$EventDetailCopyWith<$Res> get detail;

}
/// @nodoc
class _$EventDetailLoadedCopyWithImpl<$Res>
    implements $EventDetailLoadedCopyWith<$Res> {
  _$EventDetailLoadedCopyWithImpl(this._self, this._then);

  final EventDetailLoaded _self;
  final $Res Function(EventDetailLoaded) _then;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = null,Object? busy = null,Object? notice = freezed,}) {
  return _then(EventDetailLoaded(
detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as EventDetail,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as EventDetailNotice?,
  ));
}

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventDetailCopyWith<$Res> get detail {
  
  return $EventDetailCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}

/// @nodoc


class EventDetailError implements EventDetailState {
  const EventDetailError({required this.message});
  

 final  String message;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailErrorCopyWith<EventDetailError> get copyWith => _$EventDetailErrorCopyWithImpl<EventDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'EventDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $EventDetailErrorCopyWith<$Res> implements $EventDetailStateCopyWith<$Res> {
  factory $EventDetailErrorCopyWith(EventDetailError value, $Res Function(EventDetailError) _then) = _$EventDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$EventDetailErrorCopyWithImpl<$Res>
    implements $EventDetailErrorCopyWith<$Res> {
  _$EventDetailErrorCopyWithImpl(this._self, this._then);

  final EventDetailError _self;
  final $Res Function(EventDetailError) _then;

/// Create a copy of EventDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(EventDetailError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
