import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/json/converters.dart';
import '../../auth/models/branch.dart';
import 'application.dart';
import 'cannot_apply_reason.dart';
import 'event.dart';
import 'event_position.dart';

part 'event_detail.freezed.dart';
part 'event_detail.g.dart';

enum EventStatus {
  @JsonValue('open')
  open,
  @JsonValue('closed')
  closed,
  unknown,
}

/// `GET /events/{id}` payload (contract §1 `EventDetail`) — every `Event`
/// field plus the detail-only ones. Kept as its own class instead of a
/// subtype so freezed stays simple; use [toSummary] when an `Event` is needed.
@freezed
abstract class EventDetail with _$EventDetail {
  const EventDetail._();

  const factory EventDetail({
    required int id,
    required String title,
    @DateOnlyConverter() required DateTime date,
    required String startTime,
    required String endTime,
    int? durationHours,
    required String venueName,
    Branch? branch,
    required DateTime applyDeadline,
    @Default(false) bool isUrgent,
    @Default([]) List<EventPosition> positions,
    String? venueAddress,
    String? briefingTime,
    @Default([]) List<String> requirements,
    String? description,
    String? adminNote,
    @JsonKey(unknownEnumValue: EventStatus.unknown)
    @Default(EventStatus.unknown)
    EventStatus status,
    @Default(false) bool canApply,
    @JsonKey(unknownEnumValue: CannotApplyReason.unknown)
    CannotApplyReason? cannotApplyReason,
    Application? myApplication,
  }) = _EventDetail;

  factory EventDetail.fromJson(Map<String, dynamic> json) =>
      _$EventDetailFromJson(json);

  Event toSummary() => Event(
    id: id,
    title: title,
    date: date,
    startTime: startTime,
    endTime: endTime,
    durationHours: durationHours,
    venueName: venueName,
    branch: branch,
    applyDeadline: applyDeadline,
    isUrgent: isUrgent,
    positions: positions,
  );

  bool get isClosed => status == EventStatus.closed;
  List<EventPosition> get matchingPositions =>
      positions.where((p) => p.matchesMyRole).toList();
  String get timeRange => '$startTime – $endTime';
}
