// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventDetail {

 int get id; String get title;@DateOnlyConverter() DateTime get date; String get startTime; String get endTime; int? get durationHours; String get venueName; Branch? get branch; DateTime get applyDeadline; bool get isUrgent; List<EventPosition> get positions; String? get venueAddress; String? get briefingTime; List<String> get requirements; String? get description; String? get adminNote;@JsonKey(unknownEnumValue: EventStatus.unknown) EventStatus get status; bool get canApply;@JsonKey(unknownEnumValue: CannotApplyReason.unknown) CannotApplyReason? get cannotApplyReason; Application? get myApplication;
/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailCopyWith<EventDetail> get copyWith => _$EventDetailCopyWithImpl<EventDetail>(this as EventDetail, _$identity);

  /// Serializes this EventDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime)&&(identical(other.durationHours, _this.durationHours) || other.durationHours == _this.durationHours)&&(identical(other.venueName, _this.venueName) || other.venueName == _this.venueName)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&(identical(other.applyDeadline, _this.applyDeadline) || other.applyDeadline == _this.applyDeadline)&&(identical(other.isUrgent, _this.isUrgent) || other.isUrgent == _this.isUrgent)&&const DeepCollectionEquality().equals(other.positions, _this.positions)&&(identical(other.venueAddress, _this.venueAddress) || other.venueAddress == _this.venueAddress)&&(identical(other.briefingTime, _this.briefingTime) || other.briefingTime == _this.briefingTime)&&const DeepCollectionEquality().equals(other.requirements, _this.requirements)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.adminNote, _this.adminNote) || other.adminNote == _this.adminNote)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.canApply, _this.canApply) || other.canApply == _this.canApply)&&(identical(other.cannotApplyReason, _this.cannotApplyReason) || other.cannotApplyReason == _this.cannotApplyReason)&&(identical(other.myApplication, _this.myApplication) || other.myApplication == _this.myApplication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventDetail;
  return Object.hashAll([runtimeType,_this.id,_this.title,_this.date,_this.startTime,_this.endTime,_this.durationHours,_this.venueName,_this.branch,_this.applyDeadline,_this.isUrgent,const DeepCollectionEquality().hash(_this.positions),_this.venueAddress,_this.briefingTime,const DeepCollectionEquality().hash(_this.requirements),_this.description,_this.adminNote,_this.status,_this.canApply,_this.cannotApplyReason,_this.myApplication]);
}

@override
String toString() {
  final _this = this as EventDetail;
  return 'EventDetail(id: ${_this.id}, title: ${_this.title}, date: ${_this.date}, startTime: ${_this.startTime}, endTime: ${_this.endTime}, durationHours: ${_this.durationHours}, venueName: ${_this.venueName}, branch: ${_this.branch}, applyDeadline: ${_this.applyDeadline}, isUrgent: ${_this.isUrgent}, positions: ${_this.positions}, venueAddress: ${_this.venueAddress}, briefingTime: ${_this.briefingTime}, requirements: ${_this.requirements}, description: ${_this.description}, adminNote: ${_this.adminNote}, status: ${_this.status}, canApply: ${_this.canApply}, cannotApplyReason: ${_this.cannotApplyReason}, myApplication: ${_this.myApplication})';
}


}

/// @nodoc
abstract mixin class $EventDetailCopyWith<$Res>  {
  factory $EventDetailCopyWith(EventDetail value, $Res Function(EventDetail) _then) = _$EventDetailCopyWithImpl;
@useResult
$Res call({
 int id, String title,@DateOnlyConverter() DateTime date, String startTime, String endTime, int? durationHours, String venueName, Branch? branch, DateTime applyDeadline, bool isUrgent, List<EventPosition> positions, String? venueAddress, String? briefingTime, List<String> requirements, String? description, String? adminNote,@JsonKey(unknownEnumValue: EventStatus.unknown) EventStatus status, bool canApply,@JsonKey(unknownEnumValue: CannotApplyReason.unknown) CannotApplyReason? cannotApplyReason, Application? myApplication
});


$BranchCopyWith<$Res>? get branch;$ApplicationCopyWith<$Res>? get myApplication;

}
/// @nodoc
class _$EventDetailCopyWithImpl<$Res>
    implements $EventDetailCopyWith<$Res> {
  _$EventDetailCopyWithImpl(this._self, this._then);

  final EventDetail _self;
  final $Res Function(EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? durationHours = freezed,Object? venueName = null,Object? branch = freezed,Object? applyDeadline = null,Object? isUrgent = null,Object? positions = null,Object? venueAddress = freezed,Object? briefingTime = freezed,Object? requirements = null,Object? description = freezed,Object? adminNote = freezed,Object? status = null,Object? canApply = null,Object? cannotApplyReason = freezed,Object? myApplication = freezed,}) {
  return _then(EventDetail(
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
as List<EventPosition>,venueAddress: freezed == venueAddress ? _self.venueAddress : venueAddress // ignore: cast_nullable_to_non_nullable
as String?,briefingTime: freezed == briefingTime ? _self.briefingTime : briefingTime // ignore: cast_nullable_to_non_nullable
as String?,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,adminNote: freezed == adminNote ? _self.adminNote : adminNote // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,canApply: null == canApply ? _self.canApply : canApply // ignore: cast_nullable_to_non_nullable
as bool,cannotApplyReason: freezed == cannotApplyReason ? _self.cannotApplyReason : cannotApplyReason // ignore: cast_nullable_to_non_nullable
as CannotApplyReason?,myApplication: freezed == myApplication ? _self.myApplication : myApplication // ignore: cast_nullable_to_non_nullable
as Application?,
  ));
}
/// Create a copy of EventDetail
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
}/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationCopyWith<$Res>? get myApplication {
    if (_self.myApplication == null) {
    return null;
  }

  return $ApplicationCopyWith<$Res>(_self.myApplication!, (value) {
    return _then(_self.copyWith(myApplication: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventDetail].
extension EventDetailPatterns on EventDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDetail value)  $default,){
final _that = this;
switch (_that) {
case _EventDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDetail value)?  $default,){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title, @DateOnlyConverter()  DateTime date,  String startTime,  String endTime,  int? durationHours,  String venueName,  Branch? branch,  DateTime applyDeadline,  bool isUrgent,  List<EventPosition> positions,  String? venueAddress,  String? briefingTime,  List<String> requirements,  String? description,  String? adminNote, @JsonKey(unknownEnumValue: EventStatus.unknown)  EventStatus status,  bool canApply, @JsonKey(unknownEnumValue: CannotApplyReason.unknown)  CannotApplyReason? cannotApplyReason,  Application? myApplication)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.startTime,_that.endTime,_that.durationHours,_that.venueName,_that.branch,_that.applyDeadline,_that.isUrgent,_that.positions,_that.venueAddress,_that.briefingTime,_that.requirements,_that.description,_that.adminNote,_that.status,_that.canApply,_that.cannotApplyReason,_that.myApplication);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title, @DateOnlyConverter()  DateTime date,  String startTime,  String endTime,  int? durationHours,  String venueName,  Branch? branch,  DateTime applyDeadline,  bool isUrgent,  List<EventPosition> positions,  String? venueAddress,  String? briefingTime,  List<String> requirements,  String? description,  String? adminNote, @JsonKey(unknownEnumValue: EventStatus.unknown)  EventStatus status,  bool canApply, @JsonKey(unknownEnumValue: CannotApplyReason.unknown)  CannotApplyReason? cannotApplyReason,  Application? myApplication)  $default,) {final _that = this;
switch (_that) {
case _EventDetail():
return $default(_that.id,_that.title,_that.date,_that.startTime,_that.endTime,_that.durationHours,_that.venueName,_that.branch,_that.applyDeadline,_that.isUrgent,_that.positions,_that.venueAddress,_that.briefingTime,_that.requirements,_that.description,_that.adminNote,_that.status,_that.canApply,_that.cannotApplyReason,_that.myApplication);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title, @DateOnlyConverter()  DateTime date,  String startTime,  String endTime,  int? durationHours,  String venueName,  Branch? branch,  DateTime applyDeadline,  bool isUrgent,  List<EventPosition> positions,  String? venueAddress,  String? briefingTime,  List<String> requirements,  String? description,  String? adminNote, @JsonKey(unknownEnumValue: EventStatus.unknown)  EventStatus status,  bool canApply, @JsonKey(unknownEnumValue: CannotApplyReason.unknown)  CannotApplyReason? cannotApplyReason,  Application? myApplication)?  $default,) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.startTime,_that.endTime,_that.durationHours,_that.venueName,_that.branch,_that.applyDeadline,_that.isUrgent,_that.positions,_that.venueAddress,_that.briefingTime,_that.requirements,_that.description,_that.adminNote,_that.status,_that.canApply,_that.cannotApplyReason,_that.myApplication);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventDetail extends EventDetail {
  const _EventDetail({required this.id, required this.title, @DateOnlyConverter() required this.date, required this.startTime, required this.endTime, this.durationHours, required this.venueName, this.branch, required this.applyDeadline, this.isUrgent = false,  List<EventPosition> positions = const [], this.venueAddress, this.briefingTime,  List<String> requirements = const [], this.description, this.adminNote, @JsonKey(unknownEnumValue: EventStatus.unknown) this.status = EventStatus.unknown, this.canApply = false, @JsonKey(unknownEnumValue: CannotApplyReason.unknown) this.cannotApplyReason, this.myApplication}): _positions = positions,_requirements = requirements,super._();
  factory _EventDetail.fromJson(Map<String, dynamic> json) => _$EventDetailFromJson(json);

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

@override final  String? venueAddress;
@override final  String? briefingTime;
 final  List<String> _requirements;
@override@JsonKey() List<String> get requirements {
  if (_requirements is EqualUnmodifiableListView) return _requirements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requirements);
}

@override final  String? description;
@override final  String? adminNote;
@override@JsonKey(unknownEnumValue: EventStatus.unknown) final  EventStatus status;
@override@JsonKey() final  bool canApply;
@override@JsonKey(unknownEnumValue: CannotApplyReason.unknown) final  CannotApplyReason? cannotApplyReason;
@override final  Application? myApplication;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailCopyWith<_EventDetail> get copyWith => __$EventDetailCopyWithImpl<_EventDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationHours, durationHours) || other.durationHours == durationHours)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.applyDeadline, applyDeadline) || other.applyDeadline == applyDeadline)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&const DeepCollectionEquality().equals(other.positions, _positions)&&(identical(other.venueAddress, venueAddress) || other.venueAddress == venueAddress)&&(identical(other.briefingTime, briefingTime) || other.briefingTime == briefingTime)&&const DeepCollectionEquality().equals(other.requirements, _requirements)&&(identical(other.description, description) || other.description == description)&&(identical(other.adminNote, adminNote) || other.adminNote == adminNote)&&(identical(other.status, status) || other.status == status)&&(identical(other.canApply, canApply) || other.canApply == canApply)&&(identical(other.cannotApplyReason, cannotApplyReason) || other.cannotApplyReason == cannotApplyReason)&&(identical(other.myApplication, myApplication) || other.myApplication == myApplication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,title,date,startTime,endTime,durationHours,venueName,branch,applyDeadline,isUrgent,const DeepCollectionEquality().hash(_positions),venueAddress,briefingTime,const DeepCollectionEquality().hash(_requirements),description,adminNote,status,canApply,cannotApplyReason,myApplication]);
}

@override
String toString() {
    return 'EventDetail(id: $id, title: $title, date: $date, startTime: $startTime, endTime: $endTime, durationHours: $durationHours, venueName: $venueName, branch: $branch, applyDeadline: $applyDeadline, isUrgent: $isUrgent, positions: $positions, venueAddress: $venueAddress, briefingTime: $briefingTime, requirements: $requirements, description: $description, adminNote: $adminNote, status: $status, canApply: $canApply, cannotApplyReason: $cannotApplyReason, myApplication: $myApplication)';
}


}

/// @nodoc
abstract mixin class _$EventDetailCopyWith<$Res> implements $EventDetailCopyWith<$Res> {
  factory _$EventDetailCopyWith(_EventDetail value, $Res Function(_EventDetail) _then) = __$EventDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String title,@DateOnlyConverter() DateTime date, String startTime, String endTime, int? durationHours, String venueName, Branch? branch, DateTime applyDeadline, bool isUrgent, List<EventPosition> positions, String? venueAddress, String? briefingTime, List<String> requirements, String? description, String? adminNote,@JsonKey(unknownEnumValue: EventStatus.unknown) EventStatus status, bool canApply,@JsonKey(unknownEnumValue: CannotApplyReason.unknown) CannotApplyReason? cannotApplyReason, Application? myApplication
});


@override $BranchCopyWith<$Res>? get branch;@override $ApplicationCopyWith<$Res>? get myApplication;

}
/// @nodoc
class __$EventDetailCopyWithImpl<$Res>
    implements _$EventDetailCopyWith<$Res> {
  __$EventDetailCopyWithImpl(this._self, this._then);

  final _EventDetail _self;
  final $Res Function(_EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? durationHours = freezed,Object? venueName = null,Object? branch = freezed,Object? applyDeadline = null,Object? isUrgent = null,Object? positions = null,Object? venueAddress = freezed,Object? briefingTime = freezed,Object? requirements = null,Object? description = freezed,Object? adminNote = freezed,Object? status = null,Object? canApply = null,Object? cannotApplyReason = freezed,Object? myApplication = freezed,}) {
  return _then(_EventDetail(
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
as List<EventPosition>,venueAddress: freezed == venueAddress ? _self.venueAddress : venueAddress // ignore: cast_nullable_to_non_nullable
as String?,briefingTime: freezed == briefingTime ? _self.briefingTime : briefingTime // ignore: cast_nullable_to_non_nullable
as String?,requirements: null == requirements ? _self._requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,adminNote: freezed == adminNote ? _self.adminNote : adminNote // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,canApply: null == canApply ? _self.canApply : canApply // ignore: cast_nullable_to_non_nullable
as bool,cannotApplyReason: freezed == cannotApplyReason ? _self.cannotApplyReason : cannotApplyReason // ignore: cast_nullable_to_non_nullable
as CannotApplyReason?,myApplication: freezed == myApplication ? _self.myApplication : myApplication // ignore: cast_nullable_to_non_nullable
as Application?,
  ));
}

/// Create a copy of EventDetail
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
}/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationCopyWith<$Res>? get myApplication {
    if (_self.myApplication == null) {
    return null;
  }

  return $ApplicationCopyWith<$Res>(_self.myApplication!, (value) {
    return _then(_self.copyWith(myApplication: value));
  });
}
}

// dart format on
