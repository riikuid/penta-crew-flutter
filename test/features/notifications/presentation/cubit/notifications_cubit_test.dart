import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/usecase/usecase.dart';
import 'package:penta_crew/features/notifications/models/app_notification.dart';
import 'package:penta_crew/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:penta_crew/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:penta_crew/features/notifications/presentation/cubit/unread_count_cubit.dart';
import 'package:penta_crew/features/notifications/usecases/get_notifications.dart';
import 'package:penta_crew/features/notifications/usecases/mark_all_notifications_read.dart';
import 'package:penta_crew/features/notifications/usecases/mark_notification_read.dart';

import '../../fixtures.dart';

class _MockGetNotifications extends Mock implements GetNotifications {}

class _MockMarkNotificationRead extends Mock implements MarkNotificationRead {}

class _MockMarkAllNotificationsRead extends Mock
    implements MarkAllNotificationsRead {}

class _MockUnreadCountCubit extends MockCubit<int>
    implements UnreadCountCubit {}

void main() {
  late _MockGetNotifications getNotifications;
  late _MockMarkNotificationRead markNotificationRead;
  late _MockMarkAllNotificationsRead markAllNotificationsRead;
  late _MockUnreadCountCubit unreadCount;

  setUpAll(() {
    registerFallbackValue(const GetNotificationsParams(page: 1));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getNotifications = _MockGetNotifications();
    markNotificationRead = _MockMarkNotificationRead();
    markAllNotificationsRead = _MockMarkAllNotificationsRead();
    unreadCount = _MockUnreadCountCubit();
    when(() => markNotificationRead(any()))
        .thenAnswer((_) async => const Result.success(null));
    when(() => markAllNotificationsRead(any()))
        .thenAnswer((_) async => const Result.success(null));
  });

  void stubPage(int pageNumber, Result<Paginated<AppNotification>> result) {
    when(
      () => getNotifications(
        any(
          that: predicate<GetNotificationsParams>(
            (params) => params.page == pageNumber,
          ),
        ),
      ),
    ).thenAnswer((_) async => result);
  }

  NotificationsCubit buildCubit() => NotificationsCubit(
    getNotifications: getNotifications,
    markNotificationRead: markNotificationRead,
    markAllNotificationsRead: markAllNotificationsRead,
    unreadCount: unreadCount,
  );

  final twoUnread = [notification(), notification(id: 9002)];

  group('load', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'loading → loaded with meta.unread_count',
      build: () {
        stubPage(1, Result.success(page(twoUnread, unreadCount: 5)));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const NotificationsState.loading(),
        isA<NotificationsLoaded>()
            .having((state) => state.data.length, 'data', 2)
            .having((state) => state.unreadCount, 'unreadCount', 5)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true),
      ],
      verify: (_) => verify(() => unreadCount.set(5)).called(1),
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'tolerates a missing unread_count',
      build: () {
        stubPage(
          1,
          Result.success(
            Paginated(data: twoUnread, currentPage: 1, lastPage: 1, total: 2),
          ),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      skip: 1,
      expect: () => [
        isA<NotificationsLoaded>().having(
          (state) => state.unreadCount,
          'unreadCount',
          0,
        ),
      ],
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'loading → error without data on failure',
      build: () {
        stubPage(1, const Result.failed('boom'));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const NotificationsState.loading(),
        const NotificationsState.error(message: 'boom'),
      ],
    );
  });

  group('loadMore', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'appends the next page and keeps the unread count',
      build: () {
        stubPage(
          1,
          Result.success(page([notification()], lastPage: 2, unreadCount: 3)),
        );
        stubPage(
          2,
          Result.success(
            page([notification(id: 9002)], currentPage: 2, lastPage: 2),
          ),
        );
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => [
        isA<NotificationsLoaded>().having(
          (state) => state.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<NotificationsLoaded>()
            .having((state) => state.data.length, 'data', 2)
            .having((state) => state.unreadCount, 'unreadCount', 3)
            .having((state) => state.page, 'page', 2)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true),
      ],
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'is a no-op at the last page',
      build: () {
        stubPage(1, Result.success(page([notification()])));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => <NotificationsState>[],
      verify: (_) => verify(() => getNotifications(any())).called(1),
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'keeps existing data on failure',
      build: () {
        stubPage(1, Result.success(page([notification()], lastPage: 2)));
        stubPage(2, const Result.failed('offline'));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.loadMore();
      },
      skip: 3,
      expect: () => [
        isA<NotificationsError>()
            .having((state) => state.message, 'message', 'offline')
            .having((state) => state.data.length, 'data kept', 1),
        isA<NotificationsLoaded>()
            .having((state) => state.data.length, 'data', 1)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ],
    );
  });

  group('refresh', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'replaces the list silently with the new unread count',
      build: () {
        stubPage(1, Result.success(page(twoUnread)));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        stubPage(1, Result.success(page([], unreadCount: 0)));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        isA<NotificationsLoaded>()
            .having((state) => state.data, 'data', isEmpty)
            .having((state) => state.unreadCount, 'unreadCount', 0),
      ],
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'on failure surfaces error with data, then restores the previous list',
      build: () {
        stubPage(1, Result.success(page(twoUnread)));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        stubPage(1, const Result.failed('offline'));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        isA<NotificationsError>().having(
          (state) => state.data.length,
          'data kept',
          2,
        ),
        isA<NotificationsLoaded>()
            .having((state) => state.data.length, 'data', 2)
            .having((state) => state.unreadCount, 'unreadCount', 2),
      ],
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'from an error state shows the skeleton again',
      build: () {
        stubPage(1, const Result.failed('boom'));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        stubPage(1, Result.success(page(twoUnread)));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        const NotificationsState.loading(),
        isA<NotificationsLoaded>().having(
          (state) => state.data.length,
          'data',
          2,
        ),
      ],
    );
  });

  group('markRead', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'sets readAt locally, decrements the count, then posts',
      build: () {
        stubPage(1, Result.success(page(twoUnread)));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.markRead(9001);
      },
      skip: 2,
      expect: () => [
        isA<NotificationsLoaded>()
            .having((state) => state.data[0].isRead, 'first read', isTrue)
            .having((state) => state.data[1].isRead, 'second unread', isFalse)
            .having((state) => state.unreadCount, 'unreadCount', 1),
      ],
      verify: (_) {
        verify(() => markNotificationRead(9001)).called(1);
        verify(() => unreadCount.decrement()).called(1);
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'keeps the optimistic state when the server call fails',
      build: () {
        stubPage(1, Result.success(page(twoUnread)));
        when(() => markNotificationRead(any()))
            .thenAnswer((_) async => const Result.failed('offline'));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.markRead(9001);
      },
      skip: 2,
      expect: () => [
        isA<NotificationsLoaded>()
            .having((state) => state.data[0].isRead, 'first read', isTrue)
            .having((state) => state.unreadCount, 'unreadCount', 1),
      ],
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'is a no-op for an already-read or unknown id',
      build: () {
        stubPage(
          1,
          Result.success(page([notification(readAt: now)], unreadCount: 0)),
        );
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.markRead(9001);
        await cubit.markRead(404);
      },
      skip: 2,
      expect: () => <NotificationsState>[],
      verify: (_) {
        verifyNever(() => markNotificationRead(any()));
        verifyNever(() => unreadCount.decrement());
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'never goes below zero when the server count was stale',
      build: () {
        stubPage(1, Result.success(page(twoUnread, unreadCount: 0)));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.markRead(9001);
      },
      skip: 2,
      expect: () => [
        isA<NotificationsLoaded>().having(
          (state) => state.unreadCount,
          'unreadCount',
          0,
        ),
      ],
    );
  });

  group('markAllRead', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'sets every readAt, zeroes the count, then posts',
      build: () {
        stubPage(
          1,
          Result.success(
            page([
              ...twoUnread,
              notification(id: 9003, readAt: now),
            ], unreadCount: 7),
          ),
        );
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.markAllRead();
      },
      skip: 2,
      expect: () => [
        isA<NotificationsLoaded>()
            .having(
              (state) =>
                  state.data.every((notification) => notification.isRead),
              'all read',
              isTrue,
            )
            .having((state) => state.data[2].readAt, 'existing readAt', now)
            .having((state) => state.unreadCount, 'unreadCount', 0),
      ],
      verify: (_) {
        verify(() => markAllNotificationsRead(const NoParams())).called(1);
        verify(() => unreadCount.clear()).called(1);
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'is a no-op when nothing is unread',
      build: () {
        stubPage(
          1,
          Result.success(page([notification(readAt: now)], unreadCount: 0)),
        );
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.markAllRead();
      },
      skip: 2,
      expect: () => <NotificationsState>[],
      verify: (_) {
        verifyNever(() => markAllNotificationsRead(any()));
        verifyNever(() => unreadCount.clear());
      },
    );
  });
}
