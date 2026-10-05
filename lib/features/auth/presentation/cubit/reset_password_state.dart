import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

@freezed
sealed class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState.idle() = ResetPasswordIdle;
  const factory ResetPasswordState.submitting() = ResetPasswordSubmitting;

  /// Password changed; the screen toasts and `go`es to Sign in.
  const factory ResetPasswordState.success() = ResetPasswordSuccess;

  /// `token_expired` / `token_invalid` (contract §2.6) or no token at all:
  /// the "This link has expired." state with a "Request new link" CTA.
  const factory ResetPasswordState.expired() = ResetPasswordExpired;

  /// Anything else: toast the server message, keep the form.
  const factory ResetPasswordState.failure(String message) =
      ResetPasswordFailure;
}
