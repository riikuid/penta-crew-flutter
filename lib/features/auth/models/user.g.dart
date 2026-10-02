// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_User',
  json,
  ($checkedConvert) {
    final val = _User(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      name: $checkedConvert('name', (v) => v as String),
      email: $checkedConvert('email', (v) => v as String?),
      phone: $checkedConvert('phone', (v) => v as String?),
      avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
      dateOfBirth: $checkedConvert(
        'date_of_birth',
        (v) => _$JsonConverterFromJson<String, DateTime>(
          v,
          const DateOnlyConverter().fromJson,
        ),
      ),
      gender: $checkedConvert(
        'gender',
        (v) => $enumDecodeNullable(
          _$GenderEnumMap,
          v,
          unknownValue: Gender.unknown,
        ),
      ),
      address: $checkedConvert('address', (v) => v as String?),
      branch: $checkedConvert(
        'branch',
        (v) => v == null ? null : Branch.fromJson(v as Map<String, dynamic>),
      ),
      roles: $checkedConvert(
        'roles',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => CrewRole.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
      verificationStatus: $checkedConvert(
        'verification_status',
        (v) =>
            $enumDecodeNullable(
              _$VerificationStatusEnumMap,
              v,
              unknownValue: VerificationStatus.unknown,
            ) ??
            VerificationStatus.unknown,
      ),
      verificationNote: $checkedConvert(
        'verification_note',
        (v) => v as String?,
      ),
      submittedAt: $checkedConvert(
        'submitted_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      reviewedAt: $checkedConvert(
        'reviewed_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      memberSince: $checkedConvert(
        'member_since',
        (v) => _$JsonConverterFromJson<String, DateTime>(
          v,
          const DateOnlyConverter().fromJson,
        ),
      ),
      permissions: $checkedConvert(
        'permissions',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toSet() ?? const {},
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'avatarUrl': 'avatar_url',
    'dateOfBirth': 'date_of_birth',
    'verificationStatus': 'verification_status',
    'verificationNote': 'verification_note',
    'submittedAt': 'submitted_at',
    'reviewedAt': 'reviewed_at',
    'memberSince': 'member_since',
  },
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'avatar_url': instance.avatarUrl,
  'date_of_birth': _$JsonConverterToJson<String, DateTime>(
    instance.dateOfBirth,
    const DateOnlyConverter().toJson,
  ),
  'gender': _$GenderEnumMap[instance.gender],
  'address': instance.address,
  'branch': instance.branch?.toJson(),
  'roles': instance.roles.map((e) => e.toJson()).toList(),
  'verification_status':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'verification_note': instance.verificationNote,
  'submitted_at': instance.submittedAt?.toIso8601String(),
  'reviewed_at': instance.reviewedAt?.toIso8601String(),
  'member_since': _$JsonConverterToJson<String, DateTime>(
    instance.memberSince,
    const DateOnlyConverter().toJson,
  ),
  'permissions': instance.permissions.toList(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.unknown: 'unknown',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.approved: 'approved',
  VerificationStatus.rejected: 'rejected',
  VerificationStatus.unknown: 'unknown',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
