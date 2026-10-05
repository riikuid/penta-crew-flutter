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
  int? get eventId => tolerantInt(data['event_id']);
  int? get applicationId => tolerantInt(data['application_id']);
}

/// Reads an int out of a notification `data` value: the REST body sends real
/// ints, an FCM data payload sends the same ids as strings. Shared with
/// `notification_routing.dart` so both paths parse identically.
int? tolerantInt(Object? value) => switch (value) {
  final int integer => integer,
  final num number => number.toInt(),
  final String text => int.tryParse(text),
  _ => null,
};
