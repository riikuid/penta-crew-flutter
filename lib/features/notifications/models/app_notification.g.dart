// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AppNotification', json, ($checkedConvert) {
      final val = _AppNotification(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(
            _$NotificationTypeEnumMap,
            v,
            unknownValue: NotificationType.unknown,
          ),
        ),
        title: $checkedConvert('title', (v) => v as String),
        body: $checkedConvert('body', (v) => v as String),
        data: $checkedConvert(
          'data',
          (v) => v as Map<String, dynamic>? ?? const {},
        ),
        readAt: $checkedConvert(
          'read_at',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        createdAt: $checkedConvert(
          'created_at',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    }, fieldKeyMap: const {'readAt': 'read_at', 'createdAt': 'created_at'});

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'read_at': instance.readAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.verificationApproved: 'verification.approved',
  NotificationType.verificationRejected: 'verification.rejected',
  NotificationType.eventPublished: 'event.published',
  NotificationType.applicationSubmitted: 'application.submitted',
  NotificationType.applicationSelected: 'application.selected',
  NotificationType.applicationNotSelected: 'application.not_selected',
  NotificationType.unknown: 'unknown',
};
