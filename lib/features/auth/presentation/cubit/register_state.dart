import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/branch.dart';
import '../../models/user.dart';

part 'register_state.freezed.dart';

enum RegisterStep {
  /// A4 — account details.
  account,

  /// A5 — crew profile.
  profile,
}

enum RegisterStatus {
  editing,
  submitting,

  /// Non-validation failure; the screen toasts [RegisterState.failureMessage].
  failure,

  /// Registered and signed in; the screen `go`es home.
  success,
}

/// Field keys match the contract's request body (§2.2) so client validation
/// and server `errors` land on the same field.
abstract final class RegisterField {
  static const name = 'name';
  static const email = 'email';
  static const phone = 'phone';
  static const password = 'password';
  static const passwordConfirmation = 'password_confirmation';
  static const dateOfBirth = 'date_of_birth';
  static const gender = 'gender';
  static const branchId = 'branch_id';
  static const address = 'address';

  static const accountStep = {
    name,
    email,
    phone,
    password,
    passwordConfirmation,
  };
}

/// One state object for the whole two-step form: values of both steps live
/// here so "back" from A5 to A4 keeps everything the user typed.
@freezed
abstract class RegisterState with _$RegisterState {
  const RegisterState._();

  const factory RegisterState({
    @Default(RegisterStep.account) RegisterStep step,
    @Default(RegisterStatus.editing) RegisterStatus status,

    // Step 01 — account.
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String password,

    // Step 02 — crew profile.
    DateTime? dateOfBirth,
    Gender? gender,
    Branch? branch,
    @Default('') String address,

    /// First message per field, keyed by [RegisterField].
    @Default({}) Map<String, String> errors,

    /// Branch picker (`GET /branches`), loaded on first open.
    @Default([]) List<Branch> branches,
    @Default(false) bool branchesLoading,
    String? branchesError,

    /// Set together with [RegisterStatus.failure].
    String? failureMessage,
  }) = _RegisterState;

  bool get isSubmitting => status == RegisterStatus.submitting;

  String? errorFor(String field) => errors[field];
}
