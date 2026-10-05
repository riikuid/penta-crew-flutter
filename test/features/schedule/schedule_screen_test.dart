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
import 'package:penta_crew/core/widgets/status_pill.dart';
import 'package:penta_crew/core/widgets/tag_chip.dart';
import 'package:penta_crew/features/events/events_routes.dart';
import 'package:penta_crew/features/schedule/models/history_summary.dart';
import 'package:penta_crew/features/schedule/models/month_group.dart';
import 'package:penta_crew/features/schedule/presentation/cubit/history_cubit.dart';
import 'package:penta_crew/features/schedule/presentation/cubit/history_state.dart';
import 'package:penta_crew/features/schedule/presentation/cubit/upcoming_cubit.dart';
import 'package:penta_crew/features/schedule/presentation/cubit/upcoming_state.dart';
import 'package:penta_crew/features/schedule/presentation/screens/schedule_screen.dart';
import 'package:penta_crew/features/schedule/schedule_routes.dart';

import 'schedule_fixtures.dart';

class _MockUpcomingCubit extends MockCubit<UpcomingState>
    implements UpcomingCubit {}

class _MockHistoryCubit extends MockCubit<HistoryState>
    implements HistoryCubit {}

void main() {
  late _MockUpcomingCubit upcomingCubit;
  late _MockHistoryCubit historyCubit;

  setUp(() {
    upcomingCubit = _MockUpcomingCubit();
    historyCubit = _MockHistoryCubit();
    when(upcomingCubit.fetch).thenAnswer((_) async {});
    when(upcomingCubit.refresh).thenAnswer((_) async {});
    when(upcomingCubit.retry).thenAnswer((_) async {});
    when(upcomingCubit.loadMore).thenAnswer((_) async {});
    when(historyCubit.fetch).thenAnswer((_) async {});
    when(historyCubit.refresh).thenAnswer((_) async {});
    when(historyCubit.retry).thenAnswer((_) async {});
    when(historyCubit.loadMore).thenAnswer((_) async {});
  });

  /// The Schedule tab plus the two routes it navigates to, so taps can be
  /// asserted by what ends up on screen.
  Future<GoRouter> pumpSchedule(
    WidgetTester tester, {
    required UpcomingState upcoming,
    required HistoryState history,
  }) async {
    whenListen(
      upcomingCubit,
      const Stream<UpcomingState>.empty(),
      initialState: upcoming,
    );
    whenListen(
      historyCubit,
      const Stream<HistoryState>.empty(),
      initialState: history,
    );

    final router = GoRouter(
      initialLocation: ScheduleRoutes.root,
      routes: [
        GoRoute(
          path: ScheduleRoutes.root,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<UpcomingCubit>.value(value: upcomingCubit),
              BlocProvider<HistoryCubit>.value(value: historyCubit),
            ],
            child: ScheduleScreen(clock: () => scheduleNow),
          ),
        ),
        GoRoute(
          path: EventsRoutes.root,
          builder: (context, state) => const Text('events tab'),
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
    return router;
  }

  final loadedHistory = HistoryState.loaded(
    items: historyRows,
    summary: HistorySummary.fromMeta(historySummaryMeta),
  );

  group('header', () {
    testWidgets(
      'eyebrow, headline and tabs; switching tabs keeps both cubits',
      (tester) async {
        await pumpSchedule(
          tester,
          upcoming: const UpcomingState.loaded(groups: []),
          history: loadedHistory,
        );

        expect(find.text('CONFIRMED SHIFTS'), findsOneWidget);
        expect(find.text('Schedule'), findsOneWidget);
        expect(find.text('Upcoming'), findsOneWidget);
        expect(find.text('History'), findsOneWidget);
        expect(find.text('No confirmed events.'), findsOneWidget);

        await tester.tap(find.text('History'));
        await tester.pumpAndSettle();
        expect(find.text('06'), findsOneWidget);

        await tester.tap(find.text('Upcoming'));
        await tester.pumpAndSettle();
        expect(find.text('No confirmed events.'), findsOneWidget);
        // The screen never re-fetches on a tab switch; the route does once.
        verifyNever(upcomingCubit.fetch);
        verifyNever(historyCubit.fetch);
      },
    );
  });

  group('Upcoming (D1 / D3)', () {
    testWidgets('loading shows skeletons, not a spinner', (tester) async {
      await pumpSchedule(
        tester,
        upcoming: const UpcomingState.loading(),
        history: const HistoryState.loading(),
      );

      expect(find.byType(Skeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('loaded: month header, date rail, Next card, Confirmed card', (
      tester,
    ) async {
      await pumpSchedule(
        tester,
        upcoming: UpcomingState.loaded(
          groups: MonthGroup.fromApplications(upcomingOctober),
        ),
        history: loadedHistory,
      );

      expect(find.text('OCTOBER 2026 · 2 EVENTS'), findsOneWidget);
      expect(find.text('03'), findsOneWidget);
      expect(find.text('SAT'), findsOneWidget);
      expect(find.text('NEXT · IN 8 DAYS'), findsOneWidget);
      expect(find.text('CONFIRMED'), findsOneWidget);
      expect(find.text('Wedding of Laras & Bima'), findsOneWidget);
      expect(find.text('07:00–15:00 · Plataran Menteng'), findsOneWidget);
      expect(find.text('as Crew'), findsOneWidget);
      expect(find.text('as Event Manager'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_outward), findsNWidgets(2));

      final cards = tester.widgetList<AppCard>(find.byType(AppCard)).toList();
      expect(cards[0].tone, AppCardTone.accent, reason: 'Next is blush');
      expect(cards[1].tone, AppCardTone.surface);
      final chips = tester.widgetList<TagChip>(find.byType(TagChip)).toList();
      expect(chips.map((chip) => chip.height), everyElement(26));
    });

    testWidgets('Next eyebrow says tomorrow / today when that close', (
      tester,
    ) async {
      final tomorrow = upcomingNovember.first.copyWith(
        event: upcomingNovember.first.event!.copyWith(
          date: scheduleNow.add(const Duration(days: 1)),
        ),
      );
      await pumpSchedule(
        tester,
        upcoming: UpcomingState.loaded(
          groups: MonthGroup.fromApplications([tomorrow]),
        ),
        history: loadedHistory,
      );
      expect(find.text('NEXT · TOMORROW'), findsOneWidget);

      final today = tomorrow.copyWith(
        event: tomorrow.event!.copyWith(date: scheduleNow),
      );
      await pumpSchedule(
        tester,
        upcoming: UpcomingState.loaded(
          groups: MonthGroup.fromApplications([today]),
        ),
        history: loadedHistory,
      );
      expect(find.text('NEXT · TODAY'), findsOneWidget);
    });

    testWidgets('second month group gets its own header', (tester) async {
      await pumpSchedule(
        tester,
        upcoming: UpcomingState.loaded(
          groups: MonthGroup.fromApplications([
            ...upcomingOctober,
            ...upcomingNovember,
          ]),
        ),
        history: loadedHistory,
      );

      expect(find.text('OCTOBER 2026 · 2 EVENTS'), findsOneWidget);
      expect(find.text('NOVEMBER 2026 · 1 EVENT'), findsOneWidget);
      expect(find.text('NEXT · IN 8 DAYS'), findsOneWidget);
      expect(find.text('CONFIRMED'), findsNWidgets(2));
    });

    testWidgets('tapping a card opens the event detail', (tester) async {
      await pumpSchedule(
        tester,
        upcoming: UpcomingState.loaded(
          groups: MonthGroup.fromApplications(upcomingOctober),
        ),
        history: loadedHistory,
      );

      await tester.tap(find.text('Wedding of Laras & Bima'));
      await tester.pumpAndSettle();
      expect(find.text('event detail 41'), findsOneWidget);
    });

    testWidgets('empty (D3): copy and Browse events → Events tab', (
      tester,
    ) async {
      await pumpSchedule(
        tester,
        upcoming: const UpcomingState.loaded(groups: []),
        history: loadedHistory,
      );

      expect(find.text('No confirmed events.'), findsOneWidget);
      expect(
        find.text(
          "Events you're selected for will appear here. "
          'Pending applications stay in Events › Tracked.',
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.event_available_outlined), findsOneWidget);

      await tester.tap(find.text('Browse events'));
      await tester.pumpAndSettle();
      expect(find.text('events tab'), findsOneWidget);
    });

    testWidgets('error without data: ErrorView with retry', (tester) async {
      await pumpSchedule(
        tester,
        upcoming: const UpcomingState.error(message: 'Server down'),
        history: loadedHistory,
      );

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Server down'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      verify(upcomingCubit.retry).called(1);
    });
  });

  group('History (D2)', () {
    Future<void> pumpHistory(WidgetTester tester, HistoryState history) async {
      await pumpSchedule(
        tester,
        upcoming: const UpcomingState.loaded(groups: []),
        history: history,
      );
      await tester.tap(find.text('History'));
      // Not pumpAndSettle: the loading skeleton animates forever.
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets('loading shows skeletons', (tester) async {
      await pumpHistory(tester, const HistoryState.loading());

      expect(find.byType(Skeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('loaded: counter, rows, Completed / Not selected pills', (
      tester,
    ) async {
      await pumpHistory(tester, loadedHistory);

      expect(find.text('06'), findsOneWidget);
      expect(find.text('events worked\nsince Jul 2026'), findsOneWidget);
      expect(find.text('Rumah Dansa studio opening'), findsOneWidget);
      expect(find.text('SUN 20 SEP · CREW'), findsOneWidget);
      expect(find.text('Kirana 17th birthday'), findsOneWidget);
      expect(find.text('SAT 12 SEP · CREW'), findsOneWidget);
      expect(find.text('NOT SELECTED'), findsOneWidget);
      expect(find.text('COMPLETED'), findsOneWidget);
      expect(find.byType(StatusPill), findsNWidgets(2));
      expect(
        find.byType(Divider),
        findsOneWidget,
        reason: 'hairline between rows',
      );
    });

    testWidgets('counter with nothing worked: `events worked` only', (
      tester,
    ) async {
      await pumpHistory(
        tester,
        HistoryState.loaded(
          items: [historyRows.first],
          summary: const HistorySummary(),
        ),
      );

      expect(find.text('00'), findsOneWidget);
      expect(find.text('events worked'), findsOneWidget);
      expect(find.textContaining('since'), findsNothing);
    });

    testWidgets('tapping a row opens the event detail', (tester) async {
      await pumpHistory(tester, loadedHistory);

      await tester.tap(find.text('Kirana 17th birthday'));
      await tester.pumpAndSettle();
      expect(find.text('event detail 51'), findsOneWidget);
    });

    testWidgets('empty: copy without an action', (tester) async {
      await pumpHistory(
        tester,
        const HistoryState.loaded(items: [], summary: HistorySummary()),
      );

      expect(find.text('No history yet.'), findsOneWidget);
      expect(
        find.text('Completed shifts and past applications will appear here.'),
        findsOneWidget,
      );
      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('Browse events'), findsNothing);
    });

    testWidgets('error without data: ErrorView with retry', (tester) async {
      await pumpHistory(tester, const HistoryState.error(message: 'Timeout'));

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Timeout'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      verify(historyCubit.retry).called(1);
    });
  });
}
