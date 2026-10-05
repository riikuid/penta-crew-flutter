import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../auth/usecases/change_password.dart';
import 'change_password_state.dart';

/// Page-scoped cubit behind E3 (`PUT /me/password`, contract §2.8). The
/// session stays valid afterwards — nothing to tell `AuthCubit`.
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._changePassword)
    : super(const ChangePasswordState());

  final ChangePassword _changePassword;

  /// Typing clears the server error on the current password, so the row
  /// stops shouting as soon as the user starts fixing it.
  void currentPasswordChanged(String value) => emit(
    state.copyWith(
      currentPassword: value,
      status: ChangePasswordStatus.idle,
      fieldErrors: const {},
    ),
  );

  void passwordChanged(String value) =>
      emit(state.copyWith(password: value, status: ChangePasswordStatus.idle));

  void confirmationChanged(String value) => emit(
    state.copyWith(confirmation: value, status: ChangePasswordStatus.idle),
  );

  Future<void> submit() async {
    if (state.submitting || !state.canSubmit) return;
    emit(
      state.copyWith(
        status: ChangePasswordStatus.submitting,
        message: null,
        fieldErrors: const {},
      ),
    );

    final result = await _changePassword(
      ChangePasswordParams(
        currentPassword: state.currentPassword,
        password: state.password,
      ),
    );
    switch (result) {
      case Success():
        emit(state.copyWith(status: ChangePasswordStatus.success));
      case Failed(:final message, :final fieldErrors):
        emit(
          state.copyWith(
            status: ChangePasswordStatus.failure,
            message: message,
            fieldErrors: fieldErrors ?? const {},
          ),
        );
    }
  }
}
