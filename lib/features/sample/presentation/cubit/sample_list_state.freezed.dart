// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sample_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SampleListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SampleListState()';
}


}

/// @nodoc
class $SampleListStateCopyWith<$Res>  {
$SampleListStateCopyWith(SampleListState _, $Res Function(SampleListState) __);
}


/// Adds pattern-matching-related methods to [SampleListState].
extension SampleListStatePatterns on SampleListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SampleListInitial value)?  initial,TResult Function( SampleListLoading value)?  loading,TResult Function( SampleListLoaded value)?  loaded,TResult Function( SampleListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SampleListInitial() when initial != null:
return initial(_that);case SampleListLoading() when loading != null:
return loading(_that);case SampleListLoaded() when loaded != null:
return loaded(_that);case SampleListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SampleListInitial value)  initial,required TResult Function( SampleListLoading value)  loading,required TResult Function( SampleListLoaded value)  loaded,required TResult Function( SampleListError value)  error,}){
final _that = this;
switch (_that) {
case SampleListInitial():
return initial(_that);case SampleListLoading():
return loading(_that);case SampleListLoaded():
return loaded(_that);case SampleListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SampleListInitial value)?  initial,TResult? Function( SampleListLoading value)?  loading,TResult? Function( SampleListLoaded value)?  loaded,TResult? Function( SampleListError value)?  error,}){
final _that = this;
switch (_that) {
case SampleListInitial() when initial != null:
return initial(_that);case SampleListLoading() when loading != null:
return loading(_that);case SampleListLoaded() when loaded != null:
return loaded(_that);case SampleListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<SampleItem> data,  bool hasReachedMax,  bool isLoadingMore,  int page,  String? search)?  loaded,TResult Function( String message,  List<SampleItem> data)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SampleListInitial() when initial != null:
return initial();case SampleListLoading() when loading != null:
return loading();case SampleListLoaded() when loaded != null:
return loaded(_that.data,_that.hasReachedMax,_that.isLoadingMore,_that.page,_that.search);case SampleListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<SampleItem> data,  bool hasReachedMax,  bool isLoadingMore,  int page,  String? search)  loaded,required TResult Function( String message,  List<SampleItem> data)  error,}) {final _that = this;
switch (_that) {
case SampleListInitial():
return initial();case SampleListLoading():
return loading();case SampleListLoaded():
return loaded(_that.data,_that.hasReachedMax,_that.isLoadingMore,_that.page,_that.search);case SampleListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<SampleItem> data,  bool hasReachedMax,  bool isLoadingMore,  int page,  String? search)?  loaded,TResult? Function( String message,  List<SampleItem> data)?  error,}) {final _that = this;
switch (_that) {
case SampleListInitial() when initial != null:
return initial();case SampleListLoading() when loading != null:
return loading();case SampleListLoaded() when loaded != null:
return loaded(_that.data,_that.hasReachedMax,_that.isLoadingMore,_that.page,_that.search);case SampleListError() when error != null:
return error(_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class SampleListInitial implements SampleListState {
  const SampleListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SampleListState.initial()';
}


}




/// @nodoc


class SampleListLoading implements SampleListState {
  const SampleListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SampleListState.loading()';
}


}




/// @nodoc


class SampleListLoaded implements SampleListState {
  const SampleListLoaded({required  List<SampleItem> data, this.hasReachedMax = false, this.isLoadingMore = false, this.page = 1, this.search}): _data = data;
  

 final  List<SampleItem> _data;
 List<SampleItem> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@JsonKey() final  bool hasReachedMax;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  int page;
 final  String? search;

/// Create a copy of SampleListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SampleListLoadedCopyWith<SampleListLoaded> get copyWith => _$SampleListLoadedCopyWithImpl<SampleListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleListLoaded&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.page, page) || other.page == page)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),hasReachedMax,isLoadingMore,page,search);
}

@override
String toString() {
    return 'SampleListState.loaded(data: $data, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore, page: $page, search: $search)';
}


}

/// @nodoc
abstract mixin class $SampleListLoadedCopyWith<$Res> implements $SampleListStateCopyWith<$Res> {
  factory $SampleListLoadedCopyWith(SampleListLoaded value, $Res Function(SampleListLoaded) _then) = _$SampleListLoadedCopyWithImpl;
@useResult
$Res call({
 List<SampleItem> data, bool hasReachedMax, bool isLoadingMore, int page, String? search
});




}
/// @nodoc
class _$SampleListLoadedCopyWithImpl<$Res>
    implements $SampleListLoadedCopyWith<$Res> {
  _$SampleListLoadedCopyWithImpl(this._self, this._then);

  final SampleListLoaded _self;
  final $Res Function(SampleListLoaded) _then;

/// Create a copy of SampleListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? hasReachedMax = null,Object? isLoadingMore = null,Object? page = null,Object? search = freezed,}) {
  return _then(SampleListLoaded(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<SampleItem>,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SampleListError implements SampleListState {
  const SampleListError({required this.message,  List<SampleItem> data = const []}): _data = data;
  

 final  String message;
 final  List<SampleItem> _data;
@JsonKey() List<SampleItem> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of SampleListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SampleListErrorCopyWith<SampleListError> get copyWith => _$SampleListErrorCopyWithImpl<SampleListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleListError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, _data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_data));
}

@override
String toString() {
    return 'SampleListState.error(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $SampleListErrorCopyWith<$Res> implements $SampleListStateCopyWith<$Res> {
  factory $SampleListErrorCopyWith(SampleListError value, $Res Function(SampleListError) _then) = _$SampleListErrorCopyWithImpl;
@useResult
$Res call({
 String message, List<SampleItem> data
});




}
/// @nodoc
class _$SampleListErrorCopyWithImpl<$Res>
    implements $SampleListErrorCopyWith<$Res> {
  _$SampleListErrorCopyWithImpl(this._self, this._then);

  final SampleListError _self;
  final $Res Function(SampleListError) _then;

/// Create a copy of SampleListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? data = null,}) {
  return _then(SampleListError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<SampleItem>,
  ));
}


}

// dart format on
