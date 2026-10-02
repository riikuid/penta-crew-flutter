import 'package:freezed_annotation/freezed_annotation.dart';

part 'crew_role.freezed.dart';
part 'crew_role.g.dart';

/// Role assigned by an admin during verification (`Crew`, `Event Manager`,
/// `Trainee`). A user may hold several (D-09).
@freezed
abstract class CrewRole with _$CrewRole {
  const factory CrewRole({required int id, required String name}) = _CrewRole;

  factory CrewRole.fromJson(Map<String, dynamic> json) =>
      _$CrewRoleFromJson(json);
}
