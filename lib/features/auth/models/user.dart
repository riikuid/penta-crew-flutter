import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/json/converters.dart';
import 'branch.dart';
import 'crew_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Outcome of the admin review (D-01). `unknown` is the fallback for a value
/// the app does not know yet and is treated as "not verified".
enum VerificationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  unknown,
}

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  unknown,
}

/// `GET /me` payload — flat, one object for account + crew profile +
/// verification (D-03, contract §1). Everything beyond `id`/`name` is optional
/// so a partial payload (e.g. right after registration) still parses.
@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required int id,
    required String name,
    String? email,
    String? phone,
    String? avatarUrl,
    @DateOnlyConverter() DateTime? dateOfBirth,
    @JsonKey(unknownEnumValue: Gender.unknown) Gender? gender,
    String? address,
    Branch? branch,
    @Default([]) List<CrewRole> roles,
    @JsonKey(unknownEnumValue: VerificationStatus.unknown)
    @Default(VerificationStatus.unknown)
    VerificationStatus verificationStatus,
    String? verificationNote,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    @DateOnlyConverter() DateTime? memberSince,
    @Default({}) Set<String> permissions,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  bool get isVerified => verificationStatus == VerificationStatus.approved;

  /// Two-letter initials for the avatar placeholder (E1: "NP").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
