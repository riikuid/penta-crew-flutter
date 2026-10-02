import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/sample_item.dart';
import '../repositories/sample_repository.dart';

/// Single primitive input → no params class needed.
class GetSampleDetail implements UseCase<Result<SampleItem>, int> {
  const GetSampleDetail(this._repository);

  final SampleRepository _repository;

  @override
  Future<Result<SampleItem>> call(int id) => _repository.getDetail(id);
}
