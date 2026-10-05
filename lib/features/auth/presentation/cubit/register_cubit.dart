import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../models/branch.dart';
import '../../models/user.dart';
import '../../repositories/auth_repository.dart';
import '../../usecases/get_branches.dart';
import '../../usecases/register.dart';
import '../form_validators.dart';
import 'auth_cubit.dart';
import 'register_state.dart';

/// Page-scoped two-step registration (A4 → A5). Validates each step locally
/// with the copy-table messages, then maps a 422 `errors` body back onto the
/// step that owns the failing field.
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._register, this._getBranches, this._auth)
    : super(const RegisterState());

  final Register _register;
  final GetBranches _getBranches;
  final AuthCubit _auth;

  // --- Step 01 ---------------------------------------------------------------

  /// Validates account details; on success stores them and moves to A5.
  void submitAccountStep({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) {
    final errors = <String, String>{
      if (name.trim().isEmpty) RegisterField.name: 'Enter your full name.',
      if (!FormValidators.isEmail(email))
        RegisterField.email: 'Enter a valid email address.',
      if (phone.trim().isEmpty)
        RegisterField.phone: 'Enter your phone number.',
      if (!FormValidators.isStrongPassword(password))
        RegisterField.password: 'Use at least 8 characters with a number.',
      if (confirmPassword != password)
        RegisterField.passwordConfirmation: "Passwords don't match.",
    };

    emit(
      state.copyWith(
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
        password: password,
        errors: errors,
        step: errors.isEmpty ? RegisterStep.profile : RegisterStep.account,
      ),
    );
  }

  /// Back from A5 — values stay, only the step changes.
  void backToAccountStep() =>
      emit(state.copyWith(step: RegisterStep.account));

  /// Called when the user edits a field, so a stale error does not linger.
  void clearError(String field) {
    if (!state.errors.containsKey(field)) return;
    emit(state.copyWith(errors: {...state.errors}..remove(field)));
  }

  // --- Step 02 ---------------------------------------------------------------

  void setDateOfBirth(DateTime value) => emit(
    state.copyWith(
      dateOfBirth: value,
      errors: {...state.errors}..remove(RegisterField.dateOfBirth),
    ),
  );

  void setGender(Gender value) => emit(
    state.copyWith(
      gender: value,
      errors: {...state.errors}..remove(RegisterField.gender),
    ),
  );

  void setBranch(Branch value) => emit(
    state.copyWith(
      branch: value,
      errors: {...state.errors}..remove(RegisterField.branchId),
    ),
  );

  /// `GET /branches` for the picker. Safe to call repeatedly: a loaded list
  /// is kept, a failure can be retried.
  Future<void> loadBranches() async {
    if (state.branchesLoading || state.branches.isNotEmpty) return;
    emit(state.copyWith(branchesLoading: true, branchesError: null));

    final result = await _getBranches(const NoParams());
    if (isClosed) return;

    switch (result) {
      case Success(:final value):
        emit(state.copyWith(branches: value, branchesLoading: false));
      case Failed(:final message):
        emit(state.copyWith(branchesLoading: false, branchesError: message));
    }
  }

  /// "Submit for review": validates A5, then `POST /register`.
  Future<void> submit({required String address}) async {
    if (state.isSubmitting) return;

    final errors = <String, String>{
      if (state.dateOfBirth == null)
        RegisterField.dateOfBirth: 'Enter your date of birth.',
      if (state.gender == null) RegisterField.gender: 'Select your gender.',
      if (state.branch == null) RegisterField.branchId: 'Select your branch.',
      if (address.trim().isEmpty)
        RegisterField.address: 'Enter your home address.',
    };
    if (errors.isNotEmpty) {
      emit(state.copyWith(address: address.trim(), errors: errors));
      return;
    }

    emit(
      state.copyWith(
        address: address.trim(),
        errors: const {},
        status: RegisterStatus.submitting,
        failureMessage: null,
      ),
    );

    final result = await _register(
      RegisterParams(
        email: state.email,
        password: state.password,
        profile: ProfileFields(
          name: state.name,
          phone: state.phone,
          dateOfBirth: state.dateOfBirth!,
          gender: state.gender!,
          branchId: state.branch!.id,
          address: state.address,
        ),
      ),
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final value):
        _auth.setAuthenticated(value.user);
        emit(state.copyWith(status: RegisterStatus.success));
      case Failed(:final fieldErrors)
          when fieldErrors != null && fieldErrors.isNotEmpty:
        emit(_withServerErrors(fieldErrors));
      case Failed(:final message):
        emit(
          state.copyWith(
            status: RegisterStatus.failure,
            failureMessage: message,
          ),
        );
    }
  }

  /// First message per field; jump back to A4 when any of its fields failed.
  RegisterState _withServerErrors(Map<String, List<String>> fieldErrors) {
    final errors = {
      for (final entry in fieldErrors.entries)
        if (entry.value.isNotEmpty) entry.key: entry.value.first,
    };
    final ownedByAccountStep = errors.keys.any(
      RegisterField.accountStep.contains,
    );
    return state.copyWith(
      status: RegisterStatus.editing,
      errors: errors,
      step: ownedByAccountStep ? RegisterStep.account : RegisterStep.profile,
    );
  }
}
