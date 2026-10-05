import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../usecases/forgot_password.dart';
import 'check_email_state.dart';

/// A2c. Owns the 60 s resend cooldown and re-sends through `ForgotPassword`.
class CheckEmailCubit extends Cubit<CheckEmailState> {
  CheckEmailCubit(this._forgotPassword, {required this.email})
    : super(const CheckEmailState.coolingDown(cooldownSeconds)) {
    _startCooldown();
  }

  static const cooldownSeconds = 60;

  final ForgotPassword _forgotPassword;
  final String email;

  Timer? _timer;
  int _secondsLeft = cooldownSeconds;

  Future<void> resend() async {
    if (state is! CheckEmailReady) return;
    emit(const CheckEmailState.resending());

    switch (await _forgotPassword(ForgotPasswordParams(email: email))) {
      case Success():
        if (isClosed) return;
        emit(const CheckEmailState.resent());
        _secondsLeft = cooldownSeconds;
        emit(CheckEmailState.coolingDown(_secondsLeft));
        _startCooldown();
      case Failed(:final message):
        if (isClosed) return;
        emit(CheckEmailState.failure(message));
        emit(const CheckEmailState.ready());
    }
  }

  void _startCooldown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsLeft -= 1;
      if (_secondsLeft <= 0) {
        _timer?.cancel();
        emit(const CheckEmailState.ready());
      } else {
        emit(CheckEmailState.coolingDown(_secondsLeft));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
