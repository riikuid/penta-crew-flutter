import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/di/locator.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/widgets/skeleton.dart';
import 'package:penta_crew/core/widgets/status_pill.dart';
import 'package:penta_crew/features/auth/models/branch.dart';
import 'package:penta_crew/features/auth/models/crew_role.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_state.dart';
import 'package:penta_crew/features/events/events_routes.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/models/event.dart';
import 'package:penta_crew/features/events/presentation/widgets/event_card.dart';
import 'package:penta_crew/features/home/presentation/cubit/home_cubit.dart';
import 'package:penta_crew/features/home/presentation/cubit/home_state.dart';
import 'package:penta_crew/features/home/presentation/cubit/section.dart';
import 'package:penta_crew/features/home/presentation/screens/home_screen.dart';
import 'package:penta_crew/features/notifications/presentation/cubit/unread_count_cubit.dart';
import 'package:penta_crew/features/schedule/models/history_summary.dart';
import 'package:toastification/toastification.dart';

import '../../../events/event_models_test.dart' show applicationJson, eventJson;

class _MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class _MockUnreadCountCubit extends MockCubit<int>
    implements UnreadCountCubit {}

void main() {
  // 8 days before the contract sample event (5 Oct 2026).
  final now = DateTime(2026, 9, 27, 9);
  final event = Event.fromJson(eventJson);
  final nextShift = Application.fromJson({
    ...applicationJson,
    'status': 'selected',
    'assigned_position': applicationJson['applied_position'],
  });
  const user = User(
    id: 12,
    name: 'Nadia Putri',
    roles: [
      CrewRole(id: 1, name: 'Crew'),
      CrewRole(id: 2, name: 'Event Manager'),
    ],
    branch: Branch(id: 1, name: 'Jakarta'),
    verificationStatus: VerificationStatus.approved,
  );
  final summary = HistorySummary(
    workedCount: 6,
    workedSince: DateTime(2026, 7, 1),
  );

  final loaded = HomeState(
    nextShift: Section.loaded(nextShift),
    waitingCount: const Section.loaded(2),
    worked: Section.loaded(summary),
    openEvents: Section.loaded([
      event,
      event.copyWith(id: 42),
      event.copyWith(id: 43),
    ]),
  );

  late _MockHomeCubit homeCubit;
  late _MockAuthCubit authCubit;

  setUpAll(() {
    registerFallbackValue(HomeSection.nextShift);
  });

  setUp(() {
    homeCubit = _MockHomeCubit();
    authCubit = _MockAuthCubit();
    when(() => authCubit.state).thenReturn(const AuthState.authenticated(user));
    when(() => authCubit.user).thenReturn(user);
    when(() => homeCubit.refresh()).thenAnswer((_) async {});
    when(() => homeCubit.retry(any())).thenAnswer((_) async {});

    // The bell's `UnreadDot` reads the app-scoped cubit from `sl`.
    final unreadCount = _MockUnreadCountCubit();
    when(() => unreadCount.state).thenReturn(0);
    when(unreadCount.fetch).thenAnswer((_) async {});
    sl.registerSingleton<UnreadCountCubit>(unreadCount);
  });

  tearDown(() async => sl.reset());

  Future<void> pumpHome(WidgetTester tester, HomeState state) async {
    // Tall enough for the whole B1 column; the ListView builds lazily.
    tester.view.physicalSize = const Size(402, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    when(() => homeCubit.state).thenReturn(state);
    await tester.pumpWidget(
      ToastificationWrapper(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>.value(value: authCubit),
              BlocProvider<HomeCubit>.value(value: homeCubit),
            ],
            // A fresh key per pump so a second `pumpHome` in one test does
            // not reuse the previous BlocBuilder (and its cached state).
            child: HomeScreen(key: UniqueKey(), now: now),
          ),
        ),
      ),
    );
    // Skeletons pulse forever, so never `pumpAndSettle` here.
    await tester.pump();
  }

  group('B1 loaded', () {
    testWidgets('greeting, headline, hero, counters and carousel', (
      tester,
    ) async {
      await pumpHome(tester, loaded);

      expect(find.text('Greetings, Nadia!'), findsOneWidget);
      expect(find.text('Your next shift is in 8 days.'), findsOneWidget);

      // Hero.
      expect(find.byType(StatusPill), findsWidgets);
      expect(find.text('SELECTED'), findsOneWidget);
      expect(find.text('AS CREW'), findsOneWidget);
      expect(find.text('05'), findsOneWidget);
      expect(find.text('OCT'), findsOneWidget);
      expect(find.text('MON'), findsOneWidget);
      expect(find.text('Arunika annual gathering'), findsWidgets);
      expect(
        find.text('14:00–20:00 · JIEXPO KEMAYORAN, HALL B'),
        findsOneWidget,
      );
      expect(find.text('Inspect'), findsOneWidget);
      expect(find.textContaining('Briefing'), findsNothing);

      // Counters (D-04: WAITING, not TRACKED).
      expect(find.text('WAITING'), findsOneWidget);
      expect(find.text('TRACKED'), findsNothing);
      expect(find.text('02'), findsOneWidget);
      expect(find.text('applications pending'), findsOneWidget);
      expect(find.text('WORKED'), findsOneWidget);
      expect(find.text('06'), findsOneWidget);
      expect(find.text('since Jul 2026'), findsOneWidget);

      // Carousel.
      expect(find.text('Open for you'), findsOneWidget);
      expect(find.text('View list'), findsOneWidget);
      expect(find.byType(EventCard), findsNWidgets(3));
      expect(find.byType(Skeleton), findsNothing);
    });

    testWidgets('bell button is a 44 px circle', (tester) async {
      await pumpHome(tester, loaded);

      final bell = find.byIcon(Icons.notifications_outlined);
      expect(bell, findsOneWidget);
      final target = find.ancestor(of: bell, matching: find.byType(InkWell));
      expect(tester.getSize(target), const Size(44, 44));
    });

    testWidgets('headline says tomorrow / today / nothing scheduled', (
      tester,
    ) async {
      await pumpHome(
        tester,
        loaded.copyWith(
          nextShift: Section.loaded(
            nextShift.copyWith(
              event: event.copyWith(date: DateTime(2026, 9, 28)),
            ),
          ),
        ),
      );
      expect(find.text('Your next shift is tomorrow.'), findsOneWidget);

      await pumpHome(
        tester,
        loaded.copyWith(
          nextShift: Section.loaded(
            nextShift.copyWith(
              event: event.copyWith(date: DateTime(2026, 9, 27)),
            ),
          ),
        ),
      );
      expect(find.text('Your next shift is today.'), findsOneWidget);

      await pumpHome(
        tester,
        loaded.copyWith(nextShift: const Section.loaded(null)),
      );
      expect(
        find.text('Nothing scheduled yet.'),
        findsOneWidget,
        reason: 'open events exist',
      );
      expect(
        find.text('Roles assigned'),
        findsOneWidget,
        reason: 'roles card replaces the hero',
      );
    });

    testWidgets('worked counter without history reads "no events yet"', (
      tester,
    ) async {
      await pumpHome(
        tester,
        loaded.copyWith(worked: const Section.loaded(HistorySummary())),
      );

      expect(find.text('00'), findsOneWidget);
      expect(find.text('no events yet'), findsOneWidget);
    });

    testWidgets('pull-to-refresh calls refresh', (tester) async {
      await pumpHome(tester, loaded);

      await tester.fling(
        find.text('Greetings, Nadia!'),
        const Offset(0, 400),
        1000,
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => homeCubit.refresh()).called(1);
    });
  });

  group('B2 loading', () {
    testWidgets('every block is a skeleton, no copy at all', (tester) async {
      await pumpHome(tester, const HomeState());

      expect(find.byType(Skeleton), findsAtLeastNWidgets(7));
      expect(find.byType(Text), findsNothing);
      expect(find.byIcon(Icons.notifications_outlined), findsNothing);
    });

    testWidgets('a resolved section draws next to still-loading ones', (
      tester,
    ) async {
      await pumpHome(tester, const HomeState(waitingCount: Section.loaded(2)));

      expect(find.text('Greetings, Nadia!'), findsOneWidget);
      expect(find.text('WAITING'), findsOneWidget);
      expect(find.text('02'), findsOneWidget);
      expect(find.text('WORKED'), findsNothing);
      expect(find.byType(Skeleton), findsWidgets);
    });
  });

  group('B3 empty', () {
    testWidgets('verified-and-ready headline, roles card, blush empty block', (
      tester,
    ) async {
      await pumpHome(
        tester,
        loaded.copyWith(
          nextShift: const Section.loaded(null),
          openEvents: const Section.loaded([]),
        ),
      );

      expect(find.text("You're verified and ready."), findsOneWidget);
      expect(find.text('Roles assigned'), findsOneWidget);
      expect(find.text('CREW · EVENT MANAGER · JAKARTA'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      expect(find.text('OPEN FOR YOU · 00'), findsOneWidget);
      expect(find.text('No open events yet.'), findsOneWidget);
      expect(
        find.text(
          "When an admin publishes an event that matches your roles, it shows up here and you'll get a notification.",
        ),
        findsOneWidget,
      );
      expect(
        find.text('Open for you'),
        findsNothing,
        reason: 'the block replaces the section header',
      );
      expect(find.text('View list'), findsNothing);
      expect(find.byType(EventCard), findsNothing);
    });
  });

  group('section error', () {
    testWidgets(
      'shows the server message inline and retries only that section',
      (tester) async {
        await pumpHome(
          tester,
          loaded.copyWith(worked: const Section.error('History unavailable')),
        );

        expect(find.text('History unavailable'), findsOneWidget);
        expect(find.text('WORKED'), findsNothing);
        // The other sections are untouched.
        expect(find.text('WAITING'), findsOneWidget);
        expect(find.text('Your next shift is in 8 days.'), findsOneWidget);
        expect(find.byType(EventCard), findsNWidgets(3));

        await tester.tap(find.text('Try again'));
        verify(() => homeCubit.retry(HomeSection.worked)).called(1);
      },
    );

    testWidgets('next shift error hides the headline but keeps the greeting', (
      tester,
    ) async {
      await pumpHome(
        tester,
        loaded.copyWith(nextShift: const Section.error('Schedule down')),
      );

      expect(find.text('Greetings, Nadia!'), findsOneWidget);
      expect(find.textContaining('next shift'), findsNothing);
      expect(find.text('Schedule down'), findsOneWidget);
    });
  });

  group('refresh failure', () {
    testWidgets('data stays and the server message shows as a toast', (
      tester,
    ) async {
      whenListen(
        homeCubit,
        Stream.fromIterable([
          loaded.copyWith(refreshError: 'Server busy'),
          loaded,
        ]),
        initialState: loaded,
      );
      await pumpHome(tester, loaded);
      // One frame to insert the overlay entry, one for its entrance.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Server busy'), findsOneWidget);
      expect(
        find.text('02'),
        findsOneWidget,
        reason: 'loaded data stays on screen',
      );

      // Let the toast's auto-close timer run out before the test ends.
      await tester.pump(const Duration(seconds: 4));
    });
  });

  group('refresh on show', () {
    testWidgets('refetches silently when the branch is shown again, once '
        'per burst', (tester) async {
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      when(() => homeCubit.state).thenReturn(loaded);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>.value(value: authCubit),
              BlocProvider<HomeCubit>.value(value: homeCubit),
            ],
            child: ValueListenableBuilder(
              valueListenable: visible,
              builder: (_, isVisible, _) => TickerMode(
                enabled: isVisible,
                child: HomeScreen(now: now),
              ),
            ),
          ),
        ),
      );
      verifyNever(() => homeCubit.refresh());

      for (var i = 0; i < 3; i++) {
        visible.value = false;
        await tester.pump();
        visible.value = true;
        await tester.pump();
      }

      verify(() => homeCubit.refresh()).called(1);
      expect(find.byType(Skeleton), findsNothing);
      expect(find.text('02'), findsOneWidget);
    });

    testWidgets('refetches after a pushed detail pops', (tester) async {
      when(() => homeCubit.state).thenReturn(loaded);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>.value(value: authCubit),
              BlocProvider<HomeCubit>.value(value: homeCubit),
            ],
            child: HomeScreen(now: now),
          ),
        ),
      );
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.push(MaterialPageRoute<void>(builder: (_) => const Scaffold()));
      await tester.pumpAndSettle();
      verifyNever(() => homeCubit.refresh());

      navigator.pop();
      await tester.pumpAndSettle();

      verify(() => homeCubit.refresh()).called(1);
    });
  });

  group('links into Events', () {
    Future<GoRouter> pumpWithRouter(WidgetTester tester) async {
      tester.view.physicalSize = const Size(402, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      when(() => homeCubit.state).thenReturn(loaded);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthCubit>.value(value: authCubit),
                BlocProvider<HomeCubit>.value(value: homeCubit),
              ],
              child: HomeScreen(now: now),
            ),
          ),
          GoRoute(
            path: EventsRoutes.root,
            builder: (_, _) => const Text('events tab'),
          ),
        ],
      );
      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
      );
      await tester.pump();
      return router;
    }

    testWidgets('Waiting counter lands on Events > Tracked', (tester) async {
      final router = await pumpWithRouter(tester);

      await tester.tap(find.text('WAITING'));
      await tester.pumpAndSettle();

      expect(router.state.uri.path, EventsRoutes.root);
      expect(
        router.state.uri.queryParameters[EventsRoutes.tabParam],
        'tracked',
      );
    });

    testWidgets('View list lands on Events > Open', (tester) async {
      final router = await pumpWithRouter(tester);

      await tester.tap(find.text('View list'));
      await tester.pumpAndSettle();

      expect(router.state.uri.path, EventsRoutes.root);
      expect(router.state.uri.queryParameters[EventsRoutes.tabParam], 'open');
    });
  });
}
