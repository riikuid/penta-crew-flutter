// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 int get id; String get name; String? get email; String? get phone; String? get avatarUrl;@DateOnlyConverter() DateTime? get dateOfBirth;@JsonKey(unknownEnumValue: Gender.unknown) Gender? get gender; String? get address; Branch? get branch; List<CrewRole> get roles;@JsonKey(unknownEnumValue: VerificationStatus.unknown) VerificationStatus get verificationStatus; String? get verificationNote; DateTime? get submittedAt; DateTime? get reviewedAt;@DateOnlyConverter() DateTime? get memberSince; Set<String> get permissions;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as User;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.dateOfBirth, _this.dateOfBirth) || other.dateOfBirth == _this.dateOfBirth)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&const DeepCollectionEquality().equals(other.roles, _this.roles)&&(identical(other.verificationStatus, _this.verificationStatus) || other.verificationStatus == _this.verificationStatus)&&(identical(other.verificationNote, _this.verificationNote) || other.verificationNote == _this.verificationNote)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.reviewedAt, _this.reviewedAt) || other.reviewedAt == _this.reviewedAt)&&(identical(other.memberSince, _this.memberSince) || other.memberSince == _this.memberSince)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as User;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.phone,_this.avatarUrl,_this.dateOfBirth,_this.gender,_this.address,_this.branch,const DeepCollectionEquality().hash(_this.roles),_this.verificationStatus,_this.verificationNote,_this.submittedAt,_this.reviewedAt,_this.memberSince,const DeepCollectionEquality().hash(_this.permissions));
}

@override
String toString() {
  final _this = this as User;
  return 'User(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, avatarUrl: ${_this.avatarUrl}, dateOfBirth: ${_this.dateOfBirth}, gender: ${_this.gender}, address: ${_this.address}, branch: ${_this.branch}, roles: ${_this.roles}, verificationStatus: ${_this.verificationStatus}, verificationNote: ${_this.verificationNote}, submittedAt: ${_this.submittedAt}, reviewedAt: ${_this.reviewedAt}, memberSince: ${_this.memberSince}, permissions: ${_this.permissions})';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? email, String? phone, String? avatarUrl,@DateOnlyConverter() DateTime? dateOfBirth,@JsonKey(unknownEnumValue: Gender.unknown) Gender? gender, String? address, Branch? branch, List<CrewRole> roles,@JsonKey(unknownEnumValue: VerificationStatus.unknown) VerificationStatus verificationStatus, String? verificationNote, DateTime? submittedAt, DateTime? reviewedAt,@DateOnlyConverter() DateTime? memberSince, Set<String> permissions
});


$BranchCopyWith<$Res>? get branch;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? address = freezed,Object? branch = freezed,Object? roles = null,Object? verificationStatus = null,Object? verificationNote = freezed,Object? submittedAt = freezed,Object? reviewedAt = freezed,Object? memberSince = freezed,Object? permissions = null,}) {
  return _then(User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch?,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<CrewRole>,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,verificationNote: freezed == verificationNote ? _self.verificationNote : verificationNote // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberSince: freezed == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}
/// Create a copy of User
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


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? email,  String? phone,  String? avatarUrl, @DateOnlyConverter()  DateTime? dateOfBirth, @JsonKey(unknownEnumValue: Gender.unknown)  Gender? gender,  String? address,  Branch? branch,  List<CrewRole> roles, @JsonKey(unknownEnumValue: VerificationStatus.unknown)  VerificationStatus verificationStatus,  String? verificationNote,  DateTime? submittedAt,  DateTime? reviewedAt, @DateOnlyConverter()  DateTime? memberSince,  Set<String> permissions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.dateOfBirth,_that.gender,_that.address,_that.branch,_that.roles,_that.verificationStatus,_that.verificationNote,_that.submittedAt,_that.reviewedAt,_that.memberSince,_that.permissions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? email,  String? phone,  String? avatarUrl, @DateOnlyConverter()  DateTime? dateOfBirth, @JsonKey(unknownEnumValue: Gender.unknown)  Gender? gender,  String? address,  Branch? branch,  List<CrewRole> roles, @JsonKey(unknownEnumValue: VerificationStatus.unknown)  VerificationStatus verificationStatus,  String? verificationNote,  DateTime? submittedAt,  DateTime? reviewedAt, @DateOnlyConverter()  DateTime? memberSince,  Set<String> permissions)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.dateOfBirth,_that.gender,_that.address,_that.branch,_that.roles,_that.verificationStatus,_that.verificationNote,_that.submittedAt,_that.reviewedAt,_that.memberSince,_that.permissions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? email,  String? phone,  String? avatarUrl, @DateOnlyConverter()  DateTime? dateOfBirth, @JsonKey(unknownEnumValue: Gender.unknown)  Gender? gender,  String? address,  Branch? branch,  List<CrewRole> roles, @JsonKey(unknownEnumValue: VerificationStatus.unknown)  VerificationStatus verificationStatus,  String? verificationNote,  DateTime? submittedAt,  DateTime? reviewedAt, @DateOnlyConverter()  DateTime? memberSince,  Set<String> permissions)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.avatarUrl,_that.dateOfBirth,_that.gender,_that.address,_that.branch,_that.roles,_that.verificationStatus,_that.verificationNote,_that.submittedAt,_that.reviewedAt,_that.memberSince,_that.permissions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({required this.id, required this.name, this.email, this.phone, this.avatarUrl, @DateOnlyConverter() this.dateOfBirth, @JsonKey(unknownEnumValue: Gender.unknown) this.gender, this.address, this.branch,  List<CrewRole> roles = const [], @JsonKey(unknownEnumValue: VerificationStatus.unknown) this.verificationStatus = VerificationStatus.unknown, this.verificationNote, this.submittedAt, this.reviewedAt, @DateOnlyConverter() this.memberSince,  Set<String> permissions = const {}}): _roles = roles,_permissions = permissions,super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? email;
@override final  String? phone;
@override final  String? avatarUrl;
@override@DateOnlyConverter() final  DateTime? dateOfBirth;
@override@JsonKey(unknownEnumValue: Gender.unknown) final  Gender? gender;
@override final  String? address;
@override final  Branch? branch;
 final  List<CrewRole> _roles;
@override@JsonKey() List<CrewRole> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

@override@JsonKey(unknownEnumValue: VerificationStatus.unknown) final  VerificationStatus verificationStatus;
@override final  String? verificationNote;
@override final  DateTime? submittedAt;
@override final  DateTime? reviewedAt;
@override@DateOnlyConverter() final  DateTime? memberSince;
 final  Set<String> _permissions;
@override@JsonKey() Set<String> get permissions {
  if (_permissions is EqualUnmodifiableSetView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_permissions);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.address, address) || other.address == address)&&(identical(other.branch, branch) || other.branch == branch)&&const DeepCollectionEquality().equals(other.roles, _roles)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.verificationNote, verificationNote) || other.verificationNote == verificationNote)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.memberSince, memberSince) || other.memberSince == memberSince)&&const DeepCollectionEquality().equals(other.permissions, _permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,phone,avatarUrl,dateOfBirth,gender,address,branch,const DeepCollectionEquality().hash(_roles),verificationStatus,verificationNote,submittedAt,reviewedAt,memberSince,const DeepCollectionEquality().hash(_permissions));
}

@override
String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, avatarUrl: $avatarUrl, dateOfBirth: $dateOfBirth, gender: $gender, address: $address, branch: $branch, roles: $roles, verificationStatus: $verificationStatus, verificationNote: $verificationNote, submittedAt: $submittedAt, reviewedAt: $reviewedAt, memberSince: $memberSince, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? email, String? phone, String? avatarUrl,@DateOnlyConverter() DateTime? dateOfBirth,@JsonKey(unknownEnumValue: Gender.unknown) Gender? gender, String? address, Branch? branch, List<CrewRole> roles,@JsonKey(unknownEnumValue: VerificationStatus.unknown) VerificationStatus verificationStatus, String? verificationNote, DateTime? submittedAt, DateTime? reviewedAt,@DateOnlyConverter() DateTime? memberSince, Set<String> permissions
});


@override $BranchCopyWith<$Res>? get branch;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? address = freezed,Object? branch = freezed,Object? roles = null,Object? verificationStatus = null,Object? verificationNote = freezed,Object? submittedAt = freezed,Object? reviewedAt = freezed,Object? memberSince = freezed,Object? permissions = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch?,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<CrewRole>,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,verificationNote: freezed == verificationNote ? _self.verificationNote : verificationNote // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberSince: freezed == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime?,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

/// Create a copy of User
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
