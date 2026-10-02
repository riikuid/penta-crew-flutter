import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// Template for any form cubit: idle → submitting → success | failure.
@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.idle() = LoginIdle;
  const factory LoginState.submitting() = LoginSubmitting;
  const factory LoginState.success() = LoginSuccess;
  const factory LoginState.failure({
    required String message,
    @Default({}) Map<String, List<String>> fieldErrors,
  }) = LoginFailure;
}
