// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

/// First item of `GET /schedule/upcoming`; `null` when nothing is
/// scheduled (B3).
 Section<Application?> get nextShift;/// `meta.total` of `GET /applications?status=waiting` (D-04).
 Section<int> get waitingCount;/// `meta.summary` of `GET /schedule/history`.
 Section<HistorySummary> get worked;/// First page of open events in the user's branch (carousel).
 Section<List<Event>> get openEvents; String? get refreshError;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.nextShift, _this.nextShift) || other.nextShift == _this.nextShift)&&(identical(other.waitingCount, _this.waitingCount) || other.waitingCount == _this.waitingCount)&&(identical(other.worked, _this.worked) || other.worked == _this.worked)&&(identical(other.openEvents, _this.openEvents) || other.openEvents == _this.openEvents)&&(identical(other.refreshError, _this.refreshError) || other.refreshError == _this.refreshError));
}


@override
int get hashCode {
  final _this = this as HomeState;
  return Object.hash(runtimeType,_this.nextShift,_this.waitingCount,_this.worked,_this.openEvents,_this.refreshError);
}

@override
String toString() {
  final _this = this as HomeState;
  return 'HomeState(nextShift: ${_this.nextShift}, waitingCount: ${_this.waitingCount}, worked: ${_this.worked}, openEvents: ${_this.openEvents}, refreshError: ${_this.refreshError})';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 Section<Application?> nextShift, Section<int> waitingCount, Section<HistorySummary> worked, Section<List<Event>> openEvents, String? refreshError
});


$SectionCopyWith<Application?, $Res> get nextShift;$SectionCopyWith<int, $Res> get waitingCount;$SectionCopyWith<HistorySummary, $Res> get worked;$SectionCopyWith<List<Event>, $Res> get openEvents;

}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nextShift = null,Object? waitingCount = null,Object? worked = null,Object? openEvents = null,Object? refreshError = freezed,}) {
  return _then(HomeState(
nextShift: null == nextShift ? _self.nextShift : nextShift // ignore: cast_nullable_to_non_nullable
as Section<Application?>,waitingCount: null == waitingCount ? _self.waitingCount : waitingCount // ignore: cast_nullable_to_non_nullable
as Section<int>,worked: null == worked ? _self.worked : worked // ignore: cast_nullable_to_non_nullable
as Section<HistorySummary>,openEvents: null == openEvents ? _self.openEvents : openEvents // ignore: cast_nullable_to_non_nullable
as Section<List<Event>>,refreshError: freezed == refreshError ? _self.refreshError : refreshError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionCopyWith<Application?, $Res> get nextShift {
  
  return $SectionCopyWith<Application?, $Res>(_self.nextShift, (value) {
    return _then(_self.copyWith(nextShift: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionCopyWith<int, $Res> get waitingCount {
  
  return $SectionCopyWith<int, $Res>(_self.waitingCount, (value) {
    return _then(_self.copyWith(waitingCount: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionCopyWith<HistorySummary, $Res> get worked {
  
  return $SectionCopyWith<HistorySummary, $Res>(_self.worked, (value) {
    return _then(_self.copyWith(worked: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionCopyWith<List<Event>, $Res> get openEvents {
  
  return $SectionCopyWith<List<Event>, $Res>(_self.openEvents, (value) {
    return _then(_self.copyWith(openEvents: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Section<Application?> nextShift,  Section<int> waitingCount,  Section<HistorySummary> worked,  Section<List<Event>> openEvents,  String? refreshError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.nextShift,_that.waitingCount,_that.worked,_that.openEvents,_that.refreshError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Section<Application?> nextShift,  Section<int> waitingCount,  Section<HistorySummary> worked,  Section<List<Event>> openEvents,  String? refreshError)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.nextShift,_that.waitingCount,_that.worked,_that.openEvents,_that.refreshError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Section<Application?> nextShift,  Section<int> waitingCount,  Section<HistorySummary> worked,  Section<List<Event>> openEvents,  String? refreshError)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.nextShift,_that.waitingCount,_that.worked,_that.openEvents,_that.refreshError);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState extends HomeState {
  const _HomeState({this.nextShift = const Section<Application?>.loading(), this.waitingCount = const Section<int>.loading(), this.worked = const Section<HistorySummary>.loading(), this.openEvents = const Section<List<Event>>.loading(), this.refreshError}): super._();
  

/// First item of `GET /schedule/upcoming`; `null` when nothing is
/// scheduled (B3).
@override@JsonKey() final  Section<Application?> nextShift;
/// `meta.total` of `GET /applications?status=waiting` (D-04).
@override@JsonKey() final  Section<int> waitingCount;
/// `meta.summary` of `GET /schedule/history`.
@override@JsonKey() final  Section<HistorySummary> worked;
/// First page of open events in the user's branch (carousel).
@override@JsonKey() final  Section<List<Event>> openEvents;
@override final  String? refreshError;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.nextShift, nextShift) || other.nextShift == nextShift)&&(identical(other.waitingCount, waitingCount) || other.waitingCount == waitingCount)&&(identical(other.worked, worked) || other.worked == worked)&&(identical(other.openEvents, openEvents) || other.openEvents == openEvents)&&(identical(other.refreshError, refreshError) || other.refreshError == refreshError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,nextShift,waitingCount,worked,openEvents,refreshError);
}

@override
String toString() {
    return 'HomeState(nextShift: $nextShift, waitingCount: $waitingCount, worked: $worked, openEvents: $openEvents, refreshError: $refreshError)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 Section<Application?> nextShift, Section<int> waitingCount, Section<HistorySummary> worked, Section<List<Event>> openEvents, String? refreshError
});


@override $SectionCopyWith<Application?, $Res> get nextShift;@override $SectionCopyWith<int, $Res> get waitingCount;@override $SectionCopyWith<HistorySummary, $Res> get worked;@override $SectionCopyWith<List<Event>, $Res> get openEvents;

}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nextShift = null,Object? waitingCount = null,Object? worked = null,Object? openEvents = null,Object? refreshError = freezed,}) {
  return _then(_HomeState(
nextShift: null == nextShift ? _self.nextShift : nextShift // ignore: cast_nullable_to_non_nullable
as Section<Application?>,waitingCount: null == waitingCount ? _self.waitingCount : waitingCount // ignore: cast_nullable_to_non_nullable
as Section<int>,worked: null == worked ? _self.worked : worked // ignore: cast_nullable_to_non_nullable
as Section<HistorySummary>,openEvents: null == openEvents ? _self.openEvents : openEvents // ignore: cast_nullable_to_non_nullable
as Section<List<Event>>,refreshError: freezed == refreshError ? _self.refreshError : refreshError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionCopyWith<Application?, $Res> get nextShift {
  
  return $SectionCopyWith<Application?, $Res>(_self.nextShift, (value) {
    return _then(_self.copyWith(nextShift: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionCopyWith<int, $Res> get waitingCount {
  
  return $SectionCopyWith<int, $Res>(_self.waitingCount, (value) {
    return _then(_self.copyWith(waitingCount: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionCopyWith<HistorySummary, $Res> get worked {
  
  return $SectionCopyWith<HistorySummary, $Res>(_self.worked, (value) {
    return _then(_self.copyWith(worked: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionCopyWith<List<Event>, $Res> get openEvents {
  
  return $SectionCopyWith<List<Event>, $Res>(_self.openEvents, (value) {
    return _then(_self.copyWith(openEvents: value));
  });
}
}

// dart format on
