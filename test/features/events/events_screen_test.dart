import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/widgets/skeleton.dart';
import 'package:penta_crew/core/widgets/state_views.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_state.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/presentation/cubit/open_events_cubit.dart';
import 'package:penta_crew/features/events/presentation/cubit/open_events_state.dart';
import 'package:penta_crew/features/events/presentation/cubit/tracked_cubit.dart';
import 'package:penta_crew/features/events/presentation/cubit/tracked_state.dart';
import 'package:penta_crew/features/events/presentation/screens/events_screen.dart';
import 'package:penta_crew/features/events/presentation/widgets/event_card.dart';
import 'package:penta_crew/features/events/presentation/widgets/tracked_card.dart';

import 'fixtures.dart';

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class _MockOpenEventsCubit extends MockCubit<OpenEventsState>
    implements OpenEventsCubit {}

class _MockTrackedCubit extends MockCubit<TrackedState>
    implements TrackedCubit {}

void main() {
  late _MockAuthCubit auth;
  late _MockOpenEventsCubit openCubit;
  late _MockTrackedCubit trackedCubit;

  const user = User(id: 12, name: 'Nadia', branch: jakarta);

  setUp(() {
    auth = _MockAuthCubit();
    whenListen(
      auth,
      const Stream<AuthState>.empty(),
      initialState: const AuthState.authenticated(user),
    );
    when(() => auth.user).thenReturn(user);

    openCubit = _MockOpenEventsCubit();
    trackedCubit = _MockTrackedCubit();
    when(() => openCubit.retry()).thenAnswer((_) async {});
    when(() => openCubit.refresh()).thenAnswer((_) async {});
    when(() => openCubit.loadMore()).thenAnswer((_) async {});
    when(() => openCubit.fetch(search: any(named: 'search')))
        .thenAnswer((_) async {});
    when(() => trackedCubit.retry()).thenAnswer((_) async {});
    when(() => trackedCubit.refresh()).thenAnswer((_) async {});
    when(() => trackedCubit.loadMore()).thenAnswer((_) async {});
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    required OpenEventsState open,
    TrackedState tracked = const TrackedState.loading(),
    EventsTab? initialTab,
  }) async {
    // Tall, wide-ish phone: a three-card list is fully built and the test
    // font (square glyphs) does not overflow the empty-state button.
    tester.view.physicalSize = const Size(480, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    whenListen(
      openCubit,
      const Stream<OpenEventsState>.empty(),
      initialState: open,
    );
    whenListen(
      trackedCubit,
      const Stream<TrackedState>.empty(),
      initialState: tracked,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: auth),
            BlocProvider<OpenEventsCubit>.value(value: openCubit),
            BlocProvider<TrackedCubit>.value(value: trackedCubit),
          ],
          child: EventsScreen(initialTab: initialTab),
        ),
      ),
    );
  }

  final threeEvents = [
    event(),
    event(id: 42, title: 'Wedding of Nadia & Reza', isUrgent: false),
    event(id: 43, title: 'Kirana 17th birthday', isUrgent: false),
  ];

  group('Open tab (C1 / C10)', () {
    testWidgets('loading: skeleton cards, skeleton eyebrow, no tab counts', (
      tester,
    ) async {
      await pumpScreen(tester, open: const OpenEventsState.loading());

      expect(find.text('Events'), findsOneWidget);
      expect(find.byType(Skeleton), findsNWidgets(4));
      expect(find.text('03'), findsNothing);
      expect(find.byType(EventCard), findsNothing);
    });

    testWidgets('loaded: header, counts, one card per event in order', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        open: OpenEventsState.loaded(data: threeEvents, total: 3),
        tracked: TrackedState.loaded(data: [application()], total: 4),
      );
      await tester.pump();

      expect(find.text('3 OPEN · JAKARTA'), findsOneWidget);
      expect(find.text('Search events or venues'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('03'), findsOneWidget);
      expect(find.text('Tracked'), findsOneWidget);
      expect(find.text('04'), findsOneWidget);
      expect(find.byType(EventCard), findsNWidgets(3));
      final titles = tester
          .widgetList<EventCard>(find.byType(EventCard))
          .map((card) => card.event.title)
          .toList();
      expect(titles, [
        'Arunika annual gathering',
        'Wedding of Nadia & Reza',
        'Kirana 17th birthday',
      ]);
    });

    testWidgets('empty: C10 copy and no count on the Open tab', (tester) async {
      await pumpScreen(
        tester,
        open: const OpenEventsState.loaded(data: [], total: 0),
      );
      await tester.pump();

      expect(find.text('0 OPEN · JAKARTA'), findsOneWidget);
      expect(find.text('No open events right now.'), findsOneWidget);
      expect(
        find.text(
          "New events for your roles will show up here. You'll also get a notification.",
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.explore_outlined), findsOneWidget);
      expect(find.text('00'), findsNothing);
    });

    testWidgets('error without data: ErrorView and retry', (tester) async {
      await pumpScreen(
        tester,
        open: const OpenEventsState.error(message: 'Offline'),
      );
      await tester.pump();

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Offline'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      verify(() => openCubit.retry()).called(1);
    });

    testWidgets('search is debounced into fetch(search:)', (tester) async {
      await pumpScreen(
        tester,
        open: OpenEventsState.loaded(data: threeEvents, total: 3),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'kirana');
      await tester.pump(const Duration(milliseconds: 100));
      verifyNever(() => openCubit.fetch(search: any(named: 'search')));
      await tester.pump(const Duration(milliseconds: 400));
      verify(() => openCubit.fetch(search: 'kirana')).called(1);
    });
  });

  group('Tracked tab (C2)', () {
    testWidgets('switching tabs shows applications, intro and eyebrow', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        open: OpenEventsState.loaded(data: threeEvents, total: 3),
        tracked: TrackedState.loaded(
          data: [
            application(),
            application(id: 303, status: ApplicationStatus.selected),
            application(id: 305, status: ApplicationStatus.notSelected),
          ],
          total: 3,
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Tracked'));
      await tester.pumpAndSettle();

      expect(find.text('3 APPLICATIONS'), findsOneWidget);
      expect(find.text('Search events or venues'), findsNothing);
      expect(
        find.text('Monitor your applications and selection results.'),
        findsOneWidget,
      );
      expect(find.byType(TrackedCard), findsNWidgets(3));
      expect(find.text('WAITING'), findsOneWidget);
      expect(find.text('SELECTED'), findsOneWidget);
      expect(find.text('NOT SELECTED'), findsOneWidget);
      expect(find.text('MON 05 OCT · AS CREW'), findsNWidgets(3));
    });

    testWidgets('initialTab opens on Tracked', (tester) async {
      await pumpScreen(
        tester,
        open: OpenEventsState.loaded(data: threeEvents, total: 3),
        tracked: TrackedState.loaded(data: [application()], total: 1),
        initialTab: EventsTab.tracked,
      );
      await tester.pump();

      expect(find.text('1 APPLICATION'), findsOneWidget);
      expect(find.byType(TrackedCard), findsOneWidget);
    });

    testWidgets('empty: copy and "Browse open events" switches to Open', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        open: OpenEventsState.loaded(data: threeEvents, total: 3),
        tracked: const TrackedState.loaded(data: [], total: 0),
        initialTab: EventsTab.tracked,
      );
      await tester.pump();

      expect(find.text("You haven't applied to any events."), findsOneWidget);
      expect(
        find.text('Applications you send will appear here with their status.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Browse open events'));
      await tester.pumpAndSettle();

      expect(find.text('3 OPEN · JAKARTA'), findsOneWidget);
      expect(find.text('Search events or venues'), findsOneWidget);
    });

    testWidgets('error without data: ErrorView and retry', (tester) async {
      await pumpScreen(
        tester,
        open: OpenEventsState.loaded(data: threeEvents, total: 3),
        tracked: const TrackedState.error(message: 'Offline'),
        initialTab: EventsTab.tracked,
      );
      await tester.pump();

      expect(find.byType(ErrorView), findsOneWidget);
      await tester.tap(find.text('Try again'));
      verify(() => trackedCubit.retry()).called(1);
    });
  });
}
