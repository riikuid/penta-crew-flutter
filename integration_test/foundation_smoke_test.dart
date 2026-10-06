import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:penta_crew/core/widgets/floating_pill_nav.dart';
import 'package:penta_crew/main.dart' as app;

/// Device/simulator smoke test with `USE_MOCK=true` (TASK-004 acceptance,
/// updated for the Wave 2 screens): nadia → Home with the pill nav, all four
/// tabs reachable, sign out from Profile via the confirm sheet; pending →
/// parked on /verification (A6); rejected → A7; wrong password → inline A3
/// error. Run with `flutter drive` (see test_driver/integration_test.dart) to
/// get the screenshots written to build/screenshots/.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> settle(WidgetTester tester, [int seconds = 2]) async {
    // The mock answers in 300–800 ms; pumpAndSettle would also wait for the
    // skeleton pulse, so pump a fixed window instead.
    final end = DateTime.now().add(Duration(seconds: seconds));
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> signIn(
    WidgetTester tester,
    String email,
    String password,
  ) async {
    // `enterText` right after the app's unfocus() is silently dropped on a
    // simulator; tap to attach the input client first.
    for (final (index, value) in [(0, email), (1, password)]) {
      final field = find.byType(TextFormField).at(index);
      await tester.tap(field);
      await settle(tester, 1);
      await tester.enterText(field, value);
    }
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await settle(tester, 3);
  }

  /// Taps the danger "Sign out" button on the current screen (E1, A6, A7),
  /// confirms in the sheet (plan §2.7) and expects to land back on A2.
  Future<void> signOut(WidgetTester tester) async {
    // A6/A7 render a ghost TextButton, E1 an icon OutlinedButton (a private
    // subclass, so match on the label). With the sheet open the label occurs
    // twice; the sheet's confirm is the last one.
    final signOutLabel = find.text('Sign out');
    // E1 is a long scroll view: the button is built lazily, below the fold.
    if (signOutLabel.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        signOutLabel,
        300,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await tester.tap(signOutLabel);
    await settle(tester, 1);
    expect(find.text('Sign out?'), findsOneWidget, reason: 'confirm sheet');
    await tester.tap(signOutLabel.last);
    await settle(tester, 3);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  }

  testWidgets('foundation: guard, shell, personas', (tester) async {
    app.main();
    await settle(tester, 3);
    await binding.takeScreenshot('A2_sign_in');

    // Wrong password → A3 inline error under the password field.
    await signIn(tester, 'nadia@example.com', 'wrong');
    expect(find.text('Email or password is incorrect.'), findsOneWidget);
    await binding.takeScreenshot('A3_sign_in_error');

    // Approved persona → Home inside the shell.
    await signIn(tester, 'nadia@example.com', 'password1');
    expect(find.byType(FloatingPillNav), findsOneWidget);
    expect(find.text('Greetings, Nadia!'), findsOneWidget);
    await binding.takeScreenshot('B1_home_shell');

    // Inactive tabs are icon-only (prototype), so tap by icon. Each tab is
    // recognised by a string only that screen renders.
    const tabs = [
      (Icons.explore_outlined, 'Events', 'Open', 'C1'),
      (Icons.event_available_outlined, 'Schedule', 'Upcoming', 'D1'),
      (Icons.account_circle_outlined, 'Profile', 'Change password', 'E1'),
    ];
    for (final (icon, label, anchor, screenId) in tabs) {
      await tester.tap(find.byIcon(icon));
      await settle(tester, 2);
      expect(find.text(anchor), findsOneWidget, reason: '$label tab content');
      expect(
        find.descendant(
          of: find.byType(FloatingPillNav),
          matching: find.text(label),
        ),
        findsOneWidget,
        reason: 'active tab shows its label',
      );
      await binding.takeScreenshot('${screenId}_${label.toLowerCase()}_tab');
    }
    // Still on Profile: sign out lives there now, not on Home.
    await signOut(tester);

    // Pending persona → parked on /verification, cannot reach Home.
    await signIn(tester, 'pending@example.com', 'password1');
    expect(find.text('UNDER REVIEW'), findsOneWidget);
    expect(find.byType(FloatingPillNav), findsNothing);
    await binding.takeScreenshot('A6_verification_pending');
    await signOut(tester);

    // Rejected persona → A7.
    await signIn(tester, 'rejected@example.com', 'password1');
    expect(find.text('Your profile needs changes.'), findsOneWidget);
    expect(find.byType(FloatingPillNav), findsNothing);
    await binding.takeScreenshot('A7_verification_rejected');
    await signOut(tester);
  });
}
