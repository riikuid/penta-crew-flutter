import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/schedule/models/month_group.dart';
import 'package:penta_crew/features/schedule/presentation/cubit/upcoming_cubit.dart';
import 'package:penta_crew/features/schedule/presentation/cubit/upcoming_state.dart';
import 'package:penta_crew/features/schedule/usecases/get_upcoming_schedule.dart';

import 'schedule_fixtures.dart';

class _MockGetUpcomingSchedule extends Mock implements GetUpcomingSchedule {}

void main() {
  late _MockGetUpcomingSchedule getUpcoming;

  setUpAll(() {
    registerFallbackValue(const GetUpcomingScheduleParams(page: 1));
  });

  setUp(() {
    getUpcoming = _MockGetUpcomingSchedule();
  });

  void stubPage(int page, Result<Paginated<Application>> result) {
    when(
      () => getUpcoming(
        any(
          that: predicate<GetUpcomingScheduleParams>(
            (params) => params.page == page,
          ),
        ),
      ),
    ).thenAnswer((_) async => result);
  }

  group('MonthGroup', () {
    test('groups consecutive months in server order and labels them', () {
      final groups = MonthGroup.fromApplications([
        ...upcomingOctober,
        ...upcomingNovember,
      ]);

      expect(groups, hasLength(2));
      expect(groups[0].month, DateTime(2026, 10));
      expect(groups[0].label, 'October 2026 · 2 events');
      expect(groups[0].items.map((item) => item.id), [1, 2]);
      expect(groups[1].label, 'November 2026 · 1 event');
    });

    test('drops applications without an event', () {
      final orphan = upcomingOctober.first.copyWith(event: null);
      expect(MonthGroup.fromApplications([orphan]), isEmpty);
    });
  });

  group('fetch', () {
    blocTest<UpcomingCubit, UpcomingState>(
      'loading → loaded grouped by month, first item overall is Next',
      build: () {
        stubPage(
          1,
          Result.success(
            schedulePage([...upcomingOctober, ...upcomingNovember]),
          ),
        );
        return UpcomingCubit(getUpcoming);
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const UpcomingState.loading(),
        isA<UpcomingLoaded>()
            .having((state) => state.groups.length, 'groups', 2)
            .having(
              (state) => state.groups.first.label,
              'first label',
              'October 2026 · 2 events',
            )
            .having((state) => state.hasReachedMax, 'hasReachedMax', true)
            .having(
              (state) => state.next?.event?.title,
              'next',
              'Wedding of Laras & Bima',
            ),
      ],
    );

    blocTest<UpcomingCubit, UpcomingState>(
      'empty page → loaded with no groups and no Next',
      build: () {
        stubPage(1, Result.success(schedulePage([])));
        return UpcomingCubit(getUpcoming);
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const UpcomingState.loading(),
        isA<UpcomingLoaded>()
            .having((state) => state.groups, 'groups', isEmpty)
            .having((state) => state.next, 'next', isNull),
      ],
    );

    blocTest<UpcomingCubit, UpcomingState>(
      'failure → error without data',
      build: () {
        stubPage(1, const Result.failed('Server unavailable'));
        return UpcomingCubit(getUpcoming);
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const UpcomingState.loading(),
        const UpcomingState.error(message: 'Server unavailable'),
      ],
    );
  });

  group('loadMore', () {
    blocTest<UpcomingCubit, UpcomingState>(
      'appends the next page and regroups; Next stays the first item',
      build: () {
        stubPage(
          1,
          Result.success(schedulePage(upcomingOctober, lastPage: 2)),
        );
        stubPage(
          2,
          Result.success(schedulePage(upcomingNovember, page: 2, lastPage: 2)),
        );
        return UpcomingCubit(getUpcoming);
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 2, // loading, loaded(page 1)
      expect: () => [
        isA<UpcomingLoaded>().having(
          (state) => state.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<UpcomingLoaded>()
            .having((state) => state.groups.length, 'groups', 2)
            .having(
              (state) => state.groups.last.label,
              'last label',
              'November 2026 · 1 event',
            )
            .having((state) => state.page, 'page', 2)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false)
            .having((state) => state.next?.id, 'next', 1),
      ],
    );

    blocTest<UpcomingCubit, UpcomingState>(
      'is a no-op at the last page',
      build: () {
        stubPage(1, Result.success(schedulePage(upcomingOctober)));
        return UpcomingCubit(getUpcoming);
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => isEmpty,
      verify: (_) => verifyNever(
        () => getUpcoming(
          any(
            that: predicate<GetUpcomingScheduleParams>(
              (params) => params.page == 2,
            ),
          ),
        ),
      ),
    );

    blocTest<UpcomingCubit, UpcomingState>(
      'failure keeps the groups: transient error, then back to loaded',
      build: () {
        stubPage(
          1,
          Result.success(schedulePage(upcomingOctober, lastPage: 2)),
        );
        stubPage(2, const Result.failed('offline'));
        return UpcomingCubit(getUpcoming);
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => [
        isA<UpcomingLoaded>().having(
          (state) => state.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<UpcomingError>()
            .having((state) => state.message, 'message', 'offline')
            .having((state) => state.groups.length, 'groups kept', 1),
        isA<UpcomingLoaded>()
            .having((state) => state.groups.length, 'groups', 1)
            .having((state) => state.page, 'page', 1)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ],
    );
  });

  group('refresh', () {
    blocTest<UpcomingCubit, UpcomingState>(
      'on failure surfaces error with data, then restores the list',
      build: () {
        stubPage(1, Result.success(schedulePage(upcomingOctober)));
        return UpcomingCubit(getUpcoming);
      },
      act: (cubit) async {
        await cubit.fetch();
        stubPage(1, const Result.failed('offline'));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        isA<UpcomingError>().having(
          (state) => state.groups.length,
          'groups kept',
          1,
        ),
        isA<UpcomingLoaded>().having(
          (state) => state.groups.length,
          'groups',
          1,
        ),
      ],
    );
  });
}
