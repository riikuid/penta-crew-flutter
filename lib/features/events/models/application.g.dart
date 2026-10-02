// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplicationPosition _$ApplicationPositionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ApplicationPosition', json, ($checkedConvert) {
      final val = _ApplicationPosition(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        role: $checkedConvert(
          'role',
          (v) => CrewRole.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ApplicationPositionToJson(
  _ApplicationPosition instance,
) => <String, dynamic>{'id': instance.id, 'role': instance.role.toJson()};

_Application _$ApplicationFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Application',
  json,
  ($checkedConvert) {
    final val = _Application(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      status: $checkedConvert(
        'status',
        (v) => $enumDecode(
          _$ApplicationStatusEnumMap,
          v,
          unknownValue: ApplicationStatus.unknown,
        ),
      ),
      appliedPosition: $checkedConvert(
        'applied_position',
        (v) => ApplicationPosition.fromJson(v as Map<String, dynamic>),
      ),
      assignedPosition: $checkedConvert(
        'assigned_position',
        (v) => v == null
            ? null
            : ApplicationPosition.fromJson(v as Map<String, dynamic>),
      ),
      appliedAt: $checkedConvert(
        'applied_at',
        (v) => DateTime.parse(v as String),
      ),
      closesAt: $checkedConvert(
        'closes_at',
        (v) => DateTime.parse(v as String),
      ),
      decidedAt: $checkedConvert(
        'decided_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      event: $checkedConvert(
        'event',
        (v) => v == null ? null : Event.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'appliedPosition': 'applied_position',
    'assignedPosition': 'assigned_position',
    'appliedAt': 'applied_at',
    'closesAt': 'closes_at',
    'decidedAt': 'decided_at',
  },
);

Map<String, dynamic> _$ApplicationToJson(_Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'applied_position': instance.appliedPosition.toJson(),
      'assigned_position': instance.assignedPosition?.toJson(),
      'applied_at': instance.appliedAt.toIso8601String(),
      'closes_at': instance.closesAt.toIso8601String(),
      'decided_at': instance.decidedAt?.toIso8601String(),
      'event': instance.event?.toJson(),
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.waiting: 'waiting',
  ApplicationStatus.selected: 'selected',
  ApplicationStatus.notSelected: 'not_selected',
  ApplicationStatus.withdrawn: 'withdrawn',
  ApplicationStatus.unknown: 'unknown',
};
