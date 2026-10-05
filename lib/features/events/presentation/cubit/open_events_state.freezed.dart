// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_events_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpenEventsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenEventsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OpenEventsState()';
}


}

/// @nodoc
class $OpenEventsStateCopyWith<$Res>  {
$OpenEventsStateCopyWith(OpenEventsState _, $Res Function(OpenEventsState) __);
}


/// Adds pattern-matching-related methods to [OpenEventsState].
extension OpenEventsStatePatterns on OpenEventsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OpenEventsInitial value)?  initial,TResult Function( OpenEventsLoading value)?  loading,TResult Function( OpenEventsLoaded value)?  loaded,TResult Function( OpenEventsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OpenEventsInitial() when initial != null:
return initial(_that);case OpenEventsLoading() when loading != null:
return loading(_that);case OpenEventsLoaded() when loaded != null:
return loaded(_that);case OpenEventsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OpenEventsInitial value)  initial,required TResult Function( OpenEventsLoading value)  loading,required TResult Function( OpenEventsLoaded value)  loaded,required TResult Function( OpenEventsError value)  error,}){
final _that = this;
switch (_that) {
case OpenEventsInitial():
return initial(_that);case OpenEventsLoading():
return loading(_that);case OpenEventsLoaded():
return loaded(_that);case OpenEventsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OpenEventsInitial value)?  initial,TResult? Function( OpenEventsLoading value)?  loading,TResult? Function( OpenEventsLoaded value)?  loaded,TResult? Function( OpenEventsError value)?  error,}){
final _that = this;
switch (_that) {
case OpenEventsInitial() when initial != null:
return initial(_that);case OpenEventsLoading() when loading != null:
return loading(_that);case OpenEventsLoaded() when loaded != null:
return loaded(_that);case OpenEventsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Event> data,  int total,  bool hasReachedMax,  bool isLoadingMore,  int page,  String? search)?  loaded,TResult Function( String message,  List<Event> data)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OpenEventsInitial() when initial != null:
return initial();case OpenEventsLoading() when loading != null:
return loading();case OpenEventsLoaded() when loaded != null:
return loaded(_that.data,_that.total,_that.hasReachedMax,_that.isLoadingMore,_that.page,_that.search);case OpenEventsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Event> data,  int total,  bool hasReachedMax,  bool isLoadingMore,  int page,  String? search)  loaded,required TResult Function( String message,  List<Event> data)  error,}) {final _that = this;
switch (_that) {
case OpenEventsInitial():
return initial();case OpenEventsLoading():
return loading();case OpenEventsLoaded():
return loaded(_that.data,_that.total,_that.hasReachedMax,_that.isLoadingMore,_that.page,_that.search);case OpenEventsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Event> data,  int total,  bool hasReachedMax,  bool isLoadingMore,  int page,  String? search)?  loaded,TResult? Function( String message,  List<Event> data)?  error,}) {final _that = this;
switch (_that) {
case OpenEventsInitial() when initial != null:
return initial();case OpenEventsLoading() when loading != null:
return loading();case OpenEventsLoaded() when loaded != null:
return loaded(_that.data,_that.total,_that.hasReachedMax,_that.isLoadingMore,_that.page,_that.search);case OpenEventsError() when error != null:
return error(_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class OpenEventsInitial implements OpenEventsState {
  const OpenEventsInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenEventsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OpenEventsState.initial()';
}


}




/// @nodoc


class OpenEventsLoading implements OpenEventsState {
  const OpenEventsLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenEventsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OpenEventsState.loading()';
}


}




/// @nodoc


class OpenEventsLoaded implements OpenEventsState {
  const OpenEventsLoaded({required  List<Event> data, required this.total, this.hasReachedMax = false, this.isLoadingMore = false, this.page = 1, this.search}): _data = data;
  

 final  List<Event> _data;
 List<Event> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

 final  int total;
@JsonKey() final  bool hasReachedMax;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  int page;
 final  String? search;

/// Create a copy of OpenEventsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenEventsLoadedCopyWith<OpenEventsLoaded> get copyWith => _$OpenEventsLoadedCopyWithImpl<OpenEventsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenEventsLoaded&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.page, page) || other.page == page)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),total,hasReachedMax,isLoadingMore,page,search);
}

@override
String toString() {
    return 'OpenEventsState.loaded(data: $data, total: $total, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore, page: $page, search: $search)';
}


}

/// @nodoc
abstract mixin class $OpenEventsLoadedCopyWith<$Res> implements $OpenEventsStateCopyWith<$Res> {
  factory $OpenEventsLoadedCopyWith(OpenEventsLoaded value, $Res Function(OpenEventsLoaded) _then) = _$OpenEventsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Event> data, int total, bool hasReachedMax, bool isLoadingMore, int page, String? search
});




}
/// @nodoc
class _$OpenEventsLoadedCopyWithImpl<$Res>
    implements $OpenEventsLoadedCopyWith<$Res> {
  _$OpenEventsLoadedCopyWithImpl(this._self, this._then);

  final OpenEventsLoaded _self;
  final $Res Function(OpenEventsLoaded) _then;

/// Create a copy of OpenEventsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? total = null,Object? hasReachedMax = null,Object? isLoadingMore = null,Object? page = null,Object? search = freezed,}) {
  return _then(OpenEventsLoaded(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Event>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class OpenEventsError implements OpenEventsState {
  const OpenEventsError({required this.message,  List<Event> data = const []}): _data = data;
  

 final  String message;
 final  List<Event> _data;
@JsonKey() List<Event> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of OpenEventsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenEventsErrorCopyWith<OpenEventsError> get copyWith => _$OpenEventsErrorCopyWithImpl<OpenEventsError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenEventsError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, _data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_data));
}

@override
String toString() {
    return 'OpenEventsState.error(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $OpenEventsErrorCopyWith<$Res> implements $OpenEventsStateCopyWith<$Res> {
  factory $OpenEventsErrorCopyWith(OpenEventsError value, $Res Function(OpenEventsError) _then) = _$OpenEventsErrorCopyWithImpl;
@useResult
$Res call({
 String message, List<Event> data
});




}
/// @nodoc
class _$OpenEventsErrorCopyWithImpl<$Res>
    implements $OpenEventsErrorCopyWith<$Res> {
  _$OpenEventsErrorCopyWithImpl(this._self, this._then);

  final OpenEventsError _self;
  final $Res Function(OpenEventsError) _then;

/// Create a copy of OpenEventsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? data = null,}) {
  return _then(OpenEventsError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Event>,
  ));
}


}

// dart format on
