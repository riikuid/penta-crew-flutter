import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/theme/app_colors.dart';
import 'package:penta_crew/core/widgets/floating_pill_nav.dart';
import 'package:penta_crew/core/widgets/segmented_tabs.dart';
import 'package:penta_crew/core/widgets/status_pill.dart';

import '../../helpers/pump_app.dart';

ShapeDecoration _decorationOf(WidgetTester tester, Finder pill) {
  final container = tester.widget<Container>(
    find.descendant(of: pill, matching: find.byType(Container)).first,
  );
  return container.decoration! as ShapeDecoration;
}

void main() {
  group('StatusPill', () {
    testWidgets('domain presets use the prototype tones (no green)', (
      tester,
    ) async {
      await tester.pumpApp(
        const Column(
          children: [
            StatusPill.selected(),
            StatusPill.waiting(),
            StatusPill.notSelected(),
            StatusPill.notApproved(),
            StatusPill.completed(small: true),
          ],
        ),
      );

      expect(find.text('SELECTED'), findsOneWidget);
      expect(find.text('WAITING FOR SELECTION'), findsOneWidget);
      expect(find.text('NOT SELECTED'), findsOneWidget);
      expect(find.text('NOT APPROVED'), findsOneWidget);
      expect(find.text('COMPLETED'), findsOneWidget);

      final pills = find.byType(StatusPill);
      expect(_decorationOf(tester, pills.at(0)).color, AppColors.ink);
      expect(_decorationOf(tester, pills.at(1)).color, AppColors.accent);

      final notSelected = _decorationOf(tester, pills.at(2));
      expect(notSelected.color, isNull);
      expect((notSelected.shape as StadiumBorder).side.color, AppColors.line);

      final notApproved = _decorationOf(tester, pills.at(3));
      expect((notApproved.shape as StadiumBorder).side.color, AppColors.error);

      expect(tester.getSize(pills.at(0)).height, 28);
      expect(tester.getSize(pills.at(4)).height, 26);
    });
  });

  group('SegmentedTabs', () {
    testWidgets('highlights the selected tab and reports taps', (
      tester,
    ) async {
      int? changed;
      await tester.pumpApp(
        SegmentedTabs(
          labels: const ['Open', 'Tracked'],
          index: 0,
          onChanged: (i) => changed = i,
        ),
      );

      await tester.tap(find.text('Open'));
      expect(changed, isNull); // already selected → no-op

      await tester.tap(find.text('Tracked'));
      expect(changed, 1);

      final open = tester.widget<Text>(find.text('Open'));
      final tracked = tester.widget<Text>(find.text('Tracked'));
      expect(open.style?.color, AppColors.surface);
      expect(tracked.style?.color, AppColors.ink);
    });
  });

  group('FloatingPillNav', () {
    testWidgets('shows the label only on the active item', (tester) async {
      int? changed;
      await tester.pumpApp(
        FloatingPillNav(
          index: 1,
          onChanged: (i) => changed = i,
          items: const [
            FloatingPillNavItem(icon: Icons.home_outlined, label: 'Home'),
            FloatingPillNavItem(icon: Icons.event_outlined, label: 'Events'),
            FloatingPillNavItem(icon: Icons.person_outline, label: 'Profile'),
          ],
        ),
      );

      expect(find.text('Events'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
      expect(find.text('Profile'), findsNothing);

      await tester.tap(find.byIcon(Icons.person_outline));
      expect(changed, 2);
    });
  });
}
