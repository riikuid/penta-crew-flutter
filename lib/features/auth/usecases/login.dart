import '../../../core/network/result.dart';
import '../../../core/push/push_service.dart';
import '../../../core/session/session_storage.dart';
import '../../../core/usecase/usecase.dart';
import '../models/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}

/// Login = call API → persist token. Device token is attached when a push
/// provider is installed (`NoopPushService` returns null).
class Login implements UseCase<Result<AuthResponse>, LoginParams> {
  const Login(this._repository, this._storage, this._push);

  final AuthRepository _repository;
  final SessionStorage _storage;
  final PushService _push;

  @override
  Future<Result<AuthResponse>> call(LoginParams params) async {
    final deviceToken = await _push.getToken();

    final result = await _repository.login(
      email: params.email,
      password: params.password,
      deviceToken: deviceToken,
    );

    if (result case Success(:final value)) {
      await _storage.saveToken(value.token);
    }
    return result;
  }
}
