// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventDetail _$EventDetailFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_EventDetail',
  json,
  ($checkedConvert) {
    final val = _EventDetail(
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
      venueAddress: $checkedConvert('venue_address', (v) => v as String?),
      briefingTime: $checkedConvert('briefing_time', (v) => v as String?),
      requirements: $checkedConvert(
        'requirements',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      description: $checkedConvert('description', (v) => v as String?),
      adminNote: $checkedConvert('admin_note', (v) => v as String?),
      status: $checkedConvert(
        'status',
        (v) =>
            $enumDecodeNullable(
              _$EventStatusEnumMap,
              v,
              unknownValue: EventStatus.unknown,
            ) ??
            EventStatus.unknown,
      ),
      canApply: $checkedConvert('can_apply', (v) => v as bool? ?? false),
      cannotApplyReason: $checkedConvert(
        'cannot_apply_reason',
        (v) => $enumDecodeNullable(
          _$CannotApplyReasonEnumMap,
          v,
          unknownValue: CannotApplyReason.unknown,
        ),
      ),
      myApplication: $checkedConvert(
        'my_application',
        (v) =>
            v == null ? null : Application.fromJson(v as Map<String, dynamic>),
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
    'venueAddress': 'venue_address',
    'briefingTime': 'briefing_time',
    'adminNote': 'admin_note',
    'canApply': 'can_apply',
    'cannotApplyReason': 'cannot_apply_reason',
    'myApplication': 'my_application',
  },
);

Map<String, dynamic> _$EventDetailToJson(
  _EventDetail instance,
) => <String, dynamic>{
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
  'venue_address': instance.venueAddress,
  'briefing_time': instance.briefingTime,
  'requirements': instance.requirements,
  'description': instance.description,
  'admin_note': instance.adminNote,
  'status': _$EventStatusEnumMap[instance.status]!,
  'can_apply': instance.canApply,
  'cannot_apply_reason': _$CannotApplyReasonEnumMap[instance.cannotApplyReason],
  'my_application': instance.myApplication?.toJson(),
};

const _$EventStatusEnumMap = {
  EventStatus.open: 'open',
  EventStatus.closed: 'closed',
  EventStatus.unknown: 'unknown',
};

const _$CannotApplyReasonEnumMap = {
  CannotApplyReason.closed: 'closed',
  CannotApplyReason.alreadyApplied: 'already_applied',
  CannotApplyReason.noMatchingRole: 'no_matching_role',
  CannotApplyReason.dateConflict: 'date_conflict',
  CannotApplyReason.notVerified: 'not_verified',
  CannotApplyReason.unknown: 'unknown',
};
