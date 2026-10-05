// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterState {

 RegisterStep get step; RegisterStatus get status; String get name; String get email; String get phone; String get password; DateTime? get dateOfBirth; Gender? get gender; Branch? get branch; String get address;/// First message per field, keyed by [RegisterField].
 Map<String, String> get errors;/// Branch picker (`GET /branches`), loaded on first open.
 List<Branch> get branches; bool get branchesLoading; String? get branchesError;/// Set together with [RegisterStatus.failure].
 String? get failureMessage;
/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStateCopyWith<RegisterState> get copyWith => _$RegisterStateCopyWithImpl<RegisterState>(this as RegisterState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegisterState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterState&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.dateOfBirth, _this.dateOfBirth) || other.dateOfBirth == _this.dateOfBirth)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&(identical(other.address, _this.address) || other.address == _this.address)&&const DeepCollectionEquality().equals(other.errors, _this.errors)&&const DeepCollectionEquality().equals(other.branches, _this.branches)&&(identical(other.branchesLoading, _this.branchesLoading) || other.branchesLoading == _this.branchesLoading)&&(identical(other.branchesError, _this.branchesError) || other.branchesError == _this.branchesError)&&(identical(other.failureMessage, _this.failureMessage) || other.failureMessage == _this.failureMessage));
}


@override
int get hashCode {
  final _this = this as RegisterState;
  return Object.hash(runtimeType,_this.step,_this.status,_this.name,_this.email,_this.phone,_this.password,_this.dateOfBirth,_this.gender,_this.branch,_this.address,const DeepCollectionEquality().hash(_this.errors),const DeepCollectionEquality().hash(_this.branches),_this.branchesLoading,_this.branchesError,_this.failureMessage);
}

@override
String toString() {
  final _this = this as RegisterState;
  return 'RegisterState(step: ${_this.step}, status: ${_this.status}, name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, password: ${_this.password}, dateOfBirth: ${_this.dateOfBirth}, gender: ${_this.gender}, branch: ${_this.branch}, address: ${_this.address}, errors: ${_this.errors}, branches: ${_this.branches}, branchesLoading: ${_this.branchesLoading}, branchesError: ${_this.branchesError}, failureMessage: ${_this.failureMessage})';
}


}

/// @nodoc
abstract mixin class $RegisterStateCopyWith<$Res>  {
  factory $RegisterStateCopyWith(RegisterState value, $Res Function(RegisterState) _then) = _$RegisterStateCopyWithImpl;
@useResult
$Res call({
 RegisterStep step, RegisterStatus status, String name, String email, String phone, String password, DateTime? dateOfBirth, Gender? gender, Branch? branch, String address, Map<String, String> errors, List<Branch> branches, bool branchesLoading, String? branchesError, String? failureMessage
});


$BranchCopyWith<$Res>? get branch;

}
/// @nodoc
class _$RegisterStateCopyWithImpl<$Res>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._self, this._then);

  final RegisterState _self;
  final $Res Function(RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? status = null,Object? name = null,Object? email = null,Object? phone = null,Object? password = null,Object? dateOfBirth = freezed,Object? gender = freezed,Object? branch = freezed,Object? address = null,Object? errors = null,Object? branches = null,Object? branchesLoading = null,Object? branchesError = freezed,Object? failureMessage = freezed,}) {
  return _then(RegisterState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as RegisterStep,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegisterStatus,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,branches: null == branches ? _self.branches : branches // ignore: cast_nullable_to_non_nullable
as List<Branch>,branchesLoading: null == branchesLoading ? _self.branchesLoading : branchesLoading // ignore: cast_nullable_to_non_nullable
as bool,branchesError: freezed == branchesError ? _self.branchesError : branchesError // ignore: cast_nullable_to_non_nullable
as String?,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RegisterState
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


/// Adds pattern-matching-related methods to [RegisterState].
extension RegisterStatePatterns on RegisterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterState value)  $default,){
final _that = this;
switch (_that) {
case _RegisterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterState value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RegisterStep step,  RegisterStatus status,  String name,  String email,  String phone,  String password,  DateTime? dateOfBirth,  Gender? gender,  Branch? branch,  String address,  Map<String, String> errors,  List<Branch> branches,  bool branchesLoading,  String? branchesError,  String? failureMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.step,_that.status,_that.name,_that.email,_that.phone,_that.password,_that.dateOfBirth,_that.gender,_that.branch,_that.address,_that.errors,_that.branches,_that.branchesLoading,_that.branchesError,_that.failureMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RegisterStep step,  RegisterStatus status,  String name,  String email,  String phone,  String password,  DateTime? dateOfBirth,  Gender? gender,  Branch? branch,  String address,  Map<String, String> errors,  List<Branch> branches,  bool branchesLoading,  String? branchesError,  String? failureMessage)  $default,) {final _that = this;
switch (_that) {
case _RegisterState():
return $default(_that.step,_that.status,_that.name,_that.email,_that.phone,_that.password,_that.dateOfBirth,_that.gender,_that.branch,_that.address,_that.errors,_that.branches,_that.branchesLoading,_that.branchesError,_that.failureMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RegisterStep step,  RegisterStatus status,  String name,  String email,  String phone,  String password,  DateTime? dateOfBirth,  Gender? gender,  Branch? branch,  String address,  Map<String, String> errors,  List<Branch> branches,  bool branchesLoading,  String? branchesError,  String? failureMessage)?  $default,) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.step,_that.status,_that.name,_that.email,_that.phone,_that.password,_that.dateOfBirth,_that.gender,_that.branch,_that.address,_that.errors,_that.branches,_that.branchesLoading,_that.branchesError,_that.failureMessage);case _:
  return null;

}
}

}

/// @nodoc


class _RegisterState extends RegisterState {
  const _RegisterState({this.step = RegisterStep.account, this.status = RegisterStatus.editing, this.name = '', this.email = '', this.phone = '', this.password = '', this.dateOfBirth, this.gender, this.branch, this.address = '',  Map<String, String> errors = const {},  List<Branch> branches = const [], this.branchesLoading = false, this.branchesError, this.failureMessage}): _errors = errors,_branches = branches,super._();
  

@override@JsonKey() final  RegisterStep step;
@override@JsonKey() final  RegisterStatus status;
@override@JsonKey() final  String name;
@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String password;
@override final  DateTime? dateOfBirth;
@override final  Gender? gender;
@override final  Branch? branch;
@override@JsonKey() final  String address;
/// First message per field, keyed by [RegisterField].
 final  Map<String, String> _errors;
/// First message per field, keyed by [RegisterField].
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

/// Branch picker (`GET /branches`), loaded on first open.
 final  List<Branch> _branches;
/// Branch picker (`GET /branches`), loaded on first open.
@override@JsonKey() List<Branch> get branches {
  if (_branches is EqualUnmodifiableListView) return _branches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_branches);
}

@override@JsonKey() final  bool branchesLoading;
@override final  String? branchesError;
/// Set together with [RegisterStatus.failure].
@override final  String? failureMessage;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterStateCopyWith<_RegisterState> get copyWith => __$RegisterStateCopyWithImpl<_RegisterState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterState&&(identical(other.step, step) || other.step == step)&&(identical(other.status, status) || other.status == status)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.password, password) || other.password == password)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other.errors, _errors)&&const DeepCollectionEquality().equals(other.branches, _branches)&&(identical(other.branchesLoading, branchesLoading) || other.branchesLoading == branchesLoading)&&(identical(other.branchesError, branchesError) || other.branchesError == branchesError)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,status,name,email,phone,password,dateOfBirth,gender,branch,address,const DeepCollectionEquality().hash(_errors),const DeepCollectionEquality().hash(_branches),branchesLoading,branchesError,failureMessage);
}

@override
String toString() {
    return 'RegisterState(step: $step, status: $status, name: $name, email: $email, phone: $phone, password: $password, dateOfBirth: $dateOfBirth, gender: $gender, branch: $branch, address: $address, errors: $errors, branches: $branches, branchesLoading: $branchesLoading, branchesError: $branchesError, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class _$RegisterStateCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$RegisterStateCopyWith(_RegisterState value, $Res Function(_RegisterState) _then) = __$RegisterStateCopyWithImpl;
@override @useResult
$Res call({
 RegisterStep step, RegisterStatus status, String name, String email, String phone, String password, DateTime? dateOfBirth, Gender? gender, Branch? branch, String address, Map<String, String> errors, List<Branch> branches, bool branchesLoading, String? branchesError, String? failureMessage
});


@override $BranchCopyWith<$Res>? get branch;

}
/// @nodoc
class __$RegisterStateCopyWithImpl<$Res>
    implements _$RegisterStateCopyWith<$Res> {
  __$RegisterStateCopyWithImpl(this._self, this._then);

  final _RegisterState _self;
  final $Res Function(_RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? status = null,Object? name = null,Object? email = null,Object? phone = null,Object? password = null,Object? dateOfBirth = freezed,Object? gender = freezed,Object? branch = freezed,Object? address = null,Object? errors = null,Object? branches = null,Object? branchesLoading = null,Object? branchesError = freezed,Object? failureMessage = freezed,}) {
  return _then(_RegisterState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as RegisterStep,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegisterStatus,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,branches: null == branches ? _self._branches : branches // ignore: cast_nullable_to_non_nullable
as List<Branch>,branchesLoading: null == branchesLoading ? _self.branchesLoading : branchesLoading // ignore: cast_nullable_to_non_nullable
as bool,branchesError: freezed == branchesError ? _self.branchesError : branchesError // ignore: cast_nullable_to_non_nullable
as String?,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RegisterState
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
