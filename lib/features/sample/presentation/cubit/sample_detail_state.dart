import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/sample_item.dart';

part 'sample_detail_state.freezed.dart';

/// Template for any single-resource page.
@freezed
sealed class SampleDetailState with _$SampleDetailState {
  const factory SampleDetailState.initial() = SampleDetailInitial;
  const factory SampleDetailState.loading() = SampleDetailLoading;
  const factory SampleDetailState.loaded(SampleItem item) = SampleDetailLoaded;
  const factory SampleDetailState.error(String message) = SampleDetailError;
}
