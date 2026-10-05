// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'month_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthGroup {

/// First day of the month, used as the group key.
 DateTime get month; List<Application> get items;
/// Create a copy of MonthGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthGroupCopyWith<MonthGroup> get copyWith => _$MonthGroupCopyWithImpl<MonthGroup>(this as MonthGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MonthGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthGroup&&(identical(other.month, _this.month) || other.month == _this.month)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as MonthGroup;
  return Object.hash(runtimeType,_this.month,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as MonthGroup;
  return 'MonthGroup(month: ${_this.month}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $MonthGroupCopyWith<$Res>  {
  factory $MonthGroupCopyWith(MonthGroup value, $Res Function(MonthGroup) _then) = _$MonthGroupCopyWithImpl;
@useResult
$Res call({
 DateTime month, List<Application> items
});




}
/// @nodoc
class _$MonthGroupCopyWithImpl<$Res>
    implements $MonthGroupCopyWith<$Res> {
  _$MonthGroupCopyWithImpl(this._self, this._then);

  final MonthGroup _self;
  final $Res Function(MonthGroup) _then;

/// Create a copy of MonthGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? items = null,}) {
  return _then(MonthGroup(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Application>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthGroup].
extension MonthGroupPatterns on MonthGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthGroup value)  $default,){
final _that = this;
switch (_that) {
case _MonthGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthGroup value)?  $default,){
final _that = this;
switch (_that) {
case _MonthGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  List<Application> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthGroup() when $default != null:
return $default(_that.month,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  List<Application> items)  $default,) {final _that = this;
switch (_that) {
case _MonthGroup():
return $default(_that.month,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  List<Application> items)?  $default,) {final _that = this;
switch (_that) {
case _MonthGroup() when $default != null:
return $default(_that.month,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _MonthGroup extends MonthGroup {
  const _MonthGroup({required this.month, required  List<Application> items}): _items = items,super._();
  

/// First day of the month, used as the group key.
@override final  DateTime month;
 final  List<Application> _items;
@override List<Application> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MonthGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthGroupCopyWith<_MonthGroup> get copyWith => __$MonthGroupCopyWithImpl<_MonthGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthGroup&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'MonthGroup(month: $month, items: $items)';
}


}

/// @nodoc
abstract mixin class _$MonthGroupCopyWith<$Res> implements $MonthGroupCopyWith<$Res> {
  factory _$MonthGroupCopyWith(_MonthGroup value, $Res Function(_MonthGroup) _then) = __$MonthGroupCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, List<Application> items
});




}
/// @nodoc
class __$MonthGroupCopyWithImpl<$Res>
    implements _$MonthGroupCopyWith<$Res> {
  __$MonthGroupCopyWithImpl(this._self, this._then);

  final _MonthGroup _self;
  final $Res Function(_MonthGroup) _then;

/// Create a copy of MonthGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? items = null,}) {
  return _then(_MonthGroup(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Application>,
  ));
}


}

// dart format on
