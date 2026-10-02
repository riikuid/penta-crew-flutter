import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/widgets/progress_timeline.dart';

import '../../helpers/pump_app.dart';

const _steps = [
  TimelineStep(label: 'Profile submitted', sublabel: '25 SEP 2026 · 09:40', state: TimelineStepState.done),
  TimelineStep(label: 'Admin review', sublabel: 'JAKARTA BRANCH · IN PROGRESS', state: TimelineStepState.current),
  TimelineStep(label: 'Roles assigned', sublabel: 'NEXT', state: TimelineStepState.upcoming),
];

void main() {
  testWidgets('vertical timeline renders labels, sublabels and a check for done', (tester) async {
    await tester.pumpApp(const ProgressTimeline(steps: _steps));

    expect(find.text('Profile submitted'), findsOneWidget);
    expect(find.text('25 SEP 2026 · 09:40'), findsOneWidget);
    expect(find.text('Roles assigned'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('bar timeline uppercases labels and draws one segment per step', (tester) async {
    await tester.pumpApp(
      const SizedBox(
        width: 320,
        child: ProgressTimeline.bar(
          steps: [
            TimelineStep(label: '25 Sep 10:12', state: TimelineStepState.done),
            TimelineStep(label: 'Closes 28 Sep', state: TimelineStepState.upcoming),
            TimelineStep(label: 'Result', state: TimelineStepState.upcoming),
          ],
        ),
      ),
    );

    expect(find.text('25 SEP 10:12'), findsOneWidget);
    expect(find.text('CLOSES 28 SEP'), findsOneWidget);
    expect(find.text('RESULT'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNothing);
  });
}
