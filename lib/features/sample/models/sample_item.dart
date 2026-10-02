import 'package:freezed_annotation/freezed_annotation.dart';

import 'sample_category.dart';

part 'sample_item.freezed.dart';
part 'sample_item.g.dart';

/// `GET /samples/{id}` payload. Keys are snake_case on the wire
/// (`created_at`) — `build.yaml` handles the rename globally.
@freezed
abstract class SampleItem with _$SampleItem {
  const factory SampleItem({
    required int id,
    required String title,
    String? description,
    DateTime? createdAt,
    SampleCategory? category,
  }) = _SampleItem;

  factory SampleItem.fromJson(Map<String, dynamic> json) =>
      _$SampleItemFromJson(json);
}
