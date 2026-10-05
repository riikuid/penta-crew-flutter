import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/presentation/cubit/tracked_cubit.dart';
import 'package:penta_crew/features/events/presentation/cubit/tracked_state.dart';
import 'package:penta_crew/features/events/usecases/get_applications.dart';

import 'fixtures.dart';

class _MockGetApplications extends Mock implements GetApplications {}

void main() {
  late _MockGetApplications getApplications;

  setUpAll(() {
    registerFallbackValue(const GetApplicationsParams(page: 1));
  });

  setUp(() {
    getApplications = _MockGetApplications();
  });

  void stubPage(int pageNumber, Result<Paginated<Application>> result) {
    when(
      () => getApplications(
        any(
          that: predicate<GetApplicationsParams>(
            (params) =>
                params.page == pageNumber &&
                params.statuses.toSet().containsAll(
                  TrackedCubit.trackedStatuses,
                ),
          ),
        ),
      ),
    ).thenAnswer((_) async => result);
  }

  group('fetch', () {
    blocTest<TrackedCubit, TrackedState>(
      'asks for waiting + selected + not_selected (D-04) and keeps meta.total',
      build: () {
        stubPage(
          1,
          Result.success(
            page([
              application(),
              application(id: 303, status: ApplicationStatus.selected),
            ], total: 4),
          ),
        );
        return TrackedCubit(getApplications);
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const TrackedState.loading(),
        isA<TrackedLoaded>()
            .having((state) => state.data.length, 'data', 2)
            .having((state) => state.total, 'total', 4)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true),
      ],
    );

    blocTest<TrackedCubit, TrackedState>(
      'loading → error without data on failure',
      build: () {
        stubPage(1, const Result.failed('boom'));
        return TrackedCubit(getApplications);
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const TrackedState.loading(),
        const TrackedState.error(message: 'boom'),
      ],
    );
  });

  group('loadMore', () {
    blocTest<TrackedCubit, TrackedState>(
      'appends the next page',
      build: () {
        stubPage(
          1,
          Result.success(page([application()], lastPage: 2, total: 2)),
        );
        stubPage(
          2,
          Result.success(
            page(
              [application(id: 302)],
              currentPage: 2,
              lastPage: 2,
              total: 2,
            ),
          ),
        );
        return TrackedCubit(getApplications);
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => [
        isA<TrackedLoaded>().having(
          (state) => state.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<TrackedLoaded>()
            .having((state) => state.data.length, 'data', 2)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true),
      ],
    );

    blocTest<TrackedCubit, TrackedState>(
      'keeps existing data on failure',
      build: () {
        stubPage(1, Result.success(page([application()], lastPage: 2)));
        stubPage(2, const Result.failed('offline'));
        return TrackedCubit(getApplications);
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 3,
      expect: () => [
        isA<TrackedError>()
            .having((state) => state.message, 'message', 'offline')
            .having((state) => state.data.length, 'data kept', 1),
        isA<TrackedLoaded>()
            .having((state) => state.data.length, 'data', 1)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ],
    );
  });

  group('refresh', () {
    blocTest<TrackedCubit, TrackedState>(
      'replaces the list silently',
      build: () {
        stubPage(1, Result.success(page([application()])));
        return TrackedCubit(getApplications);
      },
      act: (cubit) async {
        await cubit.fetch();
        stubPage(1, Result.success(page([])));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        isA<TrackedLoaded>().having((state) => state.data, 'data', isEmpty),
      ],
    );

    blocTest<TrackedCubit, TrackedState>(
      'on failure surfaces error with data, then restores the previous list',
      build: () {
        stubPage(1, Result.success(page([application()])));
        return TrackedCubit(getApplications);
      },
      act: (cubit) async {
        await cubit.fetch();
        stubPage(1, const Result.failed('offline'));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        isA<TrackedError>().having(
          (state) => state.data.length,
          'data kept',
          1,
        ),
        isA<TrackedLoaded>().having((state) => state.data.length, 'data', 1),
      ],
    );
  });
}
