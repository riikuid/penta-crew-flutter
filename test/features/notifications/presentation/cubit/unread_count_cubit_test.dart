import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/usecase/usecase.dart';
import 'package:penta_crew/features/notifications/presentation/cubit/unread_count_cubit.dart';
import 'package:penta_crew/features/notifications/usecases/get_unread_count.dart';

class _MockGetUnreadCount extends Mock implements GetUnreadCount {}

void main() {
  late _MockGetUnreadCount getUnreadCount;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getUnreadCount = _MockGetUnreadCount();
  });

  UnreadCountCubit buildCubit() =>
      UnreadCountCubit(getUnreadCount: getUnreadCount);

  test('starts at zero', () {
    expect(buildCubit().state, 0);
  });

  group('fetch', () {
    blocTest<UnreadCountCubit, int>(
      'emits the server count on success',
      build: () {
        when(() => getUnreadCount(any()))
            .thenAnswer((_) async => const Result.success(3));
        return buildCubit();
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [3],
      verify: (_) => verify(() => getUnreadCount(const NoParams())).called(1),
    );

    blocTest<UnreadCountCubit, int>(
      'keeps the current value on failure',
      build: () {
        when(() => getUnreadCount(any()))
            .thenAnswer((_) async => const Result.failed('offline'));
        return buildCubit();
      },
      seed: () => 4,
      act: (cubit) => cubit.fetch(),
      expect: () => <int>[],
    );

    blocTest<UnreadCountCubit, int>(
      'floors a negative server count at zero',
      build: () {
        when(() => getUnreadCount(any()))
            .thenAnswer((_) async => const Result.success(-2));
        return buildCubit();
      },
      seed: () => 4,
      act: (cubit) => cubit.fetch(),
      expect: () => [0],
    );
  });

  blocTest<UnreadCountCubit, int>(
    'set replaces the count',
    build: buildCubit,
    act: (cubit) => cubit.set(7),
    expect: () => [7],
  );

  group('decrement', () {
    blocTest<UnreadCountCubit, int>(
      'takes one off',
      build: buildCubit,
      seed: () => 2,
      act: (cubit) => cubit.decrement(),
      expect: () => [1],
    );

    blocTest<UnreadCountCubit, int>(
      'never goes below zero',
      build: buildCubit,
      seed: () => 1,
      act: (cubit) => cubit
        ..decrement()
        ..decrement()
        ..decrement(),
      expect: () => [0],
    );
  });

  blocTest<UnreadCountCubit, int>(
    'clear zeroes the count',
    build: buildCubit,
    seed: () => 5,
    act: (cubit) => cubit.clear(),
    expect: () => [0],
  );
}
