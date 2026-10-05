import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../usecases/get_notifications.dart';
import '../../usecases/mark_all_notifications_read.dart';
import '../../usecases/mark_notification_read.dart';
import 'notifications_state.dart';
import 'unread_count_cubit.dart';

/// N1 Notifications list. Page-scoped: provided by the route, closed when the
/// page is popped.
///
/// Same lifecycle as `SampleListCubit` / `TrackedCubit`: [load] with
/// skeletons, silent [refresh] (list stays visible, toast on failure),
/// [loadMore] appending the next page. [markRead] and [markAllRead] are
/// optimistic — the local state changes first and a failed `POST` is ignored
/// (both endpoints are idempotent, contract §6.3/§6.4; the next load resyncs).
///
/// Every change to the count is mirrored into the app-scoped
/// [UnreadCountCubit] so the Home bell dot stays right without a refetch.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required this._getNotifications,
    required this._markNotificationRead,
    required this._markAllNotificationsRead,
    required this._unreadCount,
  }) : super(const NotificationsState.initial());

  final GetNotifications _getNotifications;
  final MarkNotificationRead _markNotificationRead;
  final MarkAllNotificationsRead _markAllNotificationsRead;
  final UnreadCountCubit _unreadCount;

  /// Bumped by every first-page load; a load-more response whose sequence is
  /// stale (a load/refresh started after it) is discarded.
  int _sequence = 0;

  Future<void> load() => _loadFirstPage(showLoading: true);

  Future<void> refresh() =>
      _loadFirstPage(showLoading: state is! NotificationsLoaded);

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationsLoaded ||
        current.isLoadingMore ||
        current.hasReachedMax) {
      return;
    }

    final sequence = _sequence;
    emit(current.copyWith(isLoadingMore: true));

    final result = await _getNotifications(
      GetNotificationsParams(page: current.page + 1),
    );
    if (isClosed || sequence != _sequence) return;

    switch (result) {
      case Success(:final value):
        emit(
          current.copyWith(
            data: [...current.data, ...value.data],
            page: value.currentPage,
            hasReachedMax: !value.hasMore || value.isEmpty,
            isLoadingMore: false,
          ),
        );
      case Failed(:final message):
        emit(NotificationsState.error(message: message, data: current.data));
        emit(current.copyWith(isLoadingMore: false));
    }
  }

  /// Marks one row read locally (and decrements the count), then tells the
  /// server. No-op for unknown or already-read ids.
  Future<void> markRead(int id) async {
    final current = state;
    if (current is! NotificationsLoaded) return;
    final index = current.data.indexWhere(
      (notification) => notification.id == id,
    );
    if (index == -1 || current.data[index].isRead) return;

    final updated = [...current.data];
    updated[index] = updated[index].copyWith(readAt: DateTime.now());
    emit(
      current.copyWith(
        data: updated,
        unreadCount: max(0, current.unreadCount - 1),
      ),
    );
    _unreadCount.decrement();

    await _markNotificationRead(id);
  }

  /// Marks every loaded row read and zeroes the count, then tells the server.
  Future<void> markAllRead() async {
    final current = state;
    if (current is! NotificationsLoaded || current.unreadCount == 0) return;

    final readAt = DateTime.now();
    emit(
      current.copyWith(
        data: [
          for (final notification in current.data)
            notification.isRead
                ? notification
                : notification.copyWith(readAt: readAt),
        ],
        unreadCount: 0,
      ),
    );
    _unreadCount.clear();

    await _markAllNotificationsRead(const NoParams());
  }

  Future<void> _loadFirstPage({required bool showLoading}) async {
    final sequence = ++_sequence;
    final previous = state;
    if (showLoading) emit(const NotificationsState.loading());

    final result = await _getNotifications(
      const GetNotificationsParams(page: 1),
    );
    if (isClosed || sequence != _sequence) return;

    switch (result) {
      case Success(:final value):
        final unreadCount = _unreadCountOf(value.meta['unread_count']);
        _unreadCount.set(unreadCount);
        emit(
          NotificationsState.loaded(
            data: value.data,
            unreadCount: unreadCount,
            page: value.currentPage,
            hasReachedMax: !value.hasMore,
          ),
        );
      case Failed(:final message):
        if (previous is NotificationsLoaded && !showLoading) {
          // Silent refresh failed: toast, then restore what was on screen.
          emit(NotificationsState.error(message: message, data: previous.data));
          emit(previous.copyWith(isLoadingMore: false));
        } else {
          emit(NotificationsState.error(message: message));
        }
    }
  }

  /// `meta.unread_count`, tolerant of a missing or stringly-typed value.
  static int _unreadCountOf(Object? raw) => switch (raw) {
    final int count => count,
    final num count => count.toInt(),
    final String count => int.tryParse(count) ?? 0,
    _ => 0,
  };
}
