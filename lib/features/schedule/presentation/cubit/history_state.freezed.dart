// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HistoryState()';
}


}

/// @nodoc
class $HistoryStateCopyWith<$Res>  {
$HistoryStateCopyWith(HistoryState _, $Res Function(HistoryState) __);
}


/// Adds pattern-matching-related methods to [HistoryState].
extension HistoryStatePatterns on HistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HistoryInitial value)?  initial,TResult Function( HistoryLoading value)?  loading,TResult Function( HistoryLoaded value)?  loaded,TResult Function( HistoryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial(_that);case HistoryLoading() when loading != null:
return loading(_that);case HistoryLoaded() when loaded != null:
return loaded(_that);case HistoryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HistoryInitial value)  initial,required TResult Function( HistoryLoading value)  loading,required TResult Function( HistoryLoaded value)  loaded,required TResult Function( HistoryError value)  error,}){
final _that = this;
switch (_that) {
case HistoryInitial():
return initial(_that);case HistoryLoading():
return loading(_that);case HistoryLoaded():
return loaded(_that);case HistoryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HistoryInitial value)?  initial,TResult? Function( HistoryLoading value)?  loading,TResult? Function( HistoryLoaded value)?  loaded,TResult? Function( HistoryError value)?  error,}){
final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial(_that);case HistoryLoading() when loading != null:
return loading(_that);case HistoryLoaded() when loaded != null:
return loaded(_that);case HistoryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Application> items,  HistorySummary summary,  bool hasReachedMax,  bool isLoadingMore,  int page)?  loaded,TResult Function( String message,  List<Application> items)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial();case HistoryLoading() when loading != null:
return loading();case HistoryLoaded() when loaded != null:
return loaded(_that.items,_that.summary,_that.hasReachedMax,_that.isLoadingMore,_that.page);case HistoryError() when error != null:
return error(_that.message,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Application> items,  HistorySummary summary,  bool hasReachedMax,  bool isLoadingMore,  int page)  loaded,required TResult Function( String message,  List<Application> items)  error,}) {final _that = this;
switch (_that) {
case HistoryInitial():
return initial();case HistoryLoading():
return loading();case HistoryLoaded():
return loaded(_that.items,_that.summary,_that.hasReachedMax,_that.isLoadingMore,_that.page);case HistoryError():
return error(_that.message,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Application> items,  HistorySummary summary,  bool hasReachedMax,  bool isLoadingMore,  int page)?  loaded,TResult? Function( String message,  List<Application> items)?  error,}) {final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial();case HistoryLoading() when loading != null:
return loading();case HistoryLoaded() when loaded != null:
return loaded(_that.items,_that.summary,_that.hasReachedMax,_that.isLoadingMore,_that.page);case HistoryError() when error != null:
return error(_that.message,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class HistoryInitial implements HistoryState {
  const HistoryInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HistoryState.initial()';
}


}




/// @nodoc


class HistoryLoading implements HistoryState {
  const HistoryLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HistoryState.loading()';
}


}




/// @nodoc


class HistoryLoaded implements HistoryState {
  const HistoryLoaded({required  List<Application> items, required this.summary, this.hasReachedMax = false, this.isLoadingMore = false, this.page = 1}): _items = items;
  

 final  List<Application> _items;
 List<Application> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  HistorySummary summary;
@JsonKey() final  bool hasReachedMax;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  int page;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryLoadedCopyWith<HistoryLoaded> get copyWith => _$HistoryLoadedCopyWithImpl<HistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoaded&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),summary,hasReachedMax,isLoadingMore,page);
}

@override
String toString() {
    return 'HistoryState.loaded(items: $items, summary: $summary, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore, page: $page)';
}


}

/// @nodoc
abstract mixin class $HistoryLoadedCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory $HistoryLoadedCopyWith(HistoryLoaded value, $Res Function(HistoryLoaded) _then) = _$HistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<Application> items, HistorySummary summary, bool hasReachedMax, bool isLoadingMore, int page
});


$HistorySummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$HistoryLoadedCopyWithImpl<$Res>
    implements $HistoryLoadedCopyWith<$Res> {
  _$HistoryLoadedCopyWithImpl(this._self, this._then);

  final HistoryLoaded _self;
  final $Res Function(HistoryLoaded) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? summary = null,Object? hasReachedMax = null,Object? isLoadingMore = null,Object? page = null,}) {
  return _then(HistoryLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Application>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as HistorySummary,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HistorySummaryCopyWith<$Res> get summary {
  
  return $HistorySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc


class HistoryError implements HistoryState {
  const HistoryError({required this.message,  List<Application> items = const []}): _items = items;
  

 final  String message;
 final  List<Application> _items;
@JsonKey() List<Application> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryErrorCopyWith<HistoryError> get copyWith => _$HistoryErrorCopyWithImpl<HistoryError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'HistoryState.error(message: $message, items: $items)';
}


}

/// @nodoc
abstract mixin class $HistoryErrorCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory $HistoryErrorCopyWith(HistoryError value, $Res Function(HistoryError) _then) = _$HistoryErrorCopyWithImpl;
@useResult
$Res call({
 String message, List<Application> items
});




}
/// @nodoc
class _$HistoryErrorCopyWithImpl<$Res>
    implements $HistoryErrorCopyWith<$Res> {
  _$HistoryErrorCopyWithImpl(this._self, this._then);

  final HistoryError _self;
  final $Res Function(HistoryError) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? items = null,}) {
  return _then(HistoryError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Application>,
  ));
}


}

// dart format on
