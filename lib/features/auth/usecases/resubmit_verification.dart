import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

/// "Submit again" on A7: the screen calls [UpdateProfile] first, then this.
class ResubmitVerification implements UseCase<Result<User>, NoParams> {
  const ResubmitVerification(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(NoParams params) =>
      _repository.resubmitVerification();
}
