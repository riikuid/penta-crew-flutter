// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplicationPosition {

 int get id; CrewRole get role;
/// Create a copy of ApplicationPosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationPositionCopyWith<ApplicationPosition> get copyWith => _$ApplicationPositionCopyWithImpl<ApplicationPosition>(this as ApplicationPosition, _$identity);

  /// Serializes this ApplicationPosition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ApplicationPosition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationPosition&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ApplicationPosition;
  return Object.hash(runtimeType,_this.id,_this.role);
}

@override
String toString() {
  final _this = this as ApplicationPosition;
  return 'ApplicationPosition(id: ${_this.id}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $ApplicationPositionCopyWith<$Res>  {
  factory $ApplicationPositionCopyWith(ApplicationPosition value, $Res Function(ApplicationPosition) _then) = _$ApplicationPositionCopyWithImpl;
@useResult
$Res call({
 int id, CrewRole role
});


$CrewRoleCopyWith<$Res> get role;

}
/// @nodoc
class _$ApplicationPositionCopyWithImpl<$Res>
    implements $ApplicationPositionCopyWith<$Res> {
  _$ApplicationPositionCopyWithImpl(this._self, this._then);

  final ApplicationPosition _self;
  final $Res Function(ApplicationPosition) _then;

/// Create a copy of ApplicationPosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,}) {
  return _then(ApplicationPosition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CrewRole,
  ));
}
/// Create a copy of ApplicationPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CrewRoleCopyWith<$Res> get role {
  
  return $CrewRoleCopyWith<$Res>(_self.role, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApplicationPosition].
extension ApplicationPositionPatterns on ApplicationPosition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicationPosition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicationPosition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicationPosition value)  $default,){
final _that = this;
switch (_that) {
case _ApplicationPosition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicationPosition value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicationPosition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  CrewRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicationPosition() when $default != null:
return $default(_that.id,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  CrewRole role)  $default,) {final _that = this;
switch (_that) {
case _ApplicationPosition():
return $default(_that.id,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  CrewRole role)?  $default,) {final _that = this;
switch (_that) {
case _ApplicationPosition() when $default != null:
return $default(_that.id,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplicationPosition implements ApplicationPosition {
  const _ApplicationPosition({required this.id, required this.role});
  factory _ApplicationPosition.fromJson(Map<String, dynamic> json) => _$ApplicationPositionFromJson(json);

@override final  int id;
@override final  CrewRole role;

/// Create a copy of ApplicationPosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationPositionCopyWith<_ApplicationPosition> get copyWith => __$ApplicationPositionCopyWithImpl<_ApplicationPosition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationPositionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicationPosition&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,role);
}

@override
String toString() {
    return 'ApplicationPosition(id: $id, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ApplicationPositionCopyWith<$Res> implements $ApplicationPositionCopyWith<$Res> {
  factory _$ApplicationPositionCopyWith(_ApplicationPosition value, $Res Function(_ApplicationPosition) _then) = __$ApplicationPositionCopyWithImpl;
@override @useResult
$Res call({
 int id, CrewRole role
});


@override $CrewRoleCopyWith<$Res> get role;

}
/// @nodoc
class __$ApplicationPositionCopyWithImpl<$Res>
    implements _$ApplicationPositionCopyWith<$Res> {
  __$ApplicationPositionCopyWithImpl(this._self, this._then);

  final _ApplicationPosition _self;
  final $Res Function(_ApplicationPosition) _then;

/// Create a copy of ApplicationPosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,}) {
  return _then(_ApplicationPosition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CrewRole,
  ));
}

/// Create a copy of ApplicationPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CrewRoleCopyWith<$Res> get role {
  
  return $CrewRoleCopyWith<$Res>(_self.role, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}


/// @nodoc
mixin _$Application {

 int get id;@JsonKey(unknownEnumValue: ApplicationStatus.unknown) ApplicationStatus get status; ApplicationPosition get appliedPosition; ApplicationPosition? get assignedPosition; DateTime get appliedAt; DateTime get closesAt; DateTime? get decidedAt; Event? get event;
/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationCopyWith<Application> get copyWith => _$ApplicationCopyWithImpl<Application>(this as Application, _$identity);

  /// Serializes this Application to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Application;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Application&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.appliedPosition, _this.appliedPosition) || other.appliedPosition == _this.appliedPosition)&&(identical(other.assignedPosition, _this.assignedPosition) || other.assignedPosition == _this.assignedPosition)&&(identical(other.appliedAt, _this.appliedAt) || other.appliedAt == _this.appliedAt)&&(identical(other.closesAt, _this.closesAt) || other.closesAt == _this.closesAt)&&(identical(other.decidedAt, _this.decidedAt) || other.decidedAt == _this.decidedAt)&&(identical(other.event, _this.event) || other.event == _this.event));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Application;
  return Object.hash(runtimeType,_this.id,_this.status,_this.appliedPosition,_this.assignedPosition,_this.appliedAt,_this.closesAt,_this.decidedAt,_this.event);
}

@override
String toString() {
  final _this = this as Application;
  return 'Application(id: ${_this.id}, status: ${_this.status}, appliedPosition: ${_this.appliedPosition}, assignedPosition: ${_this.assignedPosition}, appliedAt: ${_this.appliedAt}, closesAt: ${_this.closesAt}, decidedAt: ${_this.decidedAt}, event: ${_this.event})';
}


}

/// @nodoc
abstract mixin class $ApplicationCopyWith<$Res>  {
  factory $ApplicationCopyWith(Application value, $Res Function(Application) _then) = _$ApplicationCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: ApplicationStatus.unknown) ApplicationStatus status, ApplicationPosition appliedPosition, ApplicationPosition? assignedPosition, DateTime appliedAt, DateTime closesAt, DateTime? decidedAt, Event? event
});


$ApplicationPositionCopyWith<$Res> get appliedPosition;$ApplicationPositionCopyWith<$Res>? get assignedPosition;$EventCopyWith<$Res>? get event;

}
/// @nodoc
class _$ApplicationCopyWithImpl<$Res>
    implements $ApplicationCopyWith<$Res> {
  _$ApplicationCopyWithImpl(this._self, this._then);

  final Application _self;
  final $Res Function(Application) _then;

/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? appliedPosition = null,Object? assignedPosition = freezed,Object? appliedAt = null,Object? closesAt = null,Object? decidedAt = freezed,Object? event = freezed,}) {
  return _then(Application(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,appliedPosition: null == appliedPosition ? _self.appliedPosition : appliedPosition // ignore: cast_nullable_to_non_nullable
as ApplicationPosition,assignedPosition: freezed == assignedPosition ? _self.assignedPosition : assignedPosition // ignore: cast_nullable_to_non_nullable
as ApplicationPosition?,appliedAt: null == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime,closesAt: null == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event?,
  ));
}
/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationPositionCopyWith<$Res> get appliedPosition {
  
  return $ApplicationPositionCopyWith<$Res>(_self.appliedPosition, (value) {
    return _then(_self.copyWith(appliedPosition: value));
  });
}/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationPositionCopyWith<$Res>? get assignedPosition {
    if (_self.assignedPosition == null) {
    return null;
  }

  return $ApplicationPositionCopyWith<$Res>(_self.assignedPosition!, (value) {
    return _then(_self.copyWith(assignedPosition: value));
  });
}/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res>? get event {
    if (_self.event == null) {
    return null;
  }

  return $EventCopyWith<$Res>(_self.event!, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [Application].
extension ApplicationPatterns on Application {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Application value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Application() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Application value)  $default,){
final _that = this;
switch (_that) {
case _Application():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Application value)?  $default,){
final _that = this;
switch (_that) {
case _Application() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: ApplicationStatus.unknown)  ApplicationStatus status,  ApplicationPosition appliedPosition,  ApplicationPosition? assignedPosition,  DateTime appliedAt,  DateTime closesAt,  DateTime? decidedAt,  Event? event)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Application() when $default != null:
return $default(_that.id,_that.status,_that.appliedPosition,_that.assignedPosition,_that.appliedAt,_that.closesAt,_that.decidedAt,_that.event);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: ApplicationStatus.unknown)  ApplicationStatus status,  ApplicationPosition appliedPosition,  ApplicationPosition? assignedPosition,  DateTime appliedAt,  DateTime closesAt,  DateTime? decidedAt,  Event? event)  $default,) {final _that = this;
switch (_that) {
case _Application():
return $default(_that.id,_that.status,_that.appliedPosition,_that.assignedPosition,_that.appliedAt,_that.closesAt,_that.decidedAt,_that.event);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(unknownEnumValue: ApplicationStatus.unknown)  ApplicationStatus status,  ApplicationPosition appliedPosition,  ApplicationPosition? assignedPosition,  DateTime appliedAt,  DateTime closesAt,  DateTime? decidedAt,  Event? event)?  $default,) {final _that = this;
switch (_that) {
case _Application() when $default != null:
return $default(_that.id,_that.status,_that.appliedPosition,_that.assignedPosition,_that.appliedAt,_that.closesAt,_that.decidedAt,_that.event);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Application extends Application {
  const _Application({required this.id, @JsonKey(unknownEnumValue: ApplicationStatus.unknown) required this.status, required this.appliedPosition, this.assignedPosition, required this.appliedAt, required this.closesAt, this.decidedAt, this.event}): super._();
  factory _Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);

@override final  int id;
@override@JsonKey(unknownEnumValue: ApplicationStatus.unknown) final  ApplicationStatus status;
@override final  ApplicationPosition appliedPosition;
@override final  ApplicationPosition? assignedPosition;
@override final  DateTime appliedAt;
@override final  DateTime closesAt;
@override final  DateTime? decidedAt;
@override final  Event? event;

/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationCopyWith<_Application> get copyWith => __$ApplicationCopyWithImpl<_Application>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Application&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.appliedPosition, appliedPosition) || other.appliedPosition == appliedPosition)&&(identical(other.assignedPosition, assignedPosition) || other.assignedPosition == assignedPosition)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt)&&(identical(other.event, event) || other.event == event));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,appliedPosition,assignedPosition,appliedAt,closesAt,decidedAt,event);
}

@override
String toString() {
    return 'Application(id: $id, status: $status, appliedPosition: $appliedPosition, assignedPosition: $assignedPosition, appliedAt: $appliedAt, closesAt: $closesAt, decidedAt: $decidedAt, event: $event)';
}


}

/// @nodoc
abstract mixin class _$ApplicationCopyWith<$Res> implements $ApplicationCopyWith<$Res> {
  factory _$ApplicationCopyWith(_Application value, $Res Function(_Application) _then) = __$ApplicationCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: ApplicationStatus.unknown) ApplicationStatus status, ApplicationPosition appliedPosition, ApplicationPosition? assignedPosition, DateTime appliedAt, DateTime closesAt, DateTime? decidedAt, Event? event
});


@override $ApplicationPositionCopyWith<$Res> get appliedPosition;@override $ApplicationPositionCopyWith<$Res>? get assignedPosition;@override $EventCopyWith<$Res>? get event;

}
/// @nodoc
class __$ApplicationCopyWithImpl<$Res>
    implements _$ApplicationCopyWith<$Res> {
  __$ApplicationCopyWithImpl(this._self, this._then);

  final _Application _self;
  final $Res Function(_Application) _then;

/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? appliedPosition = null,Object? assignedPosition = freezed,Object? appliedAt = null,Object? closesAt = null,Object? decidedAt = freezed,Object? event = freezed,}) {
  return _then(_Application(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,appliedPosition: null == appliedPosition ? _self.appliedPosition : appliedPosition // ignore: cast_nullable_to_non_nullable
as ApplicationPosition,assignedPosition: freezed == assignedPosition ? _self.assignedPosition : assignedPosition // ignore: cast_nullable_to_non_nullable
as ApplicationPosition?,appliedAt: null == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime,closesAt: null == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event?,
  ));
}

/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationPositionCopyWith<$Res> get appliedPosition {
  
  return $ApplicationPositionCopyWith<$Res>(_self.appliedPosition, (value) {
    return _then(_self.copyWith(appliedPosition: value));
  });
}/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationPositionCopyWith<$Res>? get assignedPosition {
    if (_self.assignedPosition == null) {
    return null;
  }

  return $ApplicationPositionCopyWith<$Res>(_self.assignedPosition!, (value) {
    return _then(_self.copyWith(assignedPosition: value));
  });
}/// Create a copy of Application
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res>? get event {
    if (_self.event == null) {
    return null;
  }

  return $EventCopyWith<$Res>(_self.event!, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
