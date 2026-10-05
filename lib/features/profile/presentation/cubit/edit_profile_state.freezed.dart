// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'EditProfileState()';
}


}

/// @nodoc
class $EditProfileStateCopyWith<$Res>  {
$EditProfileStateCopyWith(EditProfileState _, $Res Function(EditProfileState) __);
}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditProfileLoading value)?  loading,TResult Function( EditProfileError value)?  error,TResult Function( EditProfileReady value)?  ready,TResult Function( EditProfileFailure value)?  failure,TResult Function( EditProfileSaved value)?  saved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditProfileLoading() when loading != null:
return loading(_that);case EditProfileError() when error != null:
return error(_that);case EditProfileReady() when ready != null:
return ready(_that);case EditProfileFailure() when failure != null:
return failure(_that);case EditProfileSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditProfileLoading value)  loading,required TResult Function( EditProfileError value)  error,required TResult Function( EditProfileReady value)  ready,required TResult Function( EditProfileFailure value)  failure,required TResult Function( EditProfileSaved value)  saved,}){
final _that = this;
switch (_that) {
case EditProfileLoading():
return loading(_that);case EditProfileError():
return error(_that);case EditProfileReady():
return ready(_that);case EditProfileFailure():
return failure(_that);case EditProfileSaved():
return saved(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditProfileLoading value)?  loading,TResult? Function( EditProfileError value)?  error,TResult? Function( EditProfileReady value)?  ready,TResult? Function( EditProfileFailure value)?  failure,TResult? Function( EditProfileSaved value)?  saved,}){
final _that = this;
switch (_that) {
case EditProfileLoading() when loading != null:
return loading(_that);case EditProfileError() when error != null:
return error(_that);case EditProfileReady() when ready != null:
return ready(_that);case EditProfileFailure() when failure != null:
return failure(_that);case EditProfileSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( List<Branch> branches,  bool saving,  bool uploadingAvatar)?  ready,TResult Function( List<Branch> branches,  String message,  Map<String, List<String>> fieldErrors)?  failure,TResult Function( bool resubmitted)?  saved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditProfileLoading() when loading != null:
return loading();case EditProfileError() when error != null:
return error(_that.message);case EditProfileReady() when ready != null:
return ready(_that.branches,_that.saving,_that.uploadingAvatar);case EditProfileFailure() when failure != null:
return failure(_that.branches,_that.message,_that.fieldErrors);case EditProfileSaved() when saved != null:
return saved(_that.resubmitted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( List<Branch> branches,  bool saving,  bool uploadingAvatar)  ready,required TResult Function( List<Branch> branches,  String message,  Map<String, List<String>> fieldErrors)  failure,required TResult Function( bool resubmitted)  saved,}) {final _that = this;
switch (_that) {
case EditProfileLoading():
return loading();case EditProfileError():
return error(_that.message);case EditProfileReady():
return ready(_that.branches,_that.saving,_that.uploadingAvatar);case EditProfileFailure():
return failure(_that.branches,_that.message,_that.fieldErrors);case EditProfileSaved():
return saved(_that.resubmitted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( List<Branch> branches,  bool saving,  bool uploadingAvatar)?  ready,TResult? Function( List<Branch> branches,  String message,  Map<String, List<String>> fieldErrors)?  failure,TResult? Function( bool resubmitted)?  saved,}) {final _that = this;
switch (_that) {
case EditProfileLoading() when loading != null:
return loading();case EditProfileError() when error != null:
return error(_that.message);case EditProfileReady() when ready != null:
return ready(_that.branches,_that.saving,_that.uploadingAvatar);case EditProfileFailure() when failure != null:
return failure(_that.branches,_that.message,_that.fieldErrors);case EditProfileSaved() when saved != null:
return saved(_that.resubmitted);case _:
  return null;

}
}

}

/// @nodoc


class EditProfileLoading extends EditProfileState {
  const EditProfileLoading(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'EditProfileState.loading()';
}


}




/// @nodoc


class EditProfileError extends EditProfileState {
  const EditProfileError(this.message): super._();
  

 final  String message;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileErrorCopyWith<EditProfileError> get copyWith => _$EditProfileErrorCopyWithImpl<EditProfileError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'EditProfileState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $EditProfileErrorCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileErrorCopyWith(EditProfileError value, $Res Function(EditProfileError) _then) = _$EditProfileErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$EditProfileErrorCopyWithImpl<$Res>
    implements $EditProfileErrorCopyWith<$Res> {
  _$EditProfileErrorCopyWithImpl(this._self, this._then);

  final EditProfileError _self;
  final $Res Function(EditProfileError) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(EditProfileError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EditProfileReady extends EditProfileState {
  const EditProfileReady({required  List<Branch> branches, this.saving = false, this.uploadingAvatar = false}): _branches = branches,super._();
  

 final  List<Branch> _branches;
 List<Branch> get branches {
  if (_branches is EqualUnmodifiableListView) return _branches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_branches);
}

@JsonKey() final  bool saving;
@JsonKey() final  bool uploadingAvatar;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileReadyCopyWith<EditProfileReady> get copyWith => _$EditProfileReadyCopyWithImpl<EditProfileReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileReady&&const DeepCollectionEquality().equals(other.branches, _branches)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.uploadingAvatar, uploadingAvatar) || other.uploadingAvatar == uploadingAvatar));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_branches),saving,uploadingAvatar);
}

@override
String toString() {
    return 'EditProfileState.ready(branches: $branches, saving: $saving, uploadingAvatar: $uploadingAvatar)';
}


}

/// @nodoc
abstract mixin class $EditProfileReadyCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileReadyCopyWith(EditProfileReady value, $Res Function(EditProfileReady) _then) = _$EditProfileReadyCopyWithImpl;
@useResult
$Res call({
 List<Branch> branches, bool saving, bool uploadingAvatar
});




}
/// @nodoc
class _$EditProfileReadyCopyWithImpl<$Res>
    implements $EditProfileReadyCopyWith<$Res> {
  _$EditProfileReadyCopyWithImpl(this._self, this._then);

  final EditProfileReady _self;
  final $Res Function(EditProfileReady) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? branches = null,Object? saving = null,Object? uploadingAvatar = null,}) {
  return _then(EditProfileReady(
branches: null == branches ? _self._branches : branches // ignore: cast_nullable_to_non_nullable
as List<Branch>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,uploadingAvatar: null == uploadingAvatar ? _self.uploadingAvatar : uploadingAvatar // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class EditProfileFailure extends EditProfileState {
  const EditProfileFailure({required  List<Branch> branches, required this.message,  Map<String, List<String>> fieldErrors = const {}}): _branches = branches,_fieldErrors = fieldErrors,super._();
  

 final  List<Branch> _branches;
 List<Branch> get branches {
  if (_branches is EqualUnmodifiableListView) return _branches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_branches);
}

 final  String message;
 final  Map<String, List<String>> _fieldErrors;
@JsonKey() Map<String, List<String>> get fieldErrors {
  if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fieldErrors);
}


/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileFailureCopyWith<EditProfileFailure> get copyWith => _$EditProfileFailureCopyWithImpl<EditProfileFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileFailure&&const DeepCollectionEquality().equals(other.branches, _branches)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.fieldErrors, _fieldErrors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_branches),message,const DeepCollectionEquality().hash(_fieldErrors));
}

@override
String toString() {
    return 'EditProfileState.failure(branches: $branches, message: $message, fieldErrors: $fieldErrors)';
}


}

/// @nodoc
abstract mixin class $EditProfileFailureCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileFailureCopyWith(EditProfileFailure value, $Res Function(EditProfileFailure) _then) = _$EditProfileFailureCopyWithImpl;
@useResult
$Res call({
 List<Branch> branches, String message, Map<String, List<String>> fieldErrors
});




}
/// @nodoc
class _$EditProfileFailureCopyWithImpl<$Res>
    implements $EditProfileFailureCopyWith<$Res> {
  _$EditProfileFailureCopyWithImpl(this._self, this._then);

  final EditProfileFailure _self;
  final $Res Function(EditProfileFailure) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? branches = null,Object? message = null,Object? fieldErrors = null,}) {
  return _then(EditProfileFailure(
branches: null == branches ? _self._branches : branches // ignore: cast_nullable_to_non_nullable
as List<Branch>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,fieldErrors: null == fieldErrors ? _self._fieldErrors : fieldErrors // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}


}

/// @nodoc


class EditProfileSaved extends EditProfileState {
  const EditProfileSaved({this.resubmitted = false}): super._();
  

@JsonKey() final  bool resubmitted;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileSavedCopyWith<EditProfileSaved> get copyWith => _$EditProfileSavedCopyWithImpl<EditProfileSaved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileSaved&&(identical(other.resubmitted, resubmitted) || other.resubmitted == resubmitted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,resubmitted);
}

@override
String toString() {
    return 'EditProfileState.saved(resubmitted: $resubmitted)';
}


}

/// @nodoc
abstract mixin class $EditProfileSavedCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileSavedCopyWith(EditProfileSaved value, $Res Function(EditProfileSaved) _then) = _$EditProfileSavedCopyWithImpl;
@useResult
$Res call({
 bool resubmitted
});




}
/// @nodoc
class _$EditProfileSavedCopyWithImpl<$Res>
    implements $EditProfileSavedCopyWith<$Res> {
  _$EditProfileSavedCopyWithImpl(this._self, this._then);

  final EditProfileSaved _self;
  final $Res Function(EditProfileSaved) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? resubmitted = null,}) {
  return _then(EditProfileSaved(
resubmitted: null == resubmitted ? _self.resubmitted : resubmitted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
