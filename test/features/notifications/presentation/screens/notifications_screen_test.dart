import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/widgets/app_card.dart';
import 'package:penta_crew/core/widgets/skeleton.dart';
import 'package:penta_crew/core/widgets/state_views.dart';
import 'package:penta_crew/features/events/events_routes.dart';
import 'package:penta_crew/features/notifications/models/app_notification.dart';
import 'package:penta_crew/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:penta_crew/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:penta_crew/features/notifications/presentation/screens/notifications_screen.dart';

import '../../fixtures.dart';

class _MockNotificationsCubit extends MockCubit<NotificationsState>
    implements NotificationsCubit {}

void main() {
  late _MockNotificationsCubit cubit;

  setUp(() {
    cubit = _MockNotificationsCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.refresh()).thenAnswer((_) async {});
    when(() => cubit.loadMore()).thenAnswer((_) async {});
    when(() => cubit.markRead(any())).thenAnswer((_) async {});
    when(() => cubit.markAllRead()).thenAnswer((_) async {});
  });

  /// The screen at `/` plus a stub event detail route, so a row tap can be
  /// asserted by what ends up on screen (same approach as the Schedule tests).
  Future<void> pumpScreen(
    WidgetTester tester, {
    required NotificationsState state,
  }) async {
    // Tall phone: a few cards are fully built without scrolling.
    tester.view.physicalSize = const Size(480, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    whenListen(
      cubit,
      const Stream<NotificationsState>.empty(),
      initialState: state,
    );
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider<NotificationsCubit>.value(
            value: cubit,
            child: NotificationsScreen(now: now),
          ),
        ),
        GoRoute(
          path: '${EventsRoutes.root}/:id',
          builder: (context, state) =>
              Text('event detail ${state.pathParameters['id']}'),
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    );
    await tester.pump();
  }

  /// The 8 px ink dot a card shows while unread.
  Finder unreadDots() => find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.constraints?.maxWidth == 8 &&
        widget.decoration is BoxDecoration &&
        (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
  );

  testWidgets('loading: skeleton rows, skeleton eyebrow, no action link', (
    tester,
  ) async {
    await pumpScreen(tester, state: const NotificationsState.loading());

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(Skeleton), findsNWidgets(5));
    expect(find.byType(AppCard), findsNothing);
    expect(find.text('Mark all read'), findsNothing);
  });

  testWidgets('empty: N1 copy, All caught up, no action link', (tester) async {
    await pumpScreen(
      tester,
      state: const NotificationsState.loaded(data: [], unreadCount: 0),
    );

    expect(find.text('ALL CAUGHT UP'), findsOneWidget);
    expect(find.text('No notifications yet.'), findsOneWidget);
    expect(
      find.text(
        'Selection results and new events for your roles will show up here.',
      ),
      findsOneWidget,
    );
    expect(find.byType(EmptyView), findsOneWidget);
    expect(find.text('Mark all read'), findsNothing);
  });

  testWidgets('error without data: ErrorView, retry calls load()', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      state: const NotificationsState.error(message: 'Offline'),
    );

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Mark all read'), findsNothing);
    await tester.tap(find.text('Try again'));
    verify(() => cubit.load()).called(1);
  });

  group('loaded', () {
    final items = [
      notification(id: 1),
      notification(
        id: 2,
        title: 'Application sent',
        createdAt: now.subtract(const Duration(hours: 5)),
        readAt: now,
      ),
      notification(
        id: 3,
        title: 'New event for you',
        createdAt: DateTime(2026, 10, 4, 20),
      ),
      notification(
        id: 4,
        title: 'Not selected this time',
        createdAt: DateTime(2026, 9, 25, 9),
        readAt: now,
      ),
    ];

    testWidgets('groups Today / Earlier, dots on unread rows, times', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        state: NotificationsState.loaded(data: items, unreadCount: 2),
      );

      expect(find.text('2 UNREAD'), findsOneWidget);
      expect(find.text('Mark all read'), findsOneWidget);
      expect(find.text('TODAY'), findsOneWidget);
      expect(find.text('EARLIER'), findsOneWidget);
      expect(find.byType(AppCard), findsNWidgets(4));
      expect(find.text("You're selected"), findsOneWidget);
      expect(
        find.text('Arunika annual gathering · 5 Oct · Crew'),
        findsNWidgets(4),
      );
      expect(find.text('2 h ago'), findsOneWidget);
      expect(find.text('5 h ago'), findsOneWidget);
      expect(find.text('Yesterday'), findsOneWidget);
      expect(find.text('25 Sep'), findsOneWidget);
      expect(unreadDots(), findsNWidgets(2));

      // Section order: TODAY header above its rows, EARLIER below them.
      final todayY = tester.getTopLeft(find.text('TODAY')).dy;
      final sentY = tester.getTopLeft(find.text('Application sent')).dy;
      final earlierY = tester.getTopLeft(find.text('EARLIER')).dy;
      final newEventY = tester.getTopLeft(find.text('New event for you')).dy;
      expect(todayY, lessThan(sentY));
      expect(sentY, lessThan(earlierY));
      expect(earlierY, lessThan(newEventY));
    });

    testWidgets('only Earlier when nothing is from today', (tester) async {
      await pumpScreen(
        tester,
        state: NotificationsState.loaded(
          data: items.sublist(2),
          unreadCount: 1,
        ),
      );

      expect(find.text('1 UNREAD'), findsOneWidget);
      expect(find.text('TODAY'), findsNothing);
      expect(find.text('EARLIER'), findsOneWidget);
      expect(find.byType(AppCard), findsNWidgets(2));
    });

    testWidgets('all read: All caught up, link hidden, no dots', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        state: NotificationsState.loaded(
          data: [notification(id: 2, readAt: now)],
          unreadCount: 0,
        ),
      );

      expect(find.text('ALL CAUGHT UP'), findsOneWidget);
      expect(find.text('Mark all read'), findsNothing);
      expect(unreadDots(), findsNothing);
    });

    testWidgets('tapping a row marks it read', (tester) async {
      await pumpScreen(
        tester,
        state: NotificationsState.loaded(data: items, unreadCount: 2),
      );

      await tester.tap(find.text('New event for you'));
      verify(() => cubit.markRead(3)).called(1);
    });

    testWidgets('tapping application.selected opens its event detail', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        state: NotificationsState.loaded(data: items, unreadCount: 2),
      );

      await tester.tap(find.text("You're selected"));
      await tester.pumpAndSettle();

      verify(() => cubit.markRead(1)).called(1);
      expect(find.text('event detail 41'), findsOneWidget);
      expect(find.text('Notifications'), findsNothing);
    });

    testWidgets('tapping an unknown type marks read and stays', (tester) async {
      await pumpScreen(
        tester,
        state: NotificationsState.loaded(
          data: [
            notification(
              id: 7,
              type: NotificationType.unknown,
              title: 'Something new',
              data: const {},
            ),
          ],
          unreadCount: 1,
        ),
      );

      await tester.tap(find.text('Something new'));
      await tester.pumpAndSettle();

      verify(() => cubit.markRead(7)).called(1);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.textContaining('event detail'), findsNothing);
    });

    testWidgets('Mark all read calls markAllRead', (tester) async {
      await pumpScreen(
        tester,
        state: NotificationsState.loaded(data: items, unreadCount: 2),
      );

      await tester.tap(find.text('Mark all read'));
      verify(() => cubit.markAllRead()).called(1);
    });

    testWidgets('loading more shows a spinner under the list', (tester) async {
      await pumpScreen(
        tester,
        state: NotificationsState.loaded(
          data: items,
          unreadCount: 2,
          isLoadingMore: true,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('pull to refresh calls refresh()', (tester) async {
      await pumpScreen(
        tester,
        state: NotificationsState.loaded(data: items, unreadCount: 2),
      );

      await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      verify(() => cubit.refresh()).called(1);
    });
  });
}
