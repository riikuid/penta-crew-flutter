import 'package:freezed_annotation/freezed_annotation.dart';

part 'sample_category.freezed.dart';
part 'sample_category.g.dart';

/// Nested object example — embedded in [SampleItem] as `category`.
@freezed
abstract class SampleCategory with _$SampleCategory {
  const factory SampleCategory({
    required int id,
    required String name,
  }) = _SampleCategory;

  factory SampleCategory.fromJson(Map<String, dynamic> json) =>
      _$SampleCategoryFromJson(json);
}
