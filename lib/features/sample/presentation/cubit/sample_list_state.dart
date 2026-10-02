import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/sample_item.dart';

part 'sample_list_state.freezed.dart';

/// Template for any paginated list.
///
/// `error` may carry the data that was on screen when the failure happened
/// (refresh / load-more failed): the UI keeps the list and shows a toast.
/// With empty `data` it is a full-screen error with retry.
@freezed
sealed class SampleListState with _$SampleListState {
  const factory SampleListState.initial() = SampleListInitial;
  const factory SampleListState.loading() = SampleListLoading;
  const factory SampleListState.loaded({
    required List<SampleItem> data,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    @Default(1) int page,
    String? search,
  }) = SampleListLoaded;
  const factory SampleListState.error({
    required String message,
    @Default([]) List<SampleItem> data,
  }) = SampleListError;
}
