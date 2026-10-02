import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class GetMe implements UseCase<Result<User>, NoParams> {
  const GetMe(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(NoParams params) => _repository.me();
}
