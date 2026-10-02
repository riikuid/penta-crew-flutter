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
      permissions: $checkedConvert(
        'permissions',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toSet() ?? const {},
      ),
    );
    return val;
  },
  fieldKeyMap: const {'avatarUrl': 'avatar_url'},
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'avatar_url': instance.avatarUrl,
  'permissions': instance.permissions.toList(),
};
