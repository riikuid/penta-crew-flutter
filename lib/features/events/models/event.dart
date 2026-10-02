import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/json/converters.dart';
import '../../auth/models/branch.dart';
import 'event_position.dart';

part 'event.freezed.dart';
part 'event.g.dart';

/// Event summary used by lists, the Home carousel and Schedule
/// (contract §1 `Event`). Times are wall-clock strings (`HH:mm`) as sent by
/// the backend; the app never converts them.
@freezed
abstract class Event with _$Event {
  const Event._();

  const factory Event({
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
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// Positions the current user is allowed to apply for.
  List<EventPosition> get matchingPositions =>
      positions.where((p) => p.matchesMyRole).toList();

  /// `14:00 – 20:00` as shown on C1/C3.
  String get timeRange => '$startTime – $endTime';
}
