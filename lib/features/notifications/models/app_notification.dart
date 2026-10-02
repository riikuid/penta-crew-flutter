import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// The six in-app/push notification types of v1 (D-06, contract §6).
enum NotificationType {
  @JsonValue('verification.approved')
  verificationApproved,
  @JsonValue('verification.rejected')
  verificationRejected,
  @JsonValue('event.published')
  eventPublished,
  @JsonValue('application.submitted')
  applicationSubmitted,
  @JsonValue('application.selected')
  applicationSelected,
  @JsonValue('application.not_selected')
  applicationNotSelected,
  unknown,
}

/// One row of `GET /notifications`. Named `AppNotification` to avoid clashing
/// with Flutter's `Notification`.
@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    required int id,
    @JsonKey(unknownEnumValue: NotificationType.unknown)
    required NotificationType type,
    required String title,
    required String body,
    @Default({}) Map<String, dynamic> data,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  bool get isRead => readAt != null;

  /// `data.event_id` / `data.application_id`, tolerant of string values
  /// (FCM data payloads are always strings).
  int? get eventId => _intOf(data['event_id']);
  int? get applicationId => _intOf(data['application_id']);
}

int? _intOf(Object? v) => switch (v) {
  final int i => i,
  final num n => n.toInt(),
  final String s => int.tryParse(s),
  _ => null,
};
