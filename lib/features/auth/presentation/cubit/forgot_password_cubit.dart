import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../usecases/forgot_password.dart';
import 'forgot_password_state.dart';

/// A2b. `POST /forgot-password` always answers 200 (contract §2.5), so the
/// only failure here is transport.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._forgotPassword)
    : super(const ForgotPasswordState.idle());

  final ForgotPassword _forgotPassword;

  Future<void> submit(String email) async {
    if (state is ForgotPasswordSubmitting) return;
    emit(const ForgotPasswordState.submitting());

    final trimmed = email.trim();
    switch (await _forgotPassword(ForgotPasswordParams(email: trimmed))) {
      case Success():
        emit(ForgotPasswordState.sent(trimmed));
      case Failed(:final message):
        emit(ForgotPasswordState.failure(message));
    }
  }
}
