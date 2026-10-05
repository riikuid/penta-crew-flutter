import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/schedule/models/history_summary.dart';
import 'package:penta_crew/features/schedule/presentation/cubit/history_cubit.dart';
import 'package:penta_crew/features/schedule/presentation/cubit/history_state.dart';
import 'package:penta_crew/features/schedule/usecases/get_schedule_history.dart';

import 'schedule_fixtures.dart';

class _MockGetScheduleHistory extends Mock implements GetScheduleHistory {}

void main() {
  late _MockGetScheduleHistory getHistory;

  setUpAll(() {
    registerFallbackValue(const GetScheduleHistoryParams(page: 1));
  });

  setUp(() {
    getHistory = _MockGetScheduleHistory();
  });

  void stubPage(int page, Result<Paginated<Application>> result) {
    when(
      () => getHistory(
        any(
          that: predicate<GetScheduleHistoryParams>(
            (params) => params.page == page,
          ),
        ),
      ),
    ).thenAnswer((_) async => result);
  }

  group('fetch', () {
    blocTest<HistoryCubit, HistoryState>(
      'loading → loaded with rows and the summary parsed from meta',
      build: () {
        stubPage(
          1,
          Result.success(schedulePage(historyRows, meta: historySummaryMeta)),
        );
        return HistoryCubit(getHistory);
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const HistoryState.loading(),
        isA<HistoryLoaded>()
            .having((state) => state.items.length, 'items', 2)
            .having(
              (state) => state.summary,
              'summary',
              HistorySummary(workedCount: 6, workedSince: DateTime(2026, 7, 4)),
            )
            .having((state) => state.hasReachedMax, 'hasReachedMax', true),
      ],
    );

    blocTest<HistoryCubit, HistoryState>(
      'empty page without summary → loaded with no rows and a zero counter',
      build: () {
        stubPage(1, Result.success(schedulePage([])));
        return HistoryCubit(getHistory);
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const HistoryState.loading(),
        const HistoryState.loaded(
          items: [],
          summary: HistorySummary(),
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<HistoryCubit, HistoryState>(
      'failure → error without data',
      build: () {
        stubPage(1, const Result.failed('Server unavailable'));
        return HistoryCubit(getHistory);
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const HistoryState.loading(),
        const HistoryState.error(message: 'Server unavailable'),
      ],
    );
  });

  group('loadMore', () {
    blocTest<HistoryCubit, HistoryState>(
      'appends the next page and keeps the page-1 summary',
      build: () {
        stubPage(
          1,
          Result.success(
            schedulePage(
              [historyRows.first],
              lastPage: 2,
              meta: historySummaryMeta,
            ),
          ),
        );
        stubPage(
          2,
          Result.success(schedulePage([historyRows.last], page: 2, lastPage: 2)),
        );
        return HistoryCubit(getHistory);
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 2, // loading, loaded(page 1)
      expect: () => [
        isA<HistoryLoaded>().having(
          (state) => state.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<HistoryLoaded>()
            .having((state) => state.items.map((item) => item.id), 'items', [
              10,
              11,
            ])
            .having((state) => state.summary.workedCount, 'workedCount', 6)
            .having((state) => state.page, 'page', 2)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ],
    );

    blocTest<HistoryCubit, HistoryState>(
      'failure keeps the rows: transient error, then back to loaded',
      build: () {
        stubPage(
          1,
          Result.success(
            schedulePage(historyRows, lastPage: 3, meta: historySummaryMeta),
          ),
        );
        stubPage(2, const Result.failed('offline'));
        return HistoryCubit(getHistory);
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => [
        isA<HistoryLoaded>().having(
          (state) => state.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<HistoryError>()
            .having((state) => state.message, 'message', 'offline')
            .having((state) => state.items.length, 'items kept', 2),
        isA<HistoryLoaded>()
            .having((state) => state.items.length, 'items', 2)
            .having((state) => state.page, 'page', 1)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ],
    );
  });

  group('refresh', () {
    blocTest<HistoryCubit, HistoryState>(
      'on failure surfaces error with data, then restores the list',
      build: () {
        stubPage(
          1,
          Result.success(schedulePage(historyRows, meta: historySummaryMeta)),
        );
        return HistoryCubit(getHistory);
      },
      act: (cubit) async {
        await cubit.fetch();
        stubPage(1, const Result.failed('offline'));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        isA<HistoryError>().having(
          (state) => state.items.length,
          'items kept',
          2,
        ),
        isA<HistoryLoaded>().having(
          (state) => state.summary.workedCount,
          'summary restored',
          6,
        ),
      ],
    );
  });
}
