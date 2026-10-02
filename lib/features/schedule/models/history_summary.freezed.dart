// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistorySummary {

 int get workedCount;@DateOnlyConverter() DateTime? get workedSince;
/// Create a copy of HistorySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistorySummaryCopyWith<HistorySummary> get copyWith => _$HistorySummaryCopyWithImpl<HistorySummary>(this as HistorySummary, _$identity);

  /// Serializes this HistorySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HistorySummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistorySummary&&(identical(other.workedCount, _this.workedCount) || other.workedCount == _this.workedCount)&&(identical(other.workedSince, _this.workedSince) || other.workedSince == _this.workedSince));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HistorySummary;
  return Object.hash(runtimeType,_this.workedCount,_this.workedSince);
}

@override
String toString() {
  final _this = this as HistorySummary;
  return 'HistorySummary(workedCount: ${_this.workedCount}, workedSince: ${_this.workedSince})';
}


}

/// @nodoc
abstract mixin class $HistorySummaryCopyWith<$Res>  {
  factory $HistorySummaryCopyWith(HistorySummary value, $Res Function(HistorySummary) _then) = _$HistorySummaryCopyWithImpl;
@useResult
$Res call({
 int workedCount,@DateOnlyConverter() DateTime? workedSince
});




}
/// @nodoc
class _$HistorySummaryCopyWithImpl<$Res>
    implements $HistorySummaryCopyWith<$Res> {
  _$HistorySummaryCopyWithImpl(this._self, this._then);

  final HistorySummary _self;
  final $Res Function(HistorySummary) _then;

/// Create a copy of HistorySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workedCount = null,Object? workedSince = freezed,}) {
  return _then(HistorySummary(
workedCount: null == workedCount ? _self.workedCount : workedCount // ignore: cast_nullable_to_non_nullable
as int,workedSince: freezed == workedSince ? _self.workedSince : workedSince // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HistorySummary].
extension HistorySummaryPatterns on HistorySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistorySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistorySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistorySummary value)  $default,){
final _that = this;
switch (_that) {
case _HistorySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistorySummary value)?  $default,){
final _that = this;
switch (_that) {
case _HistorySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int workedCount, @DateOnlyConverter()  DateTime? workedSince)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistorySummary() when $default != null:
return $default(_that.workedCount,_that.workedSince);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int workedCount, @DateOnlyConverter()  DateTime? workedSince)  $default,) {final _that = this;
switch (_that) {
case _HistorySummary():
return $default(_that.workedCount,_that.workedSince);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int workedCount, @DateOnlyConverter()  DateTime? workedSince)?  $default,) {final _that = this;
switch (_that) {
case _HistorySummary() when $default != null:
return $default(_that.workedCount,_that.workedSince);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistorySummary implements HistorySummary {
  const _HistorySummary({this.workedCount = 0, @DateOnlyConverter() this.workedSince});
  factory _HistorySummary.fromJson(Map<String, dynamic> json) => _$HistorySummaryFromJson(json);

@override@JsonKey() final  int workedCount;
@override@DateOnlyConverter() final  DateTime? workedSince;

/// Create a copy of HistorySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistorySummaryCopyWith<_HistorySummary> get copyWith => __$HistorySummaryCopyWithImpl<_HistorySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistorySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistorySummary&&(identical(other.workedCount, workedCount) || other.workedCount == workedCount)&&(identical(other.workedSince, workedSince) || other.workedSince == workedSince));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workedCount,workedSince);
}

@override
String toString() {
    return 'HistorySummary(workedCount: $workedCount, workedSince: $workedSince)';
}


}

/// @nodoc
abstract mixin class _$HistorySummaryCopyWith<$Res> implements $HistorySummaryCopyWith<$Res> {
  factory _$HistorySummaryCopyWith(_HistorySummary value, $Res Function(_HistorySummary) _then) = __$HistorySummaryCopyWithImpl;
@override @useResult
$Res call({
 int workedCount,@DateOnlyConverter() DateTime? workedSince
});




}
/// @nodoc
class __$HistorySummaryCopyWithImpl<$Res>
    implements _$HistorySummaryCopyWith<$Res> {
  __$HistorySummaryCopyWithImpl(this._self, this._then);

  final _HistorySummary _self;
  final $Res Function(_HistorySummary) _then;

/// Create a copy of HistorySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workedCount = null,Object? workedSince = freezed,}) {
  return _then(_HistorySummary(
workedCount: null == workedCount ? _self.workedCount : workedCount // ignore: cast_nullable_to_non_nullable
as int,workedSince: freezed == workedSince ? _self.workedSince : workedSince // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
