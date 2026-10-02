import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../usecases/login.dart';
import 'auth_cubit.dart';
import 'login_state.dart';

/// Page-scoped: provided by the login route, closed when the page is popped.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login, this._auth) : super(const LoginState.idle());

  final Login _login;
  final AuthCubit _auth;

  Future<void> submit({required String email, required String password}) async {
    if (state is LoginSubmitting) return;
    emit(const LoginState.submitting());

    switch (await _login(LoginParams(email: email, password: password))) {
      case Success(:final value):
        _auth.setAuthenticated(value.user);
        emit(const LoginState.success());
      case Failed(:final message, :final fieldErrors):
        emit(LoginState.failure(message: message, fieldErrors: fieldErrors ?? {}));
    }
  }
}
