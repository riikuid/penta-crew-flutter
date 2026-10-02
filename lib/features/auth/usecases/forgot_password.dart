import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordParams {
  const ForgotPasswordParams({required this.email});

  final String email;
}

class ForgotPassword implements UseCase<Result<void>, ForgotPasswordParams> {
  const ForgotPassword(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(ForgotPasswordParams params) =>
      _repository.forgotPassword(params.email.trim());
}
