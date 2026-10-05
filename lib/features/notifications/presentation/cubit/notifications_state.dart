import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/app_notification.dart';

part 'notifications_state.freezed.dart';

/// N1 Notifications list — `GET /notifications`, `created_at DESC`.
/// [unreadCount] is `meta.unread_count` on the first page, then kept locally
/// in sync by the optimistic mark-read actions.
///
/// `error` may carry the data that was on screen when the failure happened
/// (refresh / load-more failed): the UI keeps the list and shows a toast.
/// With empty `data` it is a full-screen error with retry.
@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = NotificationsInitial;
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.loaded({
    required List<AppNotification> data,
    required int unreadCount,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    @Default(1) int page,
  }) = NotificationsLoaded;
  const factory NotificationsState.error({
    required String message,
    @Default([]) List<AppNotification> data,
  }) = NotificationsError;
}
