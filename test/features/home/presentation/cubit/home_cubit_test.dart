import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/models/event.dart';
import 'package:penta_crew/features/events/usecases/get_applications.dart';
import 'package:penta_crew/features/events/usecases/get_open_events.dart';
import 'package:penta_crew/features/home/presentation/cubit/home_cubit.dart';
import 'package:penta_crew/features/home/presentation/cubit/home_state.dart';
import 'package:penta_crew/features/home/presentation/cubit/section.dart';
import 'package:penta_crew/features/schedule/models/history_summary.dart';
import 'package:penta_crew/features/schedule/usecases/get_schedule_history.dart';
import 'package:penta_crew/features/schedule/usecases/get_upcoming_schedule.dart';

import '../../../events/event_models_test.dart' show applicationJson, eventJson;

class _MockGetUpcomingSchedule extends Mock implements GetUpcomingSchedule {}

class _MockGetApplications extends Mock implements GetApplications {}

class _MockGetScheduleHistory extends Mock implements GetScheduleHistory {}

class _MockGetOpenEvents extends Mock implements GetOpenEvents {}

Paginated<T> _page<T>(
  List<T> data, {
  int total = 0,
  Map<String, dynamic> meta = const {},
}) => Paginated(
  data: data,
  currentPage: 1,
  lastPage: 1,
  total: total,
  meta: meta,
);

void main() {
  final event = Event.fromJson(eventJson);
  final application = Application.fromJson(applicationJson);
  final summary = HistorySummary(
    workedCount: 6,
    workedSince: DateTime(2026, 7, 1),
  );
  const summaryMeta = {
    'summary': {'worked_count': 6, 'worked_since': '2026-07-01'},
  };

  late _MockGetUpcomingSchedule getUpcoming;
  late _MockGetApplications getApplications;
  late _MockGetScheduleHistory getHistory;
  late _MockGetOpenEvents getOpenEvents;

  setUpAll(() {
    registerFallbackValue(GetUpcomingScheduleParams.next);
    registerFallbackValue(GetApplicationsParams.waitingCount);
    registerFallbackValue(GetScheduleHistoryParams.summaryOnly);
    registerFallbackValue(const GetOpenEventsParams(branchId: 1, page: 1));
  });

  setUp(() {
    getUpcoming = _MockGetUpcomingSchedule();
    getApplications = _MockGetApplications();
    getHistory = _MockGetScheduleHistory();
    getOpenEvents = _MockGetOpenEvents();
  });

  HomeCubit build() => HomeCubit(
    getUpcomingSchedule: getUpcoming,
    getApplications: getApplications,
    getScheduleHistory: getHistory,
    getOpenEvents: getOpenEvents,
  );

  void stubAllSuccess() {
    when(
      () => getUpcoming(any()),
    ).thenAnswer((_) async => Result.success(_page([application], total: 1)));
    when(
      () => getApplications(any()),
    ).thenAnswer((_) async => Result.success(_page([application], total: 2)));
    when(() => getHistory(any())).thenAnswer(
      (_) async =>
          Result.success(_page([application], total: 7, meta: summaryMeta)),
    );
    when(() => getOpenEvents(any()))
        .thenAnswer((_) async => Result.success(_page([event], total: 3)));
  }

  const waitingLoadedOnly = HomeState(
    nextShift: Section.loading(),
    waitingCount: Section.loaded(2),
    worked: Section.loading(),
    openEvents: Section.loading(),
  );

  group('load', () {
    blocTest<HomeCubit, HomeState>(
      'every section ends loaded; counts come from meta',
      build: () {
        stubAllSuccess();
        return build();
      },
      act: (cubit) => cubit.load(branchId: 1),
      verify: (cubit) {
        expect(
          cubit.state.nextShift,
          Section<Application?>.loaded(application),
        );
        expect(cubit.state.waitingCount, const Section<int>.loaded(2));
        expect(cubit.state.worked, Section<HistorySummary>.loaded(summary));
        expect(cubit.state.openEvents, Section<List<Event>>.loaded([event]));
        expect(cubit.state.refreshError, isNull);
        verify(
          () => getOpenEvents(
            any(
              that: predicate<GetOpenEventsParams>(
                (p) => p.branchId == 1 && p.perPage == 5,
              ),
            ),
          ),
        ).called(1);
        verify(() => getApplications(GetApplicationsParams.waitingCount))
            .called(1);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'a section that fails shows its own error; the others still load',
      build: () {
        stubAllSuccess();
        when(() => getHistory(any()))
            .thenAnswer((_) async => const Result.failed('History down'));
        return build();
      },
      act: (cubit) => cubit.load(branchId: 1),
      verify: (cubit) {
        expect(
          cubit.state.worked,
          const Section<HistorySummary>.error('History down'),
        );
        expect(cubit.state.nextShift, isA<SectionLoaded<Application?>>());
        expect(cubit.state.waitingCount, const Section<int>.loaded(2));
        expect(cubit.state.openEvents, isA<SectionLoaded<List<Event>>>());
      },
    );

    blocTest<HomeCubit, HomeState>(
      'sections emit as each request completes, not when all are done',
      build: () {
        stubAllSuccess();
        final pending = Completer<Result<Paginated<Application>>>();
        final pendingEvents = Completer<Result<Paginated<Event>>>();
        when(() => getUpcoming(any())).thenAnswer((_) => pending.future);
        when(() => getHistory(any())).thenAnswer((_) => pending.future);
        when(() => getOpenEvents(any()))
            .thenAnswer((_) => pendingEvents.future);
        return build();
      },
      // Not awaited: three requests never complete in this test.
      act: (cubit) => unawaited(cubit.load(branchId: 1)),
      wait: const Duration(milliseconds: 10),
      // Bloc always lets the first emit through, hence the all-loading state.
      expect: () => [const HomeState(), waitingLoadedOnly],
    );

    blocTest<HomeCubit, HomeState>(
      'no upcoming shift → nextShift loaded with null (B3)',
      build: () {
        stubAllSuccess();
        when(() => getUpcoming(any()))
            .thenAnswer((_) async => Result.success(_page([])));
        when(() => getOpenEvents(any()))
            .thenAnswer((_) async => Result.success(_page([])));
        return build();
      },
      act: (cubit) => cubit.load(branchId: 1),
      verify: (cubit) {
        expect(cubit.state.nextShift, const Section<Application?>.loaded(null));
        expect(cubit.state.openEvents, const Section<List<Event>>.loaded([]));
      },
    );
  });

  group('refresh', () {
    blocTest<HomeCubit, HomeState>(
      'keeps loaded data and signals the server message once on failure',
      build: () {
        stubAllSuccess();
        return build();
      },
      act: (cubit) async {
        await cubit.load(branchId: 1);
        when(() => getApplications(any())).thenAnswer(
          (_) async => const Result.failed('Applications unavailable'),
        );
        await cubit.refresh();
      },
      skip: 5,
      expect: () => [
        isA<HomeState>()
            .having(
              (s) => s.refreshError,
              'refreshError',
              'Applications unavailable',
            )
            .having(
              (s) => s.waitingCount,
              'waitingCount',
              const Section<int>.loaded(2),
            ),
        isA<HomeState>()
            .having((s) => s.refreshError, 'refreshError', isNull)
            .having(
              (s) => s.waitingCount,
              'waitingCount',
              const Section<int>.loaded(2),
            ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'does not put loaded sections back into loading',
      build: () {
        stubAllSuccess();
        return build();
      },
      act: (cubit) async {
        await cubit.load(branchId: 1);
        await cubit.refresh();
      },
      skip: 5,
      expect: () => <HomeState>[],
      verify: (cubit) {
        expect(cubit.state.waitingCount, const Section<int>.loaded(2));
        verify(() => getApplications(any())).called(2);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'a section that was in error shows the new error, no toast',
      build: () {
        stubAllSuccess();
        when(() => getHistory(any()))
            .thenAnswer((_) async => const Result.failed('first'));
        return build();
      },
      act: (cubit) async {
        await cubit.load(branchId: 1);
        when(() => getHistory(any()))
            .thenAnswer((_) async => const Result.failed('second'));
        await cubit.refresh();
      },
      skip: 5,
      expect: () => [
        isA<HomeState>()
            .having(
              (s) => s.worked,
              'worked',
              const Section<HistorySummary>.error('second'),
            )
            .having((s) => s.refreshError, 'refreshError', isNull),
      ],
    );
  });

  group('retry', () {
    blocTest<HomeCubit, HomeState>(
      'reloads only that section: loading → loaded',
      build: () {
        stubAllSuccess();
        when(() => getHistory(any()))
            .thenAnswer((_) async => const Result.failed('boom'));
        return build();
      },
      act: (cubit) async {
        await cubit.load(branchId: 1);
        when(() => getHistory(any())).thenAnswer(
          (_) async => Result.success(_page([application], meta: summaryMeta)),
        );
        await cubit.retry(HomeSection.worked);
      },
      skip: 5,
      expect: () => [
        isA<HomeState>().having(
          (s) => s.worked,
          'worked',
          const Section<HistorySummary>.loading(),
        ),
        isA<HomeState>().having(
          (s) => s.worked,
          'worked',
          Section<HistorySummary>.loaded(summary),
        ),
      ],
      verify: (_) {
        verify(() => getHistory(any())).called(2);
        verify(() => getUpcoming(any())).called(1);
        verify(() => getApplications(any())).called(1);
        verify(() => getOpenEvents(any())).called(1);
      },
    );
  });
}
