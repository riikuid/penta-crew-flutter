// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sample_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SampleDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SampleDetailState()';
}


}

/// @nodoc
class $SampleDetailStateCopyWith<$Res>  {
$SampleDetailStateCopyWith(SampleDetailState _, $Res Function(SampleDetailState) __);
}


/// Adds pattern-matching-related methods to [SampleDetailState].
extension SampleDetailStatePatterns on SampleDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SampleDetailInitial value)?  initial,TResult Function( SampleDetailLoading value)?  loading,TResult Function( SampleDetailLoaded value)?  loaded,TResult Function( SampleDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SampleDetailInitial() when initial != null:
return initial(_that);case SampleDetailLoading() when loading != null:
return loading(_that);case SampleDetailLoaded() when loaded != null:
return loaded(_that);case SampleDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SampleDetailInitial value)  initial,required TResult Function( SampleDetailLoading value)  loading,required TResult Function( SampleDetailLoaded value)  loaded,required TResult Function( SampleDetailError value)  error,}){
final _that = this;
switch (_that) {
case SampleDetailInitial():
return initial(_that);case SampleDetailLoading():
return loading(_that);case SampleDetailLoaded():
return loaded(_that);case SampleDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SampleDetailInitial value)?  initial,TResult? Function( SampleDetailLoading value)?  loading,TResult? Function( SampleDetailLoaded value)?  loaded,TResult? Function( SampleDetailError value)?  error,}){
final _that = this;
switch (_that) {
case SampleDetailInitial() when initial != null:
return initial(_that);case SampleDetailLoading() when loading != null:
return loading(_that);case SampleDetailLoaded() when loaded != null:
return loaded(_that);case SampleDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( SampleItem item)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SampleDetailInitial() when initial != null:
return initial();case SampleDetailLoading() when loading != null:
return loading();case SampleDetailLoaded() when loaded != null:
return loaded(_that.item);case SampleDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( SampleItem item)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SampleDetailInitial():
return initial();case SampleDetailLoading():
return loading();case SampleDetailLoaded():
return loaded(_that.item);case SampleDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( SampleItem item)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SampleDetailInitial() when initial != null:
return initial();case SampleDetailLoading() when loading != null:
return loading();case SampleDetailLoaded() when loaded != null:
return loaded(_that.item);case SampleDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SampleDetailInitial implements SampleDetailState {
  const SampleDetailInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SampleDetailState.initial()';
}


}




/// @nodoc


class SampleDetailLoading implements SampleDetailState {
  const SampleDetailLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SampleDetailState.loading()';
}


}




/// @nodoc


class SampleDetailLoaded implements SampleDetailState {
  const SampleDetailLoaded(this.item);
  

 final  SampleItem item;

/// Create a copy of SampleDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SampleDetailLoadedCopyWith<SampleDetailLoaded> get copyWith => _$SampleDetailLoadedCopyWithImpl<SampleDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleDetailLoaded&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode {
    return Object.hash(runtimeType,item);
}

@override
String toString() {
    return 'SampleDetailState.loaded(item: $item)';
}


}

/// @nodoc
abstract mixin class $SampleDetailLoadedCopyWith<$Res> implements $SampleDetailStateCopyWith<$Res> {
  factory $SampleDetailLoadedCopyWith(SampleDetailLoaded value, $Res Function(SampleDetailLoaded) _then) = _$SampleDetailLoadedCopyWithImpl;
@useResult
$Res call({
 SampleItem item
});


$SampleItemCopyWith<$Res> get item;

}
/// @nodoc
class _$SampleDetailLoadedCopyWithImpl<$Res>
    implements $SampleDetailLoadedCopyWith<$Res> {
  _$SampleDetailLoadedCopyWithImpl(this._self, this._then);

  final SampleDetailLoaded _self;
  final $Res Function(SampleDetailLoaded) _then;

/// Create a copy of SampleDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(SampleDetailLoaded(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as SampleItem,
  ));
}

/// Create a copy of SampleDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SampleItemCopyWith<$Res> get item {
  
  return $SampleItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc


class SampleDetailError implements SampleDetailState {
  const SampleDetailError(this.message);
  

 final  String message;

/// Create a copy of SampleDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SampleDetailErrorCopyWith<SampleDetailError> get copyWith => _$SampleDetailErrorCopyWithImpl<SampleDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'SampleDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SampleDetailErrorCopyWith<$Res> implements $SampleDetailStateCopyWith<$Res> {
  factory $SampleDetailErrorCopyWith(SampleDetailError value, $Res Function(SampleDetailError) _then) = _$SampleDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SampleDetailErrorCopyWithImpl<$Res>
    implements $SampleDetailErrorCopyWith<$Res> {
  _$SampleDetailErrorCopyWithImpl(this._self, this._then);

  final SampleDetailError _self;
  final $Res Function(SampleDetailError) _then;

/// Create a copy of SampleDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SampleDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
