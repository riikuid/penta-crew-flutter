import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

enum ChangePasswordStatus { idle, submitting, success, failure }

/// E3. Holds the three inputs so the rule checklist can be derived here and
/// unit-tested; [status] drives the busy button, the toast and the pop.
@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const ChangePasswordState._();

  const factory ChangePasswordState({
    @Default('') String currentPassword,
    @Default('') String password,
    @Default('') String confirmation,
    @Default(ChangePasswordStatus.idle) ChangePasswordStatus status,

    /// Server `message` of the last failure (toasted when [fieldErrors] is
    /// empty).
    String? message,

    /// 422 `errors` — `current_password` is shown under its field.
    @Default({}) Map<String, List<String>> fieldErrors,
  }) = _ChangePasswordState;

  /// Contract §2 password policy: at least 8 characters…
  bool get hasMinLength => password.length >= 8;

  /// …with at least one digit.
  bool get hasNumber => password.contains(RegExp(r'\d'));

  bool get matches => password.isNotEmpty && password == confirmation;

  /// "Update password" is enabled only once every rule passes and the
  /// current password has been typed.
  bool get canSubmit =>
      currentPassword.isNotEmpty && hasMinLength && hasNumber && matches;

  bool get submitting => status == ChangePasswordStatus.submitting;
}
