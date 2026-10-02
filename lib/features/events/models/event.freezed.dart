// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Event {

 int get id; String get title;@DateOnlyConverter() DateTime get date; String get startTime; String get endTime; int? get durationHours; String get venueName; Branch? get branch; DateTime get applyDeadline; bool get isUrgent; List<EventPosition> get positions;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Event;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime)&&(identical(other.durationHours, _this.durationHours) || other.durationHours == _this.durationHours)&&(identical(other.venueName, _this.venueName) || other.venueName == _this.venueName)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&(identical(other.applyDeadline, _this.applyDeadline) || other.applyDeadline == _this.applyDeadline)&&(identical(other.isUrgent, _this.isUrgent) || other.isUrgent == _this.isUrgent)&&const DeepCollectionEquality().equals(other.positions, _this.positions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Event;
  return Object.hash(runtimeType,_this.id,_this.title,_this.date,_this.startTime,_this.endTime,_this.durationHours,_this.venueName,_this.branch,_this.applyDeadline,_this.isUrgent,const DeepCollectionEquality().hash(_this.positions));
}

@override
String toString() {
  final _this = this as Event;
  return 'Event(id: ${_this.id}, title: ${_this.title}, date: ${_this.date}, startTime: ${_this.startTime}, endTime: ${_this.endTime}, durationHours: ${_this.durationHours}, venueName: ${_this.venueName}, branch: ${_this.branch}, applyDeadline: ${_this.applyDeadline}, isUrgent: ${_this.isUrgent}, positions: ${_this.positions})';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 int id, String title,@DateOnlyConverter() DateTime date, String startTime, String endTime, int? durationHours, String venueName, Branch? branch, DateTime applyDeadline, bool isUrgent, List<EventPosition> positions
});


$BranchCopyWith<$Res>? get branch;

}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? durationHours = freezed,Object? venueName = null,Object? branch = freezed,Object? applyDeadline = null,Object? isUrgent = null,Object? positions = null,}) {
  return _then(Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,durationHours: freezed == durationHours ? _self.durationHours : durationHours // ignore: cast_nullable_to_non_nullable
as int?,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch?,applyDeadline: null == applyDeadline ? _self.applyDeadline : applyDeadline // ignore: cast_nullable_to_non_nullable
as DateTime,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,positions: null == positions ? _self.positions : positions // ignore: cast_nullable_to_non_nullable
as List<EventPosition>,
  ));
}
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BranchCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $BranchCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}
}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title, @DateOnlyConverter()  DateTime date,  String startTime,  String endTime,  int? durationHours,  String venueName,  Branch? branch,  DateTime applyDeadline,  bool isUrgent,  List<EventPosition> positions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.startTime,_that.endTime,_that.durationHours,_that.venueName,_that.branch,_that.applyDeadline,_that.isUrgent,_that.positions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title, @DateOnlyConverter()  DateTime date,  String startTime,  String endTime,  int? durationHours,  String venueName,  Branch? branch,  DateTime applyDeadline,  bool isUrgent,  List<EventPosition> positions)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.title,_that.date,_that.startTime,_that.endTime,_that.durationHours,_that.venueName,_that.branch,_that.applyDeadline,_that.isUrgent,_that.positions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title, @DateOnlyConverter()  DateTime date,  String startTime,  String endTime,  int? durationHours,  String venueName,  Branch? branch,  DateTime applyDeadline,  bool isUrgent,  List<EventPosition> positions)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.startTime,_that.endTime,_that.durationHours,_that.venueName,_that.branch,_that.applyDeadline,_that.isUrgent,_that.positions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Event extends Event {
  const _Event({required this.id, required this.title, @DateOnlyConverter() required this.date, required this.startTime, required this.endTime, this.durationHours, required this.venueName, this.branch, required this.applyDeadline, this.isUrgent = false,  List<EventPosition> positions = const []}): _positions = positions,super._();
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

@override final  int id;
@override final  String title;
@override@DateOnlyConverter() final  DateTime date;
@override final  String startTime;
@override final  String endTime;
@override final  int? durationHours;
@override final  String venueName;
@override final  Branch? branch;
@override final  DateTime applyDeadline;
@override@JsonKey() final  bool isUrgent;
 final  List<EventPosition> _positions;
@override@JsonKey() List<EventPosition> get positions {
  if (_positions is EqualUnmodifiableListView) return _positions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_positions);
}


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationHours, durationHours) || other.durationHours == durationHours)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.applyDeadline, applyDeadline) || other.applyDeadline == applyDeadline)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&const DeepCollectionEquality().equals(other.positions, _positions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,date,startTime,endTime,durationHours,venueName,branch,applyDeadline,isUrgent,const DeepCollectionEquality().hash(_positions));
}

@override
String toString() {
    return 'Event(id: $id, title: $title, date: $date, startTime: $startTime, endTime: $endTime, durationHours: $durationHours, venueName: $venueName, branch: $branch, applyDeadline: $applyDeadline, isUrgent: $isUrgent, positions: $positions)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 int id, String title,@DateOnlyConverter() DateTime date, String startTime, String endTime, int? durationHours, String venueName, Branch? branch, DateTime applyDeadline, bool isUrgent, List<EventPosition> positions
});


@override $BranchCopyWith<$Res>? get branch;

}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? durationHours = freezed,Object? venueName = null,Object? branch = freezed,Object? applyDeadline = null,Object? isUrgent = null,Object? positions = null,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,durationHours: freezed == durationHours ? _self.durationHours : durationHours // ignore: cast_nullable_to_non_nullable
as int?,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch?,applyDeadline: null == applyDeadline ? _self.applyDeadline : applyDeadline // ignore: cast_nullable_to_non_nullable
as DateTime,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,positions: null == positions ? _self._positions : positions // ignore: cast_nullable_to_non_nullable
as List<EventPosition>,
  ));
}

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BranchCopyWith<$Res>? get branch {
    if (_self.branch == null) {
    return null;
  }

  return $BranchCopyWith<$Res>(_self.branch!, (value) {
    return _then(_self.copyWith(branch: value));
  });
}
}

// dart format on
