import '../../../core/network/result.dart';
import '../../../core/push/push_service.dart';
import '../../../core/session/session_storage.dart';
import '../../../core/usecase/usecase.dart';
import '../models/auth_response.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  const RegisterParams({
    required this.email,
    required this.password,
    required this.profile,
  });

  final String email;
  final String password;
  final ProfileFields profile;
}

/// Register = call API → persist token, exactly like [Login]: the user is
/// signed in right away and the router sends them to `/verification` (D-01).
class Register implements UseCase<Result<AuthResponse>, RegisterParams> {
  const Register(this._repository, this._storage, this._push);

  final AuthRepository _repository;
  final SessionStorage _storage;
  final PushService _push;

  @override
  Future<Result<AuthResponse>> call(RegisterParams params) async {
    final deviceToken = await _push.getToken();

    final result = await _repository.register(
      email: params.email,
      password: params.password,
      profile: params.profile,
      deviceToken: deviceToken,
    );

    if (result case Success(:final value)) {
      await _storage.saveToken(value.token);
    }
    return result;
  }
}
