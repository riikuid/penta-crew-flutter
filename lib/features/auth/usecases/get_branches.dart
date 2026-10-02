import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/branch.dart';
import '../repositories/auth_repository.dart';

class GetBranches implements UseCase<Result<List<Branch>>, NoParams> {
  const GetBranches(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<List<Branch>>> call(NoParams params) =>
      _repository.getBranches();
}
