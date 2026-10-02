import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/widgets/status_pill.dart';
import 'package:penta_crew/features/events/models/event.dart';
import 'package:penta_crew/features/events/presentation/widgets/event_card.dart';

import '../../helpers/pump_app.dart';
import 'event_models_test.dart' show eventJson;

void main() {
  final now = DateTime(2026, 10, 2, 9);
  final event = Event.fromJson(eventJson);

  testWidgets('list card: date stamp, urgent chip, only matching positions, arrow', (tester) async {
    var tapped = false;
    await tester.pumpApp(
      SizedBox(width: 362, child: EventCard(event: event, now: now, onTap: () => tapped = true)),
    );

    expect(find.text('MON 05 OCT'), findsOneWidget);
    expect(find.text('Arunika annual gathering'), findsOneWidget);
    expect(find.text('14:00 – 20:00 · JIExpo Kemayoran, Hall B'), findsOneWidget);
    expect(find.text('Crew'), findsOneWidget);
    expect(find.text('Trainee'), findsNothing, reason: 'non-matching positions are hidden');
    expect(find.byIcon(Icons.schedule), findsOneWidget, reason: 'urgent → clock chip');
    expect(find.byIcon(Icons.arrow_outward), findsOneWidget);

    await tester.tap(find.byType(EventCard));
    expect(tapped, isTrue);
  });

  testWidgets('list card: calm deadline chip when not urgent', (tester) async {
    final calm = event.copyWith(isUrgent: false, applyDeadline: DateTime(2026, 10, 12, 23, 59));
    await tester.pumpApp(SizedBox(width: 362, child: EventCard(event: calm, now: now)));

    expect(find.text('APPLY BY 12 OCT'), findsOneWidget);
    expect(find.byIcon(Icons.schedule), findsNothing);
    final pill = tester.widget<StatusPill>(find.byType(StatusPill));
    expect(pill.tone, PillTone.outlined);
  });

  testWidgets('compact card is 250 wide with date pill and blush deadline', (tester) async {
    await tester.pumpApp(EventCard.compact(event: event, now: now));

    expect(tester.getSize(find.byType(EventCard)).width, EventCard.compactWidth);
    expect(find.text('MON 05 OCT'), findsOneWidget);
    // Contract sample deadline (28 Sep) is already past on 2 Oct.
    expect(find.text('LAST DAY'), findsOneWidget);
    expect(find.text('Crew'), findsNothing, reason: 'compact has no position chips');
  });
}
