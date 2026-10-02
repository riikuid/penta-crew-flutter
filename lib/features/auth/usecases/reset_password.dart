import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordParams {
  const ResetPasswordParams({
    required this.token,
    required this.email,
    required this.password,
  });

  final String token;
  final String email;
  final String password;
}

/// Failure codes to branch on: `token_expired`, `token_invalid` (§2.6).
class ResetPassword implements UseCase<Result<void>, ResetPasswordParams> {
  const ResetPassword(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(ResetPasswordParams params) =>
      _repository.resetPassword(
        token: params.token,
        email: params.email,
        password: params.password,
      );
}
