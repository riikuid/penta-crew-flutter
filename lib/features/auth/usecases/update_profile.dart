import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

/// Returns the fresh `User`; the caller hands it to `AuthCubit.updateUser`.
class UpdateProfile implements UseCase<Result<User>, ProfileFields> {
  const UpdateProfile(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(ProfileFields params) =>
      _repository.updateProfile(params);
}
