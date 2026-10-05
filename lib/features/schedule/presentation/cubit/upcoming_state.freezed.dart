// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upcoming_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpcomingState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UpcomingState()';
}


}

/// @nodoc
class $UpcomingStateCopyWith<$Res>  {
$UpcomingStateCopyWith(UpcomingState _, $Res Function(UpcomingState) __);
}


/// Adds pattern-matching-related methods to [UpcomingState].
extension UpcomingStatePatterns on UpcomingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UpcomingInitial value)?  initial,TResult Function( UpcomingLoading value)?  loading,TResult Function( UpcomingLoaded value)?  loaded,TResult Function( UpcomingError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UpcomingInitial() when initial != null:
return initial(_that);case UpcomingLoading() when loading != null:
return loading(_that);case UpcomingLoaded() when loaded != null:
return loaded(_that);case UpcomingError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UpcomingInitial value)  initial,required TResult Function( UpcomingLoading value)  loading,required TResult Function( UpcomingLoaded value)  loaded,required TResult Function( UpcomingError value)  error,}){
final _that = this;
switch (_that) {
case UpcomingInitial():
return initial(_that);case UpcomingLoading():
return loading(_that);case UpcomingLoaded():
return loaded(_that);case UpcomingError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UpcomingInitial value)?  initial,TResult? Function( UpcomingLoading value)?  loading,TResult? Function( UpcomingLoaded value)?  loaded,TResult? Function( UpcomingError value)?  error,}){
final _that = this;
switch (_that) {
case UpcomingInitial() when initial != null:
return initial(_that);case UpcomingLoading() when loading != null:
return loading(_that);case UpcomingLoaded() when loaded != null:
return loaded(_that);case UpcomingError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<MonthGroup> groups,  bool hasReachedMax,  bool isLoadingMore,  int page)?  loaded,TResult Function( String message,  List<MonthGroup> groups)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UpcomingInitial() when initial != null:
return initial();case UpcomingLoading() when loading != null:
return loading();case UpcomingLoaded() when loaded != null:
return loaded(_that.groups,_that.hasReachedMax,_that.isLoadingMore,_that.page);case UpcomingError() when error != null:
return error(_that.message,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<MonthGroup> groups,  bool hasReachedMax,  bool isLoadingMore,  int page)  loaded,required TResult Function( String message,  List<MonthGroup> groups)  error,}) {final _that = this;
switch (_that) {
case UpcomingInitial():
return initial();case UpcomingLoading():
return loading();case UpcomingLoaded():
return loaded(_that.groups,_that.hasReachedMax,_that.isLoadingMore,_that.page);case UpcomingError():
return error(_that.message,_that.groups);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<MonthGroup> groups,  bool hasReachedMax,  bool isLoadingMore,  int page)?  loaded,TResult? Function( String message,  List<MonthGroup> groups)?  error,}) {final _that = this;
switch (_that) {
case UpcomingInitial() when initial != null:
return initial();case UpcomingLoading() when loading != null:
return loading();case UpcomingLoaded() when loaded != null:
return loaded(_that.groups,_that.hasReachedMax,_that.isLoadingMore,_that.page);case UpcomingError() when error != null:
return error(_that.message,_that.groups);case _:
  return null;

}
}

}

/// @nodoc


class UpcomingInitial extends UpcomingState {
  const UpcomingInitial(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UpcomingState.initial()';
}


}




/// @nodoc


class UpcomingLoading extends UpcomingState {
  const UpcomingLoading(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'UpcomingState.loading()';
}


}




/// @nodoc


class UpcomingLoaded extends UpcomingState {
  const UpcomingLoaded({required  List<MonthGroup> groups, this.hasReachedMax = false, this.isLoadingMore = false, this.page = 1}): _groups = groups,super._();
  

 final  List<MonthGroup> _groups;
 List<MonthGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

@JsonKey() final  bool hasReachedMax;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  int page;

/// Create a copy of UpcomingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpcomingLoadedCopyWith<UpcomingLoaded> get copyWith => _$UpcomingLoadedCopyWithImpl<UpcomingLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingLoaded&&const DeepCollectionEquality().equals(other.groups, _groups)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups),hasReachedMax,isLoadingMore,page);
}

@override
String toString() {
    return 'UpcomingState.loaded(groups: $groups, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore, page: $page)';
}


}

/// @nodoc
abstract mixin class $UpcomingLoadedCopyWith<$Res> implements $UpcomingStateCopyWith<$Res> {
  factory $UpcomingLoadedCopyWith(UpcomingLoaded value, $Res Function(UpcomingLoaded) _then) = _$UpcomingLoadedCopyWithImpl;
@useResult
$Res call({
 List<MonthGroup> groups, bool hasReachedMax, bool isLoadingMore, int page
});




}
/// @nodoc
class _$UpcomingLoadedCopyWithImpl<$Res>
    implements $UpcomingLoadedCopyWith<$Res> {
  _$UpcomingLoadedCopyWithImpl(this._self, this._then);

  final UpcomingLoaded _self;
  final $Res Function(UpcomingLoaded) _then;

/// Create a copy of UpcomingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? hasReachedMax = null,Object? isLoadingMore = null,Object? page = null,}) {
  return _then(UpcomingLoaded(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<MonthGroup>,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class UpcomingError extends UpcomingState {
  const UpcomingError({required this.message,  List<MonthGroup> groups = const []}): _groups = groups,super._();
  

 final  String message;
 final  List<MonthGroup> _groups;
@JsonKey() List<MonthGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of UpcomingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpcomingErrorCopyWith<UpcomingError> get copyWith => _$UpcomingErrorCopyWithImpl<UpcomingError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.groups, _groups));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_groups));
}

@override
String toString() {
    return 'UpcomingState.error(message: $message, groups: $groups)';
}


}

/// @nodoc
abstract mixin class $UpcomingErrorCopyWith<$Res> implements $UpcomingStateCopyWith<$Res> {
  factory $UpcomingErrorCopyWith(UpcomingError value, $Res Function(UpcomingError) _then) = _$UpcomingErrorCopyWithImpl;
@useResult
$Res call({
 String message, List<MonthGroup> groups
});




}
/// @nodoc
class _$UpcomingErrorCopyWithImpl<$Res>
    implements $UpcomingErrorCopyWith<$Res> {
  _$UpcomingErrorCopyWithImpl(this._self, this._then);

  final UpcomingError _self;
  final $Res Function(UpcomingError) _then;

/// Create a copy of UpcomingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? groups = null,}) {
  return _then(UpcomingError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<MonthGroup>,
  ));
}


}

// dart format on
