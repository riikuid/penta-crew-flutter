import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../usecases/reset_password.dart';
import 'reset_password_state.dart';

/// A2d. [token] and [email] come from the deep link
/// (`/reset-password?token=…&email=…`, D-02); a missing token is treated as
/// expired straight away so the user is offered a new link.
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(
    this._resetPassword, {
    required this.token,
    required this.email,
  }) : super(
         token.isEmpty
             ? const ResetPasswordState.expired()
             : const ResetPasswordState.idle(),
       );

  static const expiredCodes = {'token_expired', 'token_invalid'};

  final ResetPassword _resetPassword;
  final String token;
  final String email;

  Future<void> submit(String password) async {
    if (state is ResetPasswordSubmitting || state is ResetPasswordExpired) {
      return;
    }
    emit(const ResetPasswordState.submitting());

    final result = await _resetPassword(
      ResetPasswordParams(token: token, email: email, password: password),
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const ResetPasswordState.success());
      case Failed(:final code) when expiredCodes.contains(code):
        emit(const ResetPasswordState.expired());
      case Failed(:final message):
        emit(ResetPasswordState.failure(message));
    }
  }
}
