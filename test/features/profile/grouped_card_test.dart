import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/features/profile/presentation/widgets/grouped_card.dart';

void main() {
  testWidgets('ActionRow paints ink inside the card on tap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: GroupedCard(
            children: [
              ActionRow(
                icon: Icons.edit,
                label: 'Edit profile',
                onTap: () => taps++,
              ),
            ],
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Edit profile')),
    );
    await tester.pump(const Duration(milliseconds: 100));

    final cardMaterial = find.descendant(
      of: find.byType(GroupedCard),
      matching: find.byType(Material),
    );
    expect(tester.renderObject(cardMaterial.first), paints..circle());
    await gesture.up();
    expect(taps, 1);
  });
}
