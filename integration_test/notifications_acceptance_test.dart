import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:penta_crew/features/notifications/presentation/widgets/unread_dot.dart';
import 'package:penta_crew/main.dart' as app;

/// TASK-019 acceptance on a device/simulator with `USE_MOCK=true`: nadia →
/// Home shows the unread dot on the bell → the notifications list (N1) shows
/// the mock unread count → tapping an `application.selected` row opens the
/// event detail and decrements the count → `Mark all read` clears the list →
/// back on Home the dot is gone. Run with `flutter drive` (see
/// test_driver/integration_test.dart) to get the screenshots written to
/// build/screenshots/.
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

  /// Pumps until [finder] matches, or fails after [timeout] listing every
  /// visible text so the screen the app is actually on shows in the log.
  Future<void> waitFor(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) return;
    }
    final visibleTexts = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data ?? text.textSpan?.toPlainText())
        .whereType<String>()
        .toList();
    fail('Timed out waiting for $finder. Visible texts: $visibleTexts');
  }

  Future<void> signIn(
    WidgetTester tester,
    String email,
    String password,
  ) async {
    await tester.enterText(find.byType(TextFormField).at(0), email);
    await tester.enterText(find.byType(TextFormField).at(1), password);
    // Let the keyboard inset settle before tapping, otherwise the button can
    // be mid-layout and miss the hit test.
    FocusManager.instance.primaryFocus?.unfocus();
    await settle(tester, 1);
    final signInButton = find.widgetWithText(FilledButton, 'Sign in');
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await settle(tester, 3);
  }

  final unreadDot = find.byWidgetPredicate(
    (widget) =>
        widget is Semantics &&
        widget.properties.label == UnreadDot.semanticsLabel,
  );

  /// The N1 eyebrow: `{n} unread` or `All caught up` (rendered upper-case).
  int unreadCountShown(WidgetTester tester) {
    final subtitle = find.textContaining(
      RegExp(r'^\d+ unread$', caseSensitive: false),
    );
    expect(subtitle, findsOneWidget, reason: 'N1 unread subtitle');
    final text = tester.widget<Text>(subtitle).data!;
    return int.parse(text.split(' ').first);
  }

  testWidgets('notifications: badge, list, tap routing, mark all read', (
    tester,
  ) async {
    app.main();
    await settle(tester, 3);
    await signIn(tester, 'nadia@example.com', 'password1');

    // B1: the bell carries the unread dot once the count is fetched.
    expect(find.text('Greetings, Nadia!'), findsOneWidget);
    await settle(tester, 2);
    expect(unreadDot, findsOneWidget, reason: 'bell shows the unread dot');
    await binding.takeScreenshot('B1_home_bell_unread');

    // N1 loaded with unread rows.
    await tester.tap(find.byIcon(Icons.notifications_outlined));
    await settle(tester, 3);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Mark all read'), findsOneWidget);
    final unreadBefore = unreadCountShown(tester);
    expect(unreadBefore, greaterThan(0));
    await binding.takeScreenshot('N1_list_unread');

    // Tap the newest `application.selected` row (mock 9001, event 46) →
    // event detail in its "selected" variant (C2), marked read on the way.
    await tester.tap(find.text("You're selected").first);
    await waitFor(tester, find.text("You're on the crew."));
    expect(find.textContaining('Mahesa Group town hall'), findsWidgets);
    await settle(tester, 1);
    expect(find.text('Notifications'), findsNothing);
    await binding.takeScreenshot('C2_event_detail_from_notification');

    // Back to the list: the count went down by one.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await waitFor(tester, find.text('Notifications'));
    await settle(tester, 1);
    expect(unreadCountShown(tester), unreadBefore - 1);

    // Mark all read → `All caught up`, link gone.
    await tester.tap(find.text('Mark all read'));
    await waitFor(tester, find.text('ALL CAUGHT UP'));
    await settle(tester, 1);
    expect(find.text('Mark all read'), findsNothing);
    await binding.takeScreenshot('N1_list_read');

    // Back on Home: no dot.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await waitFor(tester, find.text('Greetings, Nadia!'));
    await settle(tester, 2);
    expect(unreadDot, findsNothing, reason: 'dot cleared after mark all read');
    await binding.takeScreenshot('B1_home_bell_cleared');
  });
}
