import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/events/models/event.dart';
import 'package:penta_crew/features/events/presentation/cubit/open_events_cubit.dart';
import 'package:penta_crew/features/events/presentation/cubit/open_events_state.dart';
import 'package:penta_crew/features/events/usecases/get_open_events.dart';

import 'fixtures.dart';

class _MockGetOpenEvents extends Mock implements GetOpenEvents {}

void main() {
  late _MockGetOpenEvents getOpenEvents;

  setUpAll(() {
    registerFallbackValue(const GetOpenEventsParams(branchId: 1, page: 1));
  });

  setUp(() {
    getOpenEvents = _MockGetOpenEvents();
  });

  void stubPage(
    int pageNumber,
    Result<Paginated<Event>> result, {
    String? search,
  }) {
    when(
      () => getOpenEvents(
        any(
          that: predicate<GetOpenEventsParams>(
            (params) =>
                params.page == pageNumber &&
                params.branchId == 1 &&
                (search == null || params.search == search),
          ),
        ),
      ),
    ).thenAnswer((_) async => result);
  }

  OpenEventsCubit build() => OpenEventsCubit(getOpenEvents, branchId: 1);

  group('fetch', () {
    blocTest<OpenEventsCubit, OpenEventsState>(
      'loading → loaded with meta.total and hasReachedMax on a single page',
      build: () {
        stubPage(1, Result.success(page([event(), event(id: 42)], total: 3)));
        return build();
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const OpenEventsState.loading(),
        isA<OpenEventsLoaded>()
            .having((state) => state.data.length, 'data', 2)
            .having((state) => state.total, 'total', 3)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true),
      ],
    );

    blocTest<OpenEventsCubit, OpenEventsState>(
      'passes the search term through and keeps it on the loaded state',
      build: () {
        stubPage(1, Result.success(page([event()])), search: 'arunika');
        return build();
      },
      act: (cubit) => cubit.fetch(search: 'arunika'),
      expect: () => [
        const OpenEventsState.loading(),
        isA<OpenEventsLoaded>().having(
          (state) => state.search,
          'search',
          'arunika',
        ),
      ],
    );

    blocTest<OpenEventsCubit, OpenEventsState>(
      'loading → error without data on failure',
      build: () {
        stubPage(1, const Result.failed('boom'));
        return build();
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const OpenEventsState.loading(),
        const OpenEventsState.error(message: 'boom'),
      ],
    );
  });

  group('loadMore', () {
    blocTest<OpenEventsCubit, OpenEventsState>(
      'appends the next page and flips hasReachedMax at the last page',
      build: () {
        stubPage(1, Result.success(page([event()], lastPage: 2, total: 2)));
        stubPage(
          2,
          Result.success(
            page([event(id: 42)], currentPage: 2, lastPage: 2, total: 2),
          ),
        );
        return build();
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => [
        isA<OpenEventsLoaded>().having(
          (state) => state.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<OpenEventsLoaded>()
            .having((state) => state.data.length, 'data', 2)
            .having((state) => state.page, 'page', 2)
            .having((state) => state.hasReachedMax, 'hasReachedMax', true)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ],
    );

    blocTest<OpenEventsCubit, OpenEventsState>(
      'is a no-op when hasReachedMax',
      build: () {
        stubPage(1, Result.success(page([event()])));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => isEmpty,
    );

    blocTest<OpenEventsCubit, OpenEventsState>(
      'keeps existing data on failure: transient error then back to loaded',
      build: () {
        stubPage(1, Result.success(page([event()], lastPage: 3)));
        stubPage(2, const Result.failed('offline'));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch();
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => [
        isA<OpenEventsLoaded>().having(
          (state) => state.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<OpenEventsError>()
            .having((state) => state.message, 'message', 'offline')
            .having((state) => state.data.length, 'data kept', 1),
        isA<OpenEventsLoaded>()
            .having((state) => state.data.length, 'data', 1)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ],
    );
  });

  group('refresh', () {
    blocTest<OpenEventsCubit, OpenEventsState>(
      'does not go through loading when data is already on screen',
      build: () {
        stubPage(1, Result.success(page([event()])));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch();
        stubPage(1, Result.success(page([event(), event(id: 42)])));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        isA<OpenEventsLoaded>().having((state) => state.data.length, 'data', 2),
      ],
    );

    blocTest<OpenEventsCubit, OpenEventsState>(
      'on failure surfaces error with data, then restores the previous list',
      build: () {
        stubPage(1, Result.success(page([event()])));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch();
        stubPage(1, const Result.failed('offline'));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        isA<OpenEventsError>().having(
          (state) => state.data.length,
          'data kept',
          1,
        ),
        isA<OpenEventsLoaded>().having((state) => state.data.length, 'data', 1),
      ],
    );

    blocTest<OpenEventsCubit, OpenEventsState>(
      'goes through loading again after an error without data',
      build: () {
        stubPage(1, const Result.failed('boom'));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch();
        stubPage(1, Result.success(page([event()])));
        await cubit.refresh();
      },
      skip: 2,
      expect: () => [
        const OpenEventsState.loading(),
        isA<OpenEventsLoaded>().having((state) => state.data.length, 'data', 1),
      ],
    );
  });
}
