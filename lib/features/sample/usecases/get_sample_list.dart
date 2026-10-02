import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../../../core/usecase/usecase.dart';
import '../models/sample_item.dart';
import '../repositories/sample_repository.dart';

class GetSampleListParams {
  const GetSampleListParams({required this.page, this.perPage = 20, this.search});

  final int page;
  final int perPage;

  /// `null` or blank means "no filter".
  final String? search;
}

class GetSampleList
    implements UseCase<Result<Paginated<SampleItem>>, GetSampleListParams> {
  const GetSampleList(this._repository);

  final SampleRepository _repository;

  @override
  Future<Result<Paginated<SampleItem>>> call(GetSampleListParams params) {
    final search = params.search?.trim();
    return _repository.getList(
      page: params.page,
      perPage: params.perPage,
      search: (search == null || search.isEmpty) ? null : search,
    );
  }
}
