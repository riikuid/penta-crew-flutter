import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/widgets/app_button.dart';
import 'package:penta_crew/features/events/presentation/widgets/apply_sheet.dart';
import 'package:penta_crew/features/events/presentation/widgets/withdraw_sheet.dart';

import 'fixtures.dart';

void main() {
  /// Pumps a page with one button that opens the sheet and records what it
  /// resolves with.
  Future<void> pumpOpener(
    WidgetTester tester,
    Future<Object?> Function(BuildContext context) open,
    void Function(Object? result) onResult,
  ) async {
    tester.view.physicalSize = const Size(480, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async => onResult(await open(context)),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('ApplySheet (C4)', () {
    testWidgets('lists positions, locks non-matching, resolves with the pick', (
      tester,
    ) async {
      Object? result;
      await pumpOpener(
        tester,
        (context) => ApplySheet.show(context, detail: detail()),
        (value) => result = value,
      );

      expect(find.text('MON 05 OCT · 14:00–20:00'), findsOneWidget);
      expect(find.text('Apply as'), findsOneWidget);
      expect(find.text('Event Manager'), findsOneWidget);
      expect(find.text('Crew'), findsOneWidget);
      expect(find.text('Trainee'), findsOneWidget);
      expect(find.text('02 NEEDED'), findsOneWidget);
      expect(find.text('06 NEEDED'), findsOneWidget);
      expect(find.text('01 NEEDED'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget, reason: 'one selected');
      expect(
        find.text('You can withdraw until Mon, 28 Sep · 18:00.'),
        findsOneWidget,
      );

      // Tapping the locked position does nothing; tapping Crew moves the
      // check.
      await tester.tap(find.text('Trainee'));
      await tester.pump();
      await tester.tap(find.text('Crew'));
      await tester.pump();
      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(find.text('Send application'));
      await tester.pumpAndSettle();
      expect(result, 7);
      expect(find.byType(ApplySheet), findsNothing);
    });

    testWidgets(
      'single matching position: plain confirm titled with the role',
      (tester) async {
        Object? result;
        await pumpOpener(
          tester,
          (context) => ApplySheet.show(
            context,
            detail: detail(positions: const [crewPosition, traineePosition]),
          ),
          (value) => result = value,
        );

        expect(find.text('Apply as Crew'), findsOneWidget);
        expect(find.text('06 NEEDED'), findsNothing, reason: 'no option list');
        await tester.tap(find.text('Send application'));
        await tester.pumpAndSettle();
        expect(result, 7);
      },
    );

    testWidgets('no matching position: Send is disabled', (tester) async {
      await pumpOpener(
        tester,
        (context) => ApplySheet.show(
          context,
          detail: detail(positions: const [traineePosition]),
        ),
        (_) {},
      );

      final send = tester.widget<AppButton>(
        find.widgetWithText(AppButton, 'Send application'),
      );
      expect(send.onPressed, isNull);
    });

    testWidgets('dismissing resolves with null', (tester) async {
      Object? result = 'untouched';
      await pumpOpener(
        tester,
        (context) => ApplySheet.show(context, detail: detail()),
        (value) => result = value,
      );

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(result, isNull);
    });
  });

  group('WithdrawSheet (C6)', () {
    testWidgets('copy, Withdraw → true', (tester) async {
      Object? result;
      await pumpOpener(
        tester,
        (context) => WithdrawSheet.show(context, closesAt: deadline),
        (value) => result = value,
      );

      expect(find.text('Withdraw application?'), findsOneWidget);
      expect(
        find.text('You can apply again until Mon, 28 Sep · 18:00.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Withdraw'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('Keep application → false', (tester) async {
      Object? result;
      await pumpOpener(
        tester,
        (context) => WithdrawSheet.show(context, closesAt: deadline),
        (value) => result = value,
      );

      final keep = tester.widget<AppButton>(
        find.widgetWithText(AppButton, 'Keep application'),
      );
      expect(keep.variant, AppButtonVariant.ghost);
      await tester.tap(find.text('Keep application'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });
  });
}
