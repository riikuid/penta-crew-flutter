import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/models/cannot_apply_reason.dart';
import 'package:penta_crew/features/events/models/event_detail.dart';
import 'package:penta_crew/features/events/presentation/cubit/event_detail_cubit.dart';
import 'package:penta_crew/features/events/presentation/cubit/event_detail_state.dart';
import 'package:penta_crew/features/events/presentation/event_detail_view.dart';
import 'package:penta_crew/features/events/usecases/apply_to_event.dart';
import 'package:penta_crew/features/events/usecases/get_event_detail.dart';
import 'package:penta_crew/features/events/usecases/withdraw_application.dart';

import 'fixtures.dart';

class _MockGetEventDetail extends Mock implements GetEventDetail {}

class _MockApplyToEvent extends Mock implements ApplyToEvent {}

class _MockWithdrawApplication extends Mock implements WithdrawApplication {}

void main() {
  late _MockGetEventDetail getEventDetail;
  late _MockApplyToEvent applyToEvent;
  late _MockWithdrawApplication withdrawApplication;

  setUpAll(() {
    registerFallbackValue(
      const ApplyToEventParams(eventId: 41, positionId: 7),
    );
    registerFallbackValue(const WithdrawApplicationParams(applicationId: 301));
  });

  setUp(() {
    getEventDetail = _MockGetEventDetail();
    applyToEvent = _MockApplyToEvent();
    withdrawApplication = _MockWithdrawApplication();
  });

  EventDetailCubit build() => EventDetailCubit(
    getEventDetail: getEventDetail,
    applyToEvent: applyToEvent,
    withdrawApplication: withdrawApplication,
  );

  void stubDetail(Result<EventDetail> result) =>
      when(() => getEventDetail(41)).thenAnswer((_) async => result);

  /// Stubs the detail twice: [first] for the fetch, [then] for the refetch.
  void stubDetailSequence(EventDetail first, EventDetail then) {
    var calls = 0;
    when(() => getEventDetail(41)).thenAnswer((_) async {
      calls++;
      return Result.success(calls == 1 ? first : then);
    });
  }

  group('fetch → derived view', () {
    final cases = <String, (EventDetail, EventDetailView)>{
      'C3 open, can apply': (detail(), EventDetailView.open),
      'C3 open, date conflict (D-09)': (
        detail(
          canApply: false,
          cannotApplyReason: CannotApplyReason.dateConflict,
        ),
        EventDetailView.open,
      ),
      'C5 waiting + open': (
        detail(canApply: false, myApplication: application()),
        EventDetailView.applied,
      ),
      'C7 waiting + closed': (
        detail(
          status: EventStatus.closed,
          canApply: false,
          cannotApplyReason: CannotApplyReason.closed,
          myApplication: application(),
        ),
        EventDetailView.closedWaiting,
      ),
      'C8 selected': (
        detail(
          status: EventStatus.closed,
          canApply: false,
          cannotApplyReason: CannotApplyReason.closed,
          myApplication: application(status: ApplicationStatus.selected),
          adminNote: 'All black.',
        ),
        EventDetailView.selected,
      ),
      'C9 not selected': (
        detail(
          status: EventStatus.closed,
          canApply: false,
          myApplication: application(status: ApplicationStatus.notSelected),
        ),
        EventDetailView.notSelected,
      ),
    };

    for (final MapEntry(key: name, value: (payload, view)) in cases.entries) {
      blocTest<EventDetailCubit, EventDetailState>(
        name,
        build: () {
          stubDetail(Result.success(payload));
          return build();
        },
        act: (cubit) => cubit.fetch(41),
        expect: () => [
          const EventDetailState.loading(),
          isA<EventDetailLoaded>()
              .having((state) => state.detail.view, 'view', view)
              .having((state) => state.busy, 'busy', false)
              .having((state) => state.notice, 'notice', isNull),
        ],
      );
    }

    blocTest<EventDetailCubit, EventDetailState>(
      'loading → error on failure, retry refetches',
      build: () {
        stubDetail(const Result.failed('Offline'));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch(41);
        stubDetail(Result.success(detail()));
        await cubit.retry();
      },
      expect: () => [
        const EventDetailState.loading(),
        const EventDetailState.error(message: 'Offline'),
        const EventDetailState.loading(),
        isA<EventDetailLoaded>(),
      ],
    );
  });

  group('apply', () {
    blocTest<EventDetailCubit, EventDetailState>(
      'busy → refetched detail (C5) with ApplicationSent notice',
      build: () {
        stubDetailSequence(
          detail(),
          detail(canApply: false, myApplication: application()),
        );
        when(
          () => applyToEvent(any()),
        ).thenAnswer((_) async => Result.success(application()));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch(41);
        await cubit.apply(7);
      },
      skip: 2,
      expect: () => [
        isA<EventDetailLoaded>().having((state) => state.busy, 'busy', true),
        isA<EventDetailLoaded>()
            .having((state) => state.busy, 'busy', false)
            .having(
              (state) => state.detail.view,
              'view',
              EventDetailView.applied,
            )
            .having(
              (state) => state.notice,
              'notice',
              isA<ApplicationSent>()
                  .having((notice) => notice.roleName, 'role', 'Crew')
                  .having(
                    (notice) => notice.eventTitle,
                    'title',
                    'Arunika annual gathering',
                  ),
            ),
      ],
      verify: (_) => verify(
        () => applyToEvent(
          any(
            that: predicate<ApplyToEventParams>(
              (params) => params.eventId == 41 && params.positionId == 7,
            ),
          ),
        ),
      ).called(1),
    );

    for (final (code, expected) in [
      ('date_conflict', 'You already have an event on this date'),
      ('closed', 'Applications for this event have closed'),
      ('already_applied', "You've already applied to this event"),
    ]) {
      blocTest<EventDetailCubit, EventDetailState>(
        '$code → per-code toast, then a silent refetch',
        build: () {
          stubDetailSequence(
            detail(),
            detail(
              canApply: false,
              cannotApplyReason: CannotApplyReason.dateConflict,
            ),
          );
          when(() => applyToEvent(any())).thenAnswer(
            (_) async => Result.failed('Server says no', code: code),
          );
          return build();
        },
        act: (cubit) async {
          await cubit.fetch(41);
          await cubit.apply(7);
        },
        skip: 2,
        expect: () => [
          isA<EventDetailLoaded>().having((state) => state.busy, 'busy', true),
          isA<EventDetailLoaded>()
              .having((state) => state.busy, 'busy', false)
              .having((state) => state.detail.canApply, 'stale detail', true)
              .having(
                (state) => state.notice,
                'notice',
                isA<ActionFailed>().having(
                  (notice) => notice.message,
                  'message',
                  expected,
                ),
              ),
          isA<EventDetailLoaded>()
              .having((state) => state.detail.canApply, 'refetched', false)
              .having((state) => state.notice, 'notice', isNull),
        ],
      );
    }

    blocTest<EventDetailCubit, EventDetailState>(
      'other failure → server message, no refetch',
      build: () {
        stubDetail(Result.success(detail()));
        when(
          () => applyToEvent(any()),
        ).thenAnswer((_) async => const Result.failed('Something went wrong'));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch(41);
        await cubit.apply(7);
      },
      skip: 3,
      expect: () => [
        isA<EventDetailLoaded>().having(
          (state) => state.notice,
          'notice',
          isA<ActionFailed>().having(
            (notice) => notice.message,
            'message',
            'Something went wrong',
          ),
        ),
      ],
      verify: (_) => verify(() => getEventDetail(41)).called(1),
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'ignored while busy',
      build: () {
        stubDetail(Result.success(detail()));
        when(() => applyToEvent(any())).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return Result.success(application());
        });
        return build();
      },
      act: (cubit) async {
        await cubit.fetch(41);
        await Future.wait([cubit.apply(7), cubit.apply(8)]);
      },
      verify: (_) => verify(() => applyToEvent(any())).called(1),
    );
  });

  group('withdraw', () {
    blocTest<EventDetailCubit, EventDetailState>(
      'busy → refetched detail (C3) with ApplicationWithdrawn notice',
      build: () {
        stubDetailSequence(
          detail(canApply: false, myApplication: application()),
          detail(),
        );
        when(
          () => withdrawApplication(any()),
        ).thenAnswer((_) async => const Result.success(null));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch(41);
        await cubit.withdraw();
      },
      skip: 2,
      expect: () => [
        isA<EventDetailLoaded>().having((state) => state.busy, 'busy', true),
        isA<EventDetailLoaded>()
            .having((state) => state.detail.view, 'view', EventDetailView.open)
            .having(
              (state) => state.notice,
              'notice',
              isA<ApplicationWithdrawn>().having(
                (notice) => notice.reapplyUntil,
                'reapplyUntil',
                deadline,
              ),
            ),
      ],
      verify: (_) => verify(
        () => withdrawApplication(
          any(
            that: predicate<WithdrawApplicationParams>(
              (params) => params.applicationId == 301,
            ),
          ),
        ),
      ).called(1),
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'deadline_passed → server message, then refetch renders C7',
      build: () {
        stubDetailSequence(
          detail(canApply: false, myApplication: application()),
          detail(
            status: EventStatus.closed,
            canApply: false,
            myApplication: application(),
          ),
        );
        when(() => withdrawApplication(any())).thenAnswer(
          (_) async => const Result.failed(
            'The deadline has passed.',
            code: 'deadline_passed',
          ),
        );
        return build();
      },
      act: (cubit) async {
        await cubit.fetch(41);
        await cubit.withdraw();
      },
      skip: 3,
      expect: () => [
        isA<EventDetailLoaded>().having(
          (state) => state.notice,
          'notice',
          isA<ActionFailed>().having(
            (notice) => notice.message,
            'message',
            'The deadline has passed.',
          ),
        ),
        isA<EventDetailLoaded>().having(
          (state) => state.detail.view,
          'view',
          EventDetailView.closedWaiting,
        ),
      ],
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'not_withdrawable → server message and refetch',
      build: () {
        stubDetail(
          Result.success(detail(canApply: false, myApplication: application())),
        );
        when(() => withdrawApplication(any())).thenAnswer(
          (_) async => const Result.failed(
            'This application cannot be withdrawn.',
            code: 'not_withdrawable',
          ),
        );
        return build();
      },
      act: (cubit) async {
        await cubit.fetch(41);
        await cubit.withdraw();
      },
      skip: 3,
      expect: () => [
        isA<EventDetailLoaded>().having(
          (state) => state.notice,
          'notice',
          isA<ActionFailed>().having(
            (notice) => notice.message,
            'message',
            'This application cannot be withdrawn.',
          ),
        ),
        isA<EventDetailLoaded>().having(
          (state) => state.notice,
          'notice cleared',
          isNull,
        ),
      ],
      verify: (_) => verify(() => getEventDetail(41)).called(2),
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'is a no-op without an application',
      build: () {
        stubDetail(Result.success(detail()));
        return build();
      },
      act: (cubit) async {
        await cubit.fetch(41);
        await cubit.withdraw();
      },
      skip: 2,
      expect: () => isEmpty,
      verify: (_) => verifyNever(() => withdrawApplication(any())),
    );
  });
}
