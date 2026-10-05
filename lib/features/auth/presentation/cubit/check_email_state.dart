import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_email_state.freezed.dart';

/// A2c resend control. The link was just sent when the screen opens, so it
/// starts in [CheckEmailCoolingDown] and only becomes [CheckEmailReady] after
/// the 60 s client cooldown (D-02).
@freezed
sealed class CheckEmailState with _$CheckEmailState {
  const factory CheckEmailState.coolingDown(int secondsLeft) =
      CheckEmailCoolingDown;
  const factory CheckEmailState.ready() = CheckEmailReady;
  const factory CheckEmailState.resending() = CheckEmailResending;

  /// One-shot: the screen toasts "Link sent again"; the cooldown restarts
  /// right after.
  const factory CheckEmailState.resent() = CheckEmailResent;

  /// One-shot: toast the message, then back to [CheckEmailReady].
  const factory CheckEmailState.failure(String message) = CheckEmailFailure;
}
