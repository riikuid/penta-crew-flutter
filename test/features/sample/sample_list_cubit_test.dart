import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/sample/models/sample_item.dart';
import 'package:penta_crew/features/sample/presentation/cubit/sample_list_cubit.dart';
import 'package:penta_crew/features/sample/presentation/cubit/sample_list_state.dart';
import 'package:penta_crew/features/sample/usecases/get_sample_list.dart';

class _MockGetSampleList extends Mock implements GetSampleList {}

SampleItem _item(int id) => SampleItem(id: id, title: 'Item $id');

Paginated<SampleItem> _page(int page, {required int lastPage, int size = 2}) =>
    Paginated(
      data: [for (var i = 0; i < size; i++) _item(page * 10 + i)],
      currentPage: page,
      lastPage: lastPage,
      total: lastPage * size,
    );

void main() {
  late _MockGetSampleList getList;

  setUpAll(() {
    registerFallbackValue(const GetSampleListParams(page: 1));
  });

  setUp(() {
    getList = _MockGetSampleList();
  });

  void stubPage(int page, Result<Paginated<SampleItem>> result) {
    when(
      () => getList(any(that: predicate<GetSampleListParams>((p) => p.page == page))),
    ).thenAnswer((_) async => result);
  }

  group('fetch', () {
    blocTest<SampleListCubit, SampleListState>(
      'loading → loaded with hasReachedMax when single page',
      build: () {
        stubPage(1, Result.success(_page(1, lastPage: 1)));
        return SampleListCubit(getList);
      },
      act: (c) => c.fetch(),
      expect: () => [
        const SampleListState.loading(),
        isA<SampleListLoaded>()
            .having((s) => s.data.length, 'data', 2)
            .having((s) => s.hasReachedMax, 'hasReachedMax', true),
      ],
    );

    blocTest<SampleListCubit, SampleListState>(
      'loading → error without data on failure',
      build: () {
        stubPage(1, const Result.failed('boom'));
        return SampleListCubit(getList);
      },
      act: (c) => c.fetch(),
      expect: () => [
        const SampleListState.loading(),
        const SampleListState.error(message: 'boom'),
      ],
    );
  });

  group('loadMore', () {
    blocTest<SampleListCubit, SampleListState>(
      'appends next page and flips hasReachedMax at last page',
      build: () {
        stubPage(1, Result.success(_page(1, lastPage: 2)));
        stubPage(2, Result.success(_page(2, lastPage: 2)));
        return SampleListCubit(getList);
      },
      act: (c) async {
        await c.fetch();
        await c.loadMore();
      },
      skip: 2, // loading, loaded(page 1)
      expect: () => [
        isA<SampleListLoaded>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
        isA<SampleListLoaded>()
            .having((s) => s.data.length, 'data', 4)
            .having((s) => s.page, 'page', 2)
            .having((s) => s.hasReachedMax, 'hasReachedMax', true)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
    );

    blocTest<SampleListCubit, SampleListState>(
      'is a no-op when hasReachedMax',
      build: () {
        stubPage(1, Result.success(_page(1, lastPage: 1)));
        return SampleListCubit(getList);
      },
      act: (c) async {
        await c.fetch();
        await c.loadMore();
      },
      skip: 2,
      expect: () => isEmpty,
      verify: (_) => verifyNever(
        () => getList(any(that: predicate<GetSampleListParams>((p) => p.page == 2))),
      ),
    );

    blocTest<SampleListCubit, SampleListState>(
      'keeps existing data on failure: transient error then back to loaded',
      build: () {
        stubPage(1, Result.success(_page(1, lastPage: 3)));
        stubPage(2, const Result.failed('offline'));
        return SampleListCubit(getList);
      },
      act: (c) async {
        await c.fetch();
        await c.loadMore();
      },
      skip: 2,
      expect: () => [
        isA<SampleListLoaded>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
        isA<SampleListError>()
            .having((s) => s.message, 'message', 'offline')
            .having((s) => s.data.length, 'data kept', 2),
        isA<SampleListLoaded>()
            .having((s) => s.data.length, 'data', 2)
            .having((s) => s.page, 'page', 1)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
    );
  });

  group('refresh', () {
    blocTest<SampleListCubit, SampleListState>(
      'does not go through loading when data is already on screen',
      build: () {
        stubPage(1, Result.success(_page(1, lastPage: 1)));
        return SampleListCubit(getList);
      },
      act: (c) async {
        await c.fetch();
        // Server has new data now; identical data would be deduped by Cubit.
        stubPage(1, Result.success(_page(1, lastPage: 1, size: 3)));
        await c.refresh();
      },
      skip: 2,
      expect: () => [
        isA<SampleListLoaded>().having((s) => s.data.length, 'data', 3),
      ],
    );

    blocTest<SampleListCubit, SampleListState>(
      'on failure surfaces error with data, then restores previous list',
      build: () {
        stubPage(1, Result.success(_page(1, lastPage: 1)));
        return SampleListCubit(getList);
      },
      act: (c) async {
        await c.fetch();
        stubPage(1, const Result.failed('offline'));
        await c.refresh();
      },
      skip: 2,
      expect: () => [
        isA<SampleListError>().having((s) => s.data.length, 'data kept', 2),
        isA<SampleListLoaded>().having((s) => s.data.length, 'data', 2),
      ],
    );
  });
}
