import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/models/crew_role.dart';

part 'event_position.freezed.dart';
part 'event_position.g.dart';

/// One slot an event is hiring for (contract §1 `Event.positions[]`).
/// `matchesMyRole` is computed by the backend for the current user; positions
/// that do not match are shown locked on C3/C4.
@freezed
abstract class EventPosition with _$EventPosition {
  const factory EventPosition({
    required int id,
    required CrewRole role,
    required int needed,
    @Default(false) bool matchesMyRole,
  }) = _EventPosition;

  factory EventPosition.fromJson(Map<String, dynamic> json) =>
      _$EventPositionFromJson(json);
}
