// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Event',
  json,
  ($checkedConvert) {
    final val = _Event(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      title: $checkedConvert('title', (v) => v as String),
      date: $checkedConvert(
        'date',
        (v) => const DateOnlyConverter().fromJson(v as String),
      ),
      startTime: $checkedConvert('start_time', (v) => v as String),
      endTime: $checkedConvert('end_time', (v) => v as String),
      durationHours: $checkedConvert(
        'duration_hours',
        (v) => (v as num?)?.toInt(),
      ),
      venueName: $checkedConvert('venue_name', (v) => v as String),
      branch: $checkedConvert(
        'branch',
        (v) => v == null ? null : Branch.fromJson(v as Map<String, dynamic>),
      ),
      applyDeadline: $checkedConvert(
        'apply_deadline',
        (v) => DateTime.parse(v as String),
      ),
      isUrgent: $checkedConvert('is_urgent', (v) => v as bool? ?? false),
      positions: $checkedConvert(
        'positions',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => EventPosition.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'startTime': 'start_time',
    'endTime': 'end_time',
    'durationHours': 'duration_hours',
    'venueName': 'venue_name',
    'applyDeadline': 'apply_deadline',
    'isUrgent': 'is_urgent',
  },
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'date': const DateOnlyConverter().toJson(instance.date),
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'duration_hours': instance.durationHours,
  'venue_name': instance.venueName,
  'branch': instance.branch?.toJson(),
  'apply_deadline': instance.applyDeadline.toIso8601String(),
  'is_urgent': instance.isUrgent,
  'positions': instance.positions.map((e) => e.toJson()).toList(),
};
