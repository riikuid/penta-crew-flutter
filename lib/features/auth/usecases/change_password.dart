import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordParams {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.password,
  });

  final String currentPassword;
  final String password;
}

class ChangePassword implements UseCase<Result<void>, ChangePasswordParams> {
  const ChangePassword(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(ChangePasswordParams params) =>
      _repository.changePassword(
        currentPassword: params.currentPassword,
        password: params.password,
      );
}
