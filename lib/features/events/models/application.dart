import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/models/crew_role.dart';
import 'event.dart';

part 'application.freezed.dart';
part 'application.g.dart';

/// Lifecycle of an application (D-04). `withdrawn` is kept server-side for
/// audit but never listed in Tracked / counters / History.
enum ApplicationStatus {
  @JsonValue('waiting')
  waiting,
  @JsonValue('selected')
  selected,
  @JsonValue('not_selected')
  notSelected,
  @JsonValue('withdrawn')
  withdrawn,
  unknown,
}

/// The position an application refers to — the one the user picked
/// (`applied_position`) or the one the admin placed them in
/// (`assigned_position`, D-09).
@freezed
abstract class ApplicationPosition with _$ApplicationPosition {
  const factory ApplicationPosition({required int id, required CrewRole role}) =
      _ApplicationPosition;

  factory ApplicationPosition.fromJson(Map<String, dynamic> json) =>
      _$ApplicationPositionFromJson(json);
}

/// One application of the current user to one event (contract §1).
/// `event` is present in Tracked / Schedule lists and may be omitted when the
/// application is nested in `EventDetail.myApplication`.
@freezed
abstract class Application with _$Application {
  const Application._();

  const factory Application({
    required int id,
    @JsonKey(unknownEnumValue: ApplicationStatus.unknown)
    required ApplicationStatus status,
    required ApplicationPosition appliedPosition,
    ApplicationPosition? assignedPosition,
    required DateTime appliedAt,
    required DateTime closesAt,
    DateTime? decidedAt,
    Event? event,
  }) = _Application;

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);

  /// The position that matters for display: the admin's placement when
  /// selected, otherwise what the user applied for.
  ApplicationPosition get position => assignedPosition ?? appliedPosition;

  bool get isWaiting => status == ApplicationStatus.waiting;
  bool get isSelected => status == ApplicationStatus.selected;
  bool get isNotSelected => status == ApplicationStatus.notSelected;

  /// Withdraw is allowed only while waiting and before the deadline (C6).
  bool canWithdrawAt(DateTime now) => isWaiting && now.isBefore(closesAt);
}
