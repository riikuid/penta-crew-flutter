import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
sealed class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState.idle() = ForgotPasswordIdle;
  const factory ForgotPasswordState.submitting() = ForgotPasswordSubmitting;

  /// The request was accepted — always, whether or not the email exists
  /// (D-02). The screen moves on to Check your email.
  const factory ForgotPasswordState.sent(String email) = ForgotPasswordSent;

  /// Network / server failure: toast the message, stay on the form.
  const factory ForgotPasswordState.failure(String message) =
      ForgotPasswordFailure;
}
