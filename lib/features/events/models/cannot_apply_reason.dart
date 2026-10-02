import 'package:freezed_annotation/freezed_annotation.dart';

/// Why `EventDetail.canApply` is false (contract §1). Drives the disabled CTA
/// copy on C3; the message itself is composed by the screen.
enum CannotApplyReason {
  @JsonValue('closed')
  closed,
  @JsonValue('already_applied')
  alreadyApplied,
  @JsonValue('no_matching_role')
  noMatchingRole,
  @JsonValue('date_conflict')
  dateConflict,
  @JsonValue('not_verified')
  notVerified,
  unknown,
}
