import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../usecases/get_unread_count.dart';

/// Unread-notification count behind the Home bell dot. App-scoped singleton
/// (see `notifications_di.dart`): the list cubit keeps it in sync locally
/// (`set` from `meta.unread_count`, `decrement` on mark-read, `clear` on
/// mark-all) and `UnreadDot` refetches it when Home shows and on app resume.
class UnreadCountCubit extends Cubit<int> {
  UnreadCountCubit({required this._getUnreadCount}) : super(0);

  final GetUnreadCount _getUnreadCount;

  /// `GET /notifications/unread-count`. A failure keeps the current value —
  /// the dot is a hint, not a feature, so no toast and no log.
  Future<void> fetch() async {
    final result = await _getUnreadCount(const NoParams());
    if (isClosed) return;
    if (result case Success(:final value)) set(value);
  }

  void set(int count) => emit(max(0, count));

  void decrement() => emit(max(0, state - 1));

  void clear() => emit(0);
}
