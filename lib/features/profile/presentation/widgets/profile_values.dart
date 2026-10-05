import 'package:intl/intl.dart';

import '../../../auth/models/user.dart';

/// Copy helpers for a `User`'s profile fields, shared by E1, E2 and
/// "View my data" (A6a).
abstract final class ProfileValues {
  /// `14 March 2000` — E1 date-of-birth row (no weekday, unlike
  /// `AppDates.long`).
  static String dateOfBirth(DateTime date) =>
      DateFormat('d MMMM yyyy').format(date);

  /// `14 / 03 / 2000` — E2 picker display.
  static String dateOfBirthInput(DateTime date) =>
      DateFormat('dd / MM / yyyy').format(date);

  /// `Female` / `Male`; `null` for an unknown or missing value.
  static String? gender(Gender? gender) => switch (gender) {
    Gender.female => 'Female',
    Gender.male => 'Male',
    _ => null,
  };

  /// `14 March 2000 · Female` — either part alone when the other is missing,
  /// `—` when both are.
  static String dateOfBirthAndGender(User user) {
    final parts = [
      if (user.dateOfBirth != null) dateOfBirth(user.dateOfBirth!),
      ?gender(user.gender),
    ];
    return parts.isEmpty ? '—' : parts.join(' · ');
  }

  /// Any nullable string as a row value.
  static String orDash(String? value) =>
      value == null || value.isEmpty ? '—' : value;
}
