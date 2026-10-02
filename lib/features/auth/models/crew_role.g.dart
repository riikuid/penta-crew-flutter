// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CrewRole _$CrewRoleFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_CrewRole', json, ($checkedConvert) {
      final val = _CrewRole(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CrewRoleToJson(_CrewRole instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
