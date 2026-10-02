// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventPosition {

 int get id; CrewRole get role; int get needed; bool get matchesMyRole;
/// Create a copy of EventPosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventPositionCopyWith<EventPosition> get copyWith => _$EventPositionCopyWithImpl<EventPosition>(this as EventPosition, _$identity);

  /// Serializes this EventPosition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventPosition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventPosition&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.needed, _this.needed) || other.needed == _this.needed)&&(identical(other.matchesMyRole, _this.matchesMyRole) || other.matchesMyRole == _this.matchesMyRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventPosition;
  return Object.hash(runtimeType,_this.id,_this.role,_this.needed,_this.matchesMyRole);
}

@override
String toString() {
  final _this = this as EventPosition;
  return 'EventPosition(id: ${_this.id}, role: ${_this.role}, needed: ${_this.needed}, matchesMyRole: ${_this.matchesMyRole})';
}


}

/// @nodoc
abstract mixin class $EventPositionCopyWith<$Res>  {
  factory $EventPositionCopyWith(EventPosition value, $Res Function(EventPosition) _then) = _$EventPositionCopyWithImpl;
@useResult
$Res call({
 int id, CrewRole role, int needed, bool matchesMyRole
});


$CrewRoleCopyWith<$Res> get role;

}
/// @nodoc
class _$EventPositionCopyWithImpl<$Res>
    implements $EventPositionCopyWith<$Res> {
  _$EventPositionCopyWithImpl(this._self, this._then);

  final EventPosition _self;
  final $Res Function(EventPosition) _then;

/// Create a copy of EventPosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? needed = null,Object? matchesMyRole = null,}) {
  return _then(EventPosition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CrewRole,needed: null == needed ? _self.needed : needed // ignore: cast_nullable_to_non_nullable
as int,matchesMyRole: null == matchesMyRole ? _self.matchesMyRole : matchesMyRole // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EventPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CrewRoleCopyWith<$Res> get role {
  
  return $CrewRoleCopyWith<$Res>(_self.role, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventPosition].
extension EventPositionPatterns on EventPosition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventPosition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventPosition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventPosition value)  $default,){
final _that = this;
switch (_that) {
case _EventPosition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventPosition value)?  $default,){
final _that = this;
switch (_that) {
case _EventPosition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  CrewRole role,  int needed,  bool matchesMyRole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventPosition() when $default != null:
return $default(_that.id,_that.role,_that.needed,_that.matchesMyRole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  CrewRole role,  int needed,  bool matchesMyRole)  $default,) {final _that = this;
switch (_that) {
case _EventPosition():
return $default(_that.id,_that.role,_that.needed,_that.matchesMyRole);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  CrewRole role,  int needed,  bool matchesMyRole)?  $default,) {final _that = this;
switch (_that) {
case _EventPosition() when $default != null:
return $default(_that.id,_that.role,_that.needed,_that.matchesMyRole);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventPosition implements EventPosition {
  const _EventPosition({required this.id, required this.role, required this.needed, this.matchesMyRole = false});
  factory _EventPosition.fromJson(Map<String, dynamic> json) => _$EventPositionFromJson(json);

@override final  int id;
@override final  CrewRole role;
@override final  int needed;
@override@JsonKey() final  bool matchesMyRole;

/// Create a copy of EventPosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventPositionCopyWith<_EventPosition> get copyWith => __$EventPositionCopyWithImpl<_EventPosition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventPositionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventPosition&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.needed, needed) || other.needed == needed)&&(identical(other.matchesMyRole, matchesMyRole) || other.matchesMyRole == matchesMyRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,role,needed,matchesMyRole);
}

@override
String toString() {
    return 'EventPosition(id: $id, role: $role, needed: $needed, matchesMyRole: $matchesMyRole)';
}


}

/// @nodoc
abstract mixin class _$EventPositionCopyWith<$Res> implements $EventPositionCopyWith<$Res> {
  factory _$EventPositionCopyWith(_EventPosition value, $Res Function(_EventPosition) _then) = __$EventPositionCopyWithImpl;
@override @useResult
$Res call({
 int id, CrewRole role, int needed, bool matchesMyRole
});


@override $CrewRoleCopyWith<$Res> get role;

}
/// @nodoc
class __$EventPositionCopyWithImpl<$Res>
    implements _$EventPositionCopyWith<$Res> {
  __$EventPositionCopyWithImpl(this._self, this._then);

  final _EventPosition _self;
  final $Res Function(_EventPosition) _then;

/// Create a copy of EventPosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? needed = null,Object? matchesMyRole = null,}) {
  return _then(_EventPosition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CrewRole,needed: null == needed ? _self.needed : needed // ignore: cast_nullable_to_non_nullable
as int,matchesMyRole: null == matchesMyRole ? _self.matchesMyRole : matchesMyRole // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EventPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CrewRoleCopyWith<$Res> get role {
  
  return $CrewRoleCopyWith<$Res>(_self.role, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}

// dart format on
