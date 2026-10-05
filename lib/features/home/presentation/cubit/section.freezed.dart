// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Section<T> {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Section<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Section<$T>()';
}


}

/// @nodoc
class $SectionCopyWith<T,$Res>  {
$SectionCopyWith(Section<T> _, $Res Function(Section<T>) __);
}


/// Adds pattern-matching-related methods to [Section].
extension SectionPatterns<T> on Section<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SectionLoading<T> value)?  loading,TResult Function( SectionLoaded<T> value)?  loaded,TResult Function( SectionError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SectionLoading() when loading != null:
return loading(_that);case SectionLoaded() when loaded != null:
return loaded(_that);case SectionError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SectionLoading<T> value)  loading,required TResult Function( SectionLoaded<T> value)  loaded,required TResult Function( SectionError<T> value)  error,}){
final _that = this;
switch (_that) {
case SectionLoading():
return loading(_that);case SectionLoaded():
return loaded(_that);case SectionError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SectionLoading<T> value)?  loading,TResult? Function( SectionLoaded<T> value)?  loaded,TResult? Function( SectionError<T> value)?  error,}){
final _that = this;
switch (_that) {
case SectionLoading() when loading != null:
return loading(_that);case SectionLoaded() when loaded != null:
return loaded(_that);case SectionError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( T data)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SectionLoading() when loading != null:
return loading();case SectionLoaded() when loaded != null:
return loaded(_that.data);case SectionError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( T data)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SectionLoading():
return loading();case SectionLoaded():
return loaded(_that.data);case SectionError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( T data)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SectionLoading() when loading != null:
return loading();case SectionLoaded() when loaded != null:
return loaded(_that.data);case SectionError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SectionLoading<T> implements Section<T> {
  const SectionLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Section<$T>.loading()';
}


}




/// @nodoc


class SectionLoaded<T> implements Section<T> {
  const SectionLoaded(this.data);
  

 final  T data;

/// Create a copy of Section
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionLoadedCopyWith<T, SectionLoaded<T>> get copyWith => _$SectionLoadedCopyWithImpl<T, SectionLoaded<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionLoaded<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data));
}

@override
String toString() {
    return 'Section<$T>.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class $SectionLoadedCopyWith<T,$Res> implements $SectionCopyWith<T, $Res> {
  factory $SectionLoadedCopyWith(SectionLoaded<T> value, $Res Function(SectionLoaded<T>) _then) = _$SectionLoadedCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$SectionLoadedCopyWithImpl<T,$Res>
    implements $SectionLoadedCopyWith<T, $Res> {
  _$SectionLoadedCopyWithImpl(this._self, this._then);

  final SectionLoaded<T> _self;
  final $Res Function(SectionLoaded<T>) _then;

/// Create a copy of Section
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(SectionLoaded<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class SectionError<T> implements Section<T> {
  const SectionError(this.message);
  

 final  String message;

/// Create a copy of Section
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionErrorCopyWith<T, SectionError<T>> get copyWith => _$SectionErrorCopyWithImpl<T, SectionError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionError<T>&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Section<$T>.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SectionErrorCopyWith<T,$Res> implements $SectionCopyWith<T, $Res> {
  factory $SectionErrorCopyWith(SectionError<T> value, $Res Function(SectionError<T>) _then) = _$SectionErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SectionErrorCopyWithImpl<T,$Res>
    implements $SectionErrorCopyWith<T, $Res> {
  _$SectionErrorCopyWithImpl(this._self, this._then);

  final SectionError<T> _self;
  final $Res Function(SectionError<T>) _then;

/// Create a copy of Section
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SectionError<T>(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
