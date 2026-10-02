import '../../../core/network/result.dart';
import '../../../core/push/push_service.dart';
import '../../../core/session/session_storage.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// Best-effort server logout, then always clear the local session — the user
/// must be able to sign out while offline.
class Logout implements UseCase<Result<void>, NoParams> {
  const Logout(this._repository, this._storage, this._push);

  final AuthRepository _repository;
  final SessionStorage _storage;
  final PushService _push;

  @override
  Future<Result<void>> call(NoParams params) async {
    final result = await _repository.logout();
    await _storage.clear();
    await _push.deleteToken();
    return result;
  }
}
