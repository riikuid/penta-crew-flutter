// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracked_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackedState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TrackedState()';
}


}

/// @nodoc
class $TrackedStateCopyWith<$Res>  {
$TrackedStateCopyWith(TrackedState _, $Res Function(TrackedState) __);
}


/// Adds pattern-matching-related methods to [TrackedState].
extension TrackedStatePatterns on TrackedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TrackedInitial value)?  initial,TResult Function( TrackedLoading value)?  loading,TResult Function( TrackedLoaded value)?  loaded,TResult Function( TrackedError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TrackedInitial() when initial != null:
return initial(_that);case TrackedLoading() when loading != null:
return loading(_that);case TrackedLoaded() when loaded != null:
return loaded(_that);case TrackedError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TrackedInitial value)  initial,required TResult Function( TrackedLoading value)  loading,required TResult Function( TrackedLoaded value)  loaded,required TResult Function( TrackedError value)  error,}){
final _that = this;
switch (_that) {
case TrackedInitial():
return initial(_that);case TrackedLoading():
return loading(_that);case TrackedLoaded():
return loaded(_that);case TrackedError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TrackedInitial value)?  initial,TResult? Function( TrackedLoading value)?  loading,TResult? Function( TrackedLoaded value)?  loaded,TResult? Function( TrackedError value)?  error,}){
final _that = this;
switch (_that) {
case TrackedInitial() when initial != null:
return initial(_that);case TrackedLoading() when loading != null:
return loading(_that);case TrackedLoaded() when loaded != null:
return loaded(_that);case TrackedError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Application> data,  int total,  bool hasReachedMax,  bool isLoadingMore,  int page)?  loaded,TResult Function( String message,  List<Application> data)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TrackedInitial() when initial != null:
return initial();case TrackedLoading() when loading != null:
return loading();case TrackedLoaded() when loaded != null:
return loaded(_that.data,_that.total,_that.hasReachedMax,_that.isLoadingMore,_that.page);case TrackedError() when error != null:
return error(_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Application> data,  int total,  bool hasReachedMax,  bool isLoadingMore,  int page)  loaded,required TResult Function( String message,  List<Application> data)  error,}) {final _that = this;
switch (_that) {
case TrackedInitial():
return initial();case TrackedLoading():
return loading();case TrackedLoaded():
return loaded(_that.data,_that.total,_that.hasReachedMax,_that.isLoadingMore,_that.page);case TrackedError():
return error(_that.message,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Application> data,  int total,  bool hasReachedMax,  bool isLoadingMore,  int page)?  loaded,TResult? Function( String message,  List<Application> data)?  error,}) {final _that = this;
switch (_that) {
case TrackedInitial() when initial != null:
return initial();case TrackedLoading() when loading != null:
return loading();case TrackedLoaded() when loaded != null:
return loaded(_that.data,_that.total,_that.hasReachedMax,_that.isLoadingMore,_that.page);case TrackedError() when error != null:
return error(_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class TrackedInitial implements TrackedState {
  const TrackedInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackedInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TrackedState.initial()';
}


}




/// @nodoc


class TrackedLoading implements TrackedState {
  const TrackedLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackedLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TrackedState.loading()';
}


}




/// @nodoc


class TrackedLoaded implements TrackedState {
  const TrackedLoaded({required  List<Application> data, required this.total, this.hasReachedMax = false, this.isLoadingMore = false, this.page = 1}): _data = data;
  

 final  List<Application> _data;
 List<Application> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

 final  int total;
@JsonKey() final  bool hasReachedMax;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  int page;

/// Create a copy of TrackedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackedLoadedCopyWith<TrackedLoaded> get copyWith => _$TrackedLoadedCopyWithImpl<TrackedLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackedLoaded&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),total,hasReachedMax,isLoadingMore,page);
}

@override
String toString() {
    return 'TrackedState.loaded(data: $data, total: $total, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore, page: $page)';
}


}

/// @nodoc
abstract mixin class $TrackedLoadedCopyWith<$Res> implements $TrackedStateCopyWith<$Res> {
  factory $TrackedLoadedCopyWith(TrackedLoaded value, $Res Function(TrackedLoaded) _then) = _$TrackedLoadedCopyWithImpl;
@useResult
$Res call({
 List<Application> data, int total, bool hasReachedMax, bool isLoadingMore, int page
});




}
/// @nodoc
class _$TrackedLoadedCopyWithImpl<$Res>
    implements $TrackedLoadedCopyWith<$Res> {
  _$TrackedLoadedCopyWithImpl(this._self, this._then);

  final TrackedLoaded _self;
  final $Res Function(TrackedLoaded) _then;

/// Create a copy of TrackedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? total = null,Object? hasReachedMax = null,Object? isLoadingMore = null,Object? page = null,}) {
  return _then(TrackedLoaded(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Application>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TrackedError implements TrackedState {
  const TrackedError({required this.message,  List<Application> data = const []}): _data = data;
  

 final  String message;
 final  List<Application> _data;
@JsonKey() List<Application> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of TrackedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackedErrorCopyWith<TrackedError> get copyWith => _$TrackedErrorCopyWithImpl<TrackedError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackedError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, _data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_data));
}

@override
String toString() {
    return 'TrackedState.error(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $TrackedErrorCopyWith<$Res> implements $TrackedStateCopyWith<$Res> {
  factory $TrackedErrorCopyWith(TrackedError value, $Res Function(TrackedError) _then) = _$TrackedErrorCopyWithImpl;
@useResult
$Res call({
 String message, List<Application> data
});




}
/// @nodoc
class _$TrackedErrorCopyWithImpl<$Res>
    implements $TrackedErrorCopyWith<$Res> {
  _$TrackedErrorCopyWithImpl(this._self, this._then);

  final TrackedError _self;
  final $Res Function(TrackedError) _then;

/// Create a copy of TrackedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? data = null,}) {
  return _then(TrackedError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Application>,
  ));
}


}

// dart format on
