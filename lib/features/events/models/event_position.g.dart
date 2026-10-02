// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventPosition _$EventPositionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_EventPosition', json, ($checkedConvert) {
      final val = _EventPosition(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        role: $checkedConvert(
          'role',
          (v) => CrewRole.fromJson(v as Map<String, dynamic>),
        ),
        needed: $checkedConvert('needed', (v) => (v as num).toInt()),
        matchesMyRole: $checkedConvert(
          'matches_my_role',
          (v) => v as bool? ?? false,
        ),
      );
      return val;
    }, fieldKeyMap: const {'matchesMyRole': 'matches_my_role'});

Map<String, dynamic> _$EventPositionToJson(_EventPosition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role.toJson(),
      'needed': instance.needed,
      'matches_my_role': instance.matchesMyRole,
    };
