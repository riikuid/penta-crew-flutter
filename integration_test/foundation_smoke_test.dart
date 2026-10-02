import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:penta_crew/core/widgets/floating_pill_nav.dart';
import 'package:penta_crew/main.dart' as app;

/// TASK-004 acceptance on a device/simulator with `USE_MOCK=true`:
/// nadia → Home with the pill nav, all four tabs reachable; pending → parked
/// on /verification; wrong password → "Email or password is incorrect".
/// Run with `flutter drive` (see test_driver/integration_test.dart) to get
/// the screenshots written to build/screenshots/.
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

  Future<void> signIn(WidgetTester tester, String email, String password) async {
    await tester.enterText(find.byType(TextFormField).at(0), email);
    await tester.enterText(find.byType(TextFormField).at(1), password);
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await settle(tester, 3);
  }

  Future<void> signOut(WidgetTester tester) async {
    await tester.tap(find.text('Sign out'));
    await settle(tester, 3);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  }

  testWidgets('foundation: guard, shell, personas', (tester) async {
    app.main();
    await settle(tester, 3);
    await binding.takeScreenshot('A2_sign_in');

    // Wrong password → server message from the mock.
    await signIn(tester, 'nadia@example.com', 'wrong');
    expect(find.text('Email or password is incorrect'), findsOneWidget);
    await binding.takeScreenshot('A3_sign_in_error');
    await settle(tester, 4); // let the toast go away

    // Approved persona → Home inside the shell.
    await signIn(tester, 'nadia@example.com', 'password1');
    expect(find.byType(FloatingPillNav), findsOneWidget);
    expect(find.text('Hello, Nadia Putri'), findsOneWidget);
    await binding.takeScreenshot('B1_home_shell');

    // Inactive tabs are icon-only (prototype), so tap by icon.
    const tabs = [
      (Icons.explore_outlined, 'Events', 'C1'),
      (Icons.event_available_outlined, 'Schedule', 'D1'),
      (Icons.account_circle_outlined, 'Profile', 'E1'),
    ];
    for (final (icon, label, screenId) in tabs) {
      await tester.tap(find.byIcon(icon));
      await settle(tester, 1);
      expect(find.text(screenId), findsOneWidget, reason: '$label tab placeholder');
      expect(
        find.descendant(of: find.byType(FloatingPillNav), matching: find.text(label)),
        findsOneWidget,
        reason: 'active tab shows its label',
      );
      await binding.takeScreenshot('${screenId}_${label.toLowerCase()}_tab');
    }
    await tester.tap(find.byIcon(Icons.home_outlined));
    await settle(tester, 1);
    await signOut(tester);

    // Pending persona → parked on /verification, cannot reach Home.
    await signIn(tester, 'pending@example.com', 'password1');
    expect(find.text('Under review'), findsOneWidget);
    expect(find.byType(FloatingPillNav), findsNothing);
    await binding.takeScreenshot('A6_verification_pending');
    await signOut(tester);

    // Rejected persona → A7 placeholder.
    await signIn(tester, 'rejected@example.com', 'password1');
    expect(find.text('Not approved'), findsOneWidget);
    await binding.takeScreenshot('A7_verification_rejected');
    await signOut(tester);
  });
}
