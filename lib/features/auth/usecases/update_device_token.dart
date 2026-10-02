import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class UpdateDeviceTokenParams {
  const UpdateDeviceTokenParams({required this.deviceToken});

  final String deviceToken;
}

/// Called on `PushService.onTokenRefresh` while signed in (D-06).
class UpdateDeviceToken
    implements UseCase<Result<void>, UpdateDeviceTokenParams> {
  const UpdateDeviceToken(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(UpdateDeviceTokenParams params) =>
      _repository.updateDeviceToken(params.deviceToken);
}
