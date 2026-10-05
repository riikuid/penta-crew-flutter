import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/widgets/app_button.dart';
import 'package:penta_crew/core/widgets/progress_timeline.dart';
import 'package:penta_crew/core/widgets/skeleton.dart';
import 'package:penta_crew/core/widgets/state_views.dart';
import 'package:penta_crew/core/widgets/status_pill.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/models/cannot_apply_reason.dart';
import 'package:penta_crew/features/events/models/event_detail.dart';
import 'package:penta_crew/features/events/presentation/cubit/event_detail_cubit.dart';
import 'package:penta_crew/features/events/presentation/cubit/event_detail_state.dart';
import 'package:penta_crew/features/events/presentation/screens/event_detail_screen.dart';
import 'package:penta_crew/features/events/presentation/widgets/apply_sheet.dart';
import 'package:penta_crew/features/events/presentation/widgets/withdraw_sheet.dart';

import 'fixtures.dart';

class _MockEventDetailCubit extends MockCubit<EventDetailState>
    implements EventDetailCubit {}

void main() {
  late _MockEventDetailCubit cubit;

  setUp(() {
    cubit = _MockEventDetailCubit();
    when(() => cubit.retry()).thenAnswer((_) async {});
    when(() => cubit.apply(any())).thenAnswer((_) async {});
    when(() => cubit.withdraw()).thenAnswer((_) async {});
  });

  Future<void> pumpScreen(WidgetTester tester, EventDetailState state) async {
    tester.view.physicalSize = const Size(480, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    whenListen(
      cubit,
      const Stream<EventDetailState>.empty(),
      initialState: state,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: BlocProvider<EventDetailCubit>.value(
          value: cubit,
          child: EventDetailScreen(now: now),
        ),
      ),
    );
    await tester.pump();
  }

  AppButton button(WidgetTester tester, String label) =>
      tester.widget<AppButton>(find.widgetWithText(AppButton, label));

  testWidgets('loading: skeleton blocks, back button, no branch', (
    tester,
  ) async {
    await pumpScreen(tester, const EventDetailState.loading());

    expect(find.byType(Skeleton), findsNWidgets(5));
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.textContaining('BRANCH'), findsNothing);
  });

  testWidgets('error: ErrorView with retry', (tester) async {
    await pumpScreen(tester, const EventDetailState.error(message: 'Offline'));

    expect(find.byType(ErrorView), findsOneWidget);
    await tester.tap(find.text('Try again'));
    verify(() => cubit.retry()).called(1);
  });

  group('C3 open', () {
    testWidgets('header, hero, deadline, positions, requirements, Apply', (
      tester,
    ) async {
      await pumpScreen(tester, EventDetailState.loaded(detail: detail()));

      expect(find.text('JAKARTA BRANCH'), findsOneWidget);
      expect(find.text('Arunika annual gathering'), findsOneWidget);
      expect(find.text('05'), findsOneWidget);
      expect(find.text('OCT 2026'), findsOneWidget);
      expect(find.text('MONDAY'), findsOneWidget);
      expect(find.text('14:00–20:00 · 6 hours'), findsOneWidget);
      expect(find.text('JIExpo Kemayoran, Hall B'), findsOneWidget);
      expect(find.text('Jl. Benyamin Sueb, Jakarta Pusat'), findsOneWidget);
      expect(find.text('Apply by Mon, 28 Sep · 18:00'), findsOneWidget);
      expect(find.text('3 DAYS LEFT'), findsOneWidget);
      expect(find.text('Positions'), findsOneWidget);
      expect(find.text('Event Manager'), findsOneWidget);
      expect(find.text('Crew'), findsOneWidget);
      expect(find.text('Trainee'), findsOneWidget);
      expect(find.text('Matches your role'), findsNWidgets(2));
      expect(find.text('Not one of your roles'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text('02 NEEDED'), findsOneWidget);
      expect(find.text('06 NEEDED'), findsOneWidget);
      expect(find.text('01 NEEDED'), findsOneWidget);
      expect(find.text('Requirements'), findsOneWidget);
      expect(find.text('Usher'), findsOneWidget);
      expect(find.text('Registration desk'), findsOneWidget);
      expect(find.text('Any gender'), findsOneWidget);
      expect(
        find.text(
          'All black, closed shoes. Briefing at 13:00 at the Hall B loading dock. Meals provided.',
        ),
        findsOneWidget,
      );
      expect(button(tester, 'Apply').onPressed, isNotNull);
      expect(
        find.text("Can't make it? You don't need to do anything."),
        findsOneWidget,
      );
    });

    testWidgets('date conflict: Apply disabled with the reason line', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        EventDetailState.loaded(
          detail: detail(
            canApply: false,
            cannotApplyReason: CannotApplyReason.dateConflict,
          ),
        ),
      );

      expect(button(tester, 'Apply').onPressed, isNull);
      expect(find.text("You're already booked on this date."), findsOneWidget);
    });

    testWidgets('no matching role: Apply disabled with the reason line', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        EventDetailState.loaded(
          detail: detail(
            canApply: false,
            cannotApplyReason: CannotApplyReason.noMatchingRole,
          ),
        ),
      );

      expect(button(tester, 'Apply').onPressed, isNull);
      expect(
        find.text('None of these positions match your roles.'),
        findsOneWidget,
      );
    });

    testWidgets('closed without an application: no action bar', (tester) async {
      await pumpScreen(
        tester,
        EventDetailState.loaded(
          detail: detail(
            status: EventStatus.closed,
            canApply: false,
            cannotApplyReason: CannotApplyReason.closed,
          ),
        ),
      );

      expect(find.byType(AppButton), findsNothing);
      expect(find.text('CLOSED 28 SEP'), findsOneWidget);
    });

    testWidgets('Apply opens the C4 sheet; confirming calls apply(position)', (
      tester,
    ) async {
      await pumpScreen(tester, EventDetailState.loaded(detail: detail()));

      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(find.byType(ApplySheet), findsOneWidget);
      expect(find.text('Apply as'), findsOneWidget);

      // Default is the first matching position (Event Manager, id 8); pick
      // Crew (id 7) then send.
      await tester.tap(find.text('Crew').last);
      await tester.pump();
      await tester.tap(find.text('Send application'));
      await tester.pumpAndSettle();

      expect(find.byType(ApplySheet), findsNothing);
      verify(() => cubit.apply(7)).called(1);
    });

    testWidgets('busy: Apply shows the spinner', (tester) async {
      await pumpScreen(
        tester,
        EventDetailState.loaded(detail: detail(), busy: true),
      );

      expect(button(tester, 'Apply').loading, isTrue);
    });
  });

  group('C5 applied', () {
    final applied = detail(canApply: false, myApplication: application());

    testWidgets('waiting pill on blush, bar, body, rows, Withdraw', (
      tester,
    ) async {
      await pumpScreen(tester, EventDetailState.loaded(detail: applied));

      expect(find.text('WAITING FOR SELECTION'), findsOneWidget);
      final pill = tester.widget<StatusPill>(find.byType(StatusPill));
      expect(pill.tone, PillTone.surface, reason: 'white pill on blush');
      expect(find.text('Applied as Crew'), findsOneWidget);
      expect(find.text('25 SEP 10:12'), findsOneWidget);
      expect(find.text('CLOSES 28 SEP'), findsOneWidget);
      expect(find.text('RESULT'), findsOneWidget);
      final steps = tester
          .widget<ProgressTimeline>(find.byType(ProgressTimeline))
          .steps
          .map((step) => step.state)
          .toList();
      expect(steps, [
        TimelineStepState.done,
        TimelineStepState.upcoming,
        TimelineStepState.upcoming,
      ]);
      expect(
        find.text("You'll get a notification when the admin picks the crew."),
        findsOneWidget,
      );
      expect(find.text('Monday, 5 October 2026'), findsOneWidget);
      expect(find.text('14:00–20:00 · 6 hours'), findsOneWidget);
      final withdraw = button(tester, 'Withdraw application');
      expect(withdraw.variant, AppButtonVariant.outlinedInk);
      expect(withdraw.onPressed, isNotNull);
      expect(find.text('Apply'), findsNothing);
    });

    testWidgets('Withdraw opens C6; confirming calls withdraw()', (
      tester,
    ) async {
      await pumpScreen(tester, EventDetailState.loaded(detail: applied));

      await tester.tap(find.text('Withdraw application'));
      await tester.pumpAndSettle();
      expect(find.byType(WithdrawSheet), findsOneWidget);
      await tester.tap(find.text('Withdraw'));
      await tester.pumpAndSettle();

      expect(find.byType(WithdrawSheet), findsNothing);
      verify(() => cubit.withdraw()).called(1);
    });

    testWidgets('"Keep application" dismisses without withdrawing', (
      tester,
    ) async {
      await pumpScreen(tester, EventDetailState.loaded(detail: applied));

      await tester.tap(find.text('Withdraw application'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep application'));
      await tester.pumpAndSettle();

      expect(find.byType(WithdrawSheet), findsNothing);
      verifyNever(() => cubit.withdraw());
    });
  });

  testWidgets('C7 closed + waiting: lock note, Closed step, no action', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      EventDetailState.loaded(
        detail: detail(
          status: EventStatus.closed,
          canApply: false,
          cannotApplyReason: CannotApplyReason.closed,
          myApplication: application(),
        ),
      ),
    );

    expect(find.text('WAITING FOR SELECTION'), findsOneWidget);
    final pill = tester.widget<StatusPill>(find.byType(StatusPill));
    expect(pill.tone, PillTone.accent, reason: 'blush pill on white');
    expect(find.text('CLOSED 28 SEP'), findsOneWidget);
    final steps = tester
        .widget<ProgressTimeline>(find.byType(ProgressTimeline))
        .steps
        .map((step) => step.state)
        .toList();
    expect(steps, [
      TimelineStepState.done,
      TimelineStepState.done,
      TimelineStepState.upcoming,
    ]);
    expect(
      find.text("Applications closed. This can't be changed now."),
      findsOneWidget,
    );
    expect(find.byType(AppButton), findsNothing);
  });

  group('C8 selected', () {
    testWidgets('hero, briefing row, notes from admin, no action', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        EventDetailState.loaded(
          detail: detail(
            status: EventStatus.closed,
            canApply: false,
            myApplication: application(status: ApplicationStatus.selected),
            adminNote: 'All black, closed shoes. Briefing at 13:00 at the Hall B loading dock. Meals provided.',
          ),
        ),
      );

      expect(find.text('SELECTED'), findsOneWidget);
      expect(find.text("You're on the crew."), findsOneWidget);
      expect(
        find.text(
          "Confirmed as Crew for Arunika annual gathering. It's now in your schedule.",
        ),
        findsOneWidget,
      );
      expect(find.text('Monday, 5 October 2026'), findsOneWidget);
      expect(find.text('14:00–20:00 · BRIEFING 13:00'), findsOneWidget);
      expect(find.text('NOTES FROM ADMIN'), findsOneWidget);
      expect(
        find.text(
          'All black, closed shoes. Briefing at 13:00 at the Hall B loading dock. Meals provided.',
        ),
        findsOneWidget,
      );
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('uses the admin placement and hides empty notes/briefing', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        EventDetailState.loaded(
          detail: detail(
            status: EventStatus.closed,
            canApply: false,
            briefingTime: null,
            myApplication: application(
              status: ApplicationStatus.selected,
              assignedPosition: const ApplicationPosition(
                id: 8,
                role: managerRole,
              ),
            ),
          ),
        ),
      );

      expect(
        find.text(
          "Confirmed as Event Manager for Arunika annual gathering. It's now in your schedule.",
        ),
        findsOneWidget,
      );
      expect(find.text('14:00–20:00'), findsOneWidget);
      expect(find.text('NOTES FROM ADMIN'), findsNothing);
    });
  });

  testWidgets('C9 not selected: pill, thanks, rows, Browse open events', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      EventDetailState.loaded(
        detail: detail(
          status: EventStatus.closed,
          canApply: false,
          myApplication: application(status: ApplicationStatus.notSelected),
        ),
      ),
    );

    expect(find.text('Arunika annual gathering'), findsOneWidget);
    expect(find.text('NOT SELECTED'), findsOneWidget);
    expect(
      find.text(
        'All positions for this event have been filled. Thanks for applying as Crew.',
      ),
      findsOneWidget,
    );
    expect(find.text('Monday, 5 October 2026'), findsOneWidget);
    expect(find.text('14:00–20:00'), findsOneWidget);
    final browse = button(tester, 'Browse open events');
    expect(browse.variant, AppButtonVariant.secondary);
  });
}
