import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class UploadAvatarParams {
  const UploadAvatarParams({required this.filePath});

  /// Local path of the picked image (jpg/png ≤ 5 MB, contract §2.9).
  final String filePath;
}

/// Returns the new `avatar_url`.
class UploadAvatar implements UseCase<Result<String>, UploadAvatarParams> {
  const UploadAvatar(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<String>> call(UploadAvatarParams params) =>
      _repository.uploadAvatar(params.filePath);
}
