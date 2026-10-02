import 'package:dio/dio.dart';

import '../../../core/network/api_json.dart';
import '../../../core/network/dio_call.dart';
import '../../../core/network/paginated.dart';
import '../../../core/network/result.dart';
import '../models/sample_item.dart';

/// Pure HTTP. One method per endpoint, no side effects.
class SampleRepository {
  const SampleRepository(this._dio);

  final Dio _dio;

  Future<Result<Paginated<SampleItem>>> getList({
    required int page,
    int perPage = 20,
    String? search,
  }) => dioCall(
    () => _dio.get(
      '/samples',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'search': ?search,
      },
    ),
    parse: (body) => Paginated.fromJson(body, SampleItem.fromJson),
  );

  Future<Result<SampleItem>> getDetail(int id) => dioCall(
    () => _dio.get('/samples/$id'),
    parse: (body) => SampleItem.fromJson(asObject(body)),
  );
}
