import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../usecases/get_sample_detail.dart';
import 'sample_detail_state.dart';

/// Page-scoped: provided by the detail route, closed when the page is popped.
class SampleDetailCubit extends Cubit<SampleDetailState> {
  SampleDetailCubit(this._getDetail) : super(const SampleDetailState.initial());

  final GetSampleDetail _getDetail;

  int? _id;

  Future<void> fetch(int id) async {
    _id = id;
    emit(const SampleDetailState.loading());

    final result = await _getDetail(id);
    if (isClosed || _id != id) return;

    switch (result) {
      case Success(:final value):
        emit(SampleDetailState.loaded(value));
      case Failed(:final message):
        emit(SampleDetailState.error(message));
    }
  }

  Future<void> retry() async {
    final id = _id;
    if (id != null) await fetch(id);
  }
}
