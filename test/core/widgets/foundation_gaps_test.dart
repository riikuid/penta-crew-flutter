// Covers the foundation fixes from TASK-028 (TASK-006 gap audit).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/theme/app_colors.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/widgets/app_button.dart';
import 'package:penta_crew/core/widgets/app_toast.dart';
import 'package:penta_crew/core/widgets/floating_pill_nav.dart';
import 'package:penta_crew/core/widgets/labeled_field.dart';
import 'package:penta_crew/core/widgets/progress_timeline.dart';
import 'package:penta_crew/core/widgets/segmented_tabs.dart';
import 'package:penta_crew/core/widgets/skeleton.dart';
import 'package:penta_crew/core/widgets/state_views.dart';
import 'package:penta_crew/core/widgets/tag_chip.dart';
import 'package:toastification/toastification.dart';

import '../../helpers/pump_app.dart';

Text _textOf(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text));

/// toastification inserts the entry a frame later and then animates it in.
Future<void> showToastFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  group('AppToast', () {
    testWidgets('renders title + description in the brand card', (
      tester,
    ) async {
      await tester.pumpWidget(
        ToastificationWrapper(
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: SizedBox()),
          ),
        ),
      );

      AppToast.success(
        'Application withdrawn',
        description: 'You can apply again before the deadline.',
      );
      await showToastFrames(tester);

      expect(find.text('Application withdrawn'), findsOneWidget);
      expect(
        find.text('You can apply again before the deadline.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(_textOf(tester, 'Application withdrawn').style?.fontSize, 15);
      expect(
        _textOf(
          tester,
          'You can apply again before the deadline.',
        ).style?.fontSize,
        13,
      );

      // Error keeps the same card but swaps the circle to the error red.
      AppToast.error('Could not withdraw');
      await showToastFrames(tester);
      final circle = tester.widget<Container>(
        find
            .ancestor(
              of: find.byIcon(Icons.close),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((circle.decoration! as BoxDecoration).color, AppColors.error);

      // Let the 3 s auto-close timers finish so the test ends clean.
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });
  });

  group('AppButton.outlinedInk', () {
    testWidgets('draws a 1px ink border on a transparent fill', (tester) async {
      await tester.pumpApp(
        AppButton(
          label: 'Withdraw application',
          onPressed: () {},
          variant: AppButtonVariant.outlinedInk,
        ),
      );

      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final style = button.style!;
      final side = style.side!.resolve({})!;
      expect(side.color, AppColors.ink);
      expect(side.width, 1);
      expect(style.backgroundColor!.resolve({}), Colors.transparent);
      expect(side.color, isNot(AppColors.line));

      // Disabled falls back to the hairline so it reads as inactive.
      expect(
        style.side!.resolve({WidgetState.disabled})!.color,
        AppColors.line,
      );
    });
  });

  group('Field error row', () {
    testWidgets('validator and server errors both get the alert icon', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpApp(
        Form(
          key: formKey,
          child: Column(
            children: [
              const AppTextField(label: 'Email', errorText: 'Already taken'),
              AppTextField(
                label: 'Password',
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Required' : null,
              ),
            ],
          ),
        ),
      );

      expect(find.text('Already taken'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Required'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNWidgets(2));
      expect(find.byType(FieldError), findsNWidgets(2));

      final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline).first);
      expect(icon.size, 16);
      expect(icon.color, AppColors.error);
      expect(_textOf(tester, 'Required').style?.fontSize, 14);
      expect(_textOf(tester, 'Required').style?.color, AppColors.error);
    });
  });

  group('SegmentedTabs counts', () {
    testWidgets('renders an 11px count after the label', (tester) async {
      await tester.pumpApp(
        SegmentedTabs(
          labels: const ['Open', 'Tracked'],
          counts: const ['03', null],
          index: 0,
          onChanged: (_) {},
        ),
      );

      expect(find.text('03'), findsOneWidget);
      final count = _textOf(tester, '03');
      expect(count.style?.fontSize, 11);
      expect(count.style?.color, AppColors.surface.withValues(alpha: 0.7));

      // Inactive count is muted.
      await tester.pumpApp(
        SegmentedTabs(
          labels: const ['Open', 'Tracked'],
          counts: const ['03', '01'],
          index: 1,
          onChanged: (_) {},
        ),
      );
      expect(_textOf(tester, '03').style?.color, AppColors.muted);
    });
  });

  group('Skeleton', () {
    testWidgets('accepts a custom fill and border', (tester) async {
      await tester.pumpApp(
        const Column(
          children: [
            Skeleton.card(height: 120, color: AppColors.accent),
            Skeleton.card(
              height: 80,
              color: AppColors.surface,
              borderColor: AppColors.line,
            ),
            Skeleton.line(width: 100),
          ],
        ),
      );

      final boxes = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration! as BoxDecoration)
          .toList();
      expect(boxes[0].color, AppColors.accent);
      expect(boxes[0].border, isNull);
      expect(boxes[1].color, AppColors.surface);
      expect(boxes[1].border!.top.color, AppColors.line);
      expect(boxes[2].color, AppColors.line);
      expect(boxes[2].border, isNull);
    });
  });

  group('FloatingPillNav inactive items', () {
    testWidgets('are ink at 22px, the active icon stays 20px', (tester) async {
      await tester.pumpApp(
        FloatingPillNav(
          index: 0,
          onChanged: (_) {},
          items: const [
            FloatingPillNavItem(icon: Icons.home_outlined, label: 'Home'),
            FloatingPillNavItem(icon: Icons.event_outlined, label: 'Events'),
          ],
        ),
      );

      final active = tester.widget<Icon>(find.byIcon(Icons.home_outlined));
      final inactive = tester.widget<Icon>(find.byIcon(Icons.event_outlined));
      expect(active.size, 20);
      expect(active.color, AppColors.surface);
      expect(inactive.size, 22);
      expect(inactive.color, AppColors.ink);
    });
  });

  group('TagChip', () {
    testWidgets('keeps natural case and renders the three tones', (
      tester,
    ) async {
      await tester.pumpApp(
        const Column(
          children: [
            TagChip(label: 'Crew'),
            TagChip(label: 'as Crew', tone: TagChipTone.accent, height: 32),
            TagChip(label: 'Usher', tone: TagChipTone.outlined, height: 26),
          ],
        ),
      );

      expect(find.text('Crew'), findsOneWidget);
      expect(find.text('as Crew'), findsOneWidget);
      expect(find.text('CREW'), findsNothing);

      final chips = find.byType(TagChip);
      ShapeDecoration decorationAt(int index) =>
          tester
                  .widget<Container>(
                    find
                        .descendant(
                          of: chips.at(index),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration!
              as ShapeDecoration;

      expect(decorationAt(0).color, AppColors.background);
      expect(decorationAt(1).color, AppColors.accent);
      expect(decorationAt(2).color, AppColors.surface);
      expect(
        (decorationAt(2).shape as StadiumBorder).side.color,
        AppColors.line,
      );

      expect(tester.getSize(chips.at(0)).height, 30);
      expect(tester.getSize(chips.at(1)).height, 32);
      expect(tester.getSize(chips.at(2)).height, 26);
      expect(_textOf(tester, 'Crew').style?.fontSize, 13);
      expect(_textOf(tester, 'Usher').style?.fontSize, 12);
    });

    testWidgets('sizes to its content and wraps inline', (tester) async {
      await tester.pumpApp(
        const SizedBox(
          width: 360,
          child: Wrap(
            spacing: 8,
            children: [
              TagChip(label: 'Crew'),
              TagChip(label: 'Event Manager'),
            ],
          ),
        ),
      );

      final chips = find.byType(TagChip);
      expect(tester.getSize(chips.at(0)).width, lessThan(100));
      expect(
        tester.getTopLeft(chips.at(0)).dy,
        tester.getTopLeft(chips.at(1)).dy,
      );
    });
  });

  group('ProgressTimeline.bar labels', () {
    testWidgets('start-align every label except the last', (tester) async {
      await tester.pumpApp(
        const SizedBox(
          width: 320,
          child: ProgressTimeline.bar(
            steps: [
              TimelineStep(label: 'Applied', state: TimelineStepState.done),
              TimelineStep(label: 'Closes', state: TimelineStepState.upcoming),
              TimelineStep(label: 'Result', state: TimelineStepState.upcoming),
            ],
          ),
        ),
      );

      expect(_textOf(tester, 'APPLIED').textAlign, TextAlign.start);
      expect(_textOf(tester, 'CLOSES').textAlign, TextAlign.start);
      expect(_textOf(tester, 'RESULT').textAlign, TextAlign.end);
    });
  });

  group('EmptyView', () {
    testWidgets('body is 15px with 14px gaps', (tester) async {
      await tester.pumpApp(
        const EmptyView(
          title: 'Nothing open right now',
          message: 'New events appear here as soon as admins post them.',
        ),
      );

      final body = _textOf(
        tester,
        'New events appear here as soon as admins post them.',
      );
      expect(body.style?.fontSize, 15);
      expect(body.style?.color, AppColors.muted);

      final titleBottom = tester
          .getBottomLeft(find.text('Nothing open right now'))
          .dy;
      final bodyTop = tester
          .getTopLeft(
            find.text('New events appear here as soon as admins post them.'),
          )
          .dy;
      expect(bodyTop - titleBottom, 14);
    });
  });
}
