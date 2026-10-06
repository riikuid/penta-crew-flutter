import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/features/events/events_routes.dart';
import 'package:penta_crew/main.dart' as app;

/// TASK-020 visual QA, group B (Home + Events) with `USE_MOCK=true`.
/// Same harness as `visual_qa_group_a_test.dart`: one screenshot per state
/// (`<screen-id>-<state>`), soft-failing sections (a failed step is recorded,
/// screenshotted as `FAIL-<section>`, the app is steered back to Home and the
/// next section runs), and the test fails at the end if anything was
/// recorded. Run with `flutter drive` (see test_driver/integration_test.dart).
///
/// Pass `--dart-define=QA_VARIANT=fixtures` to run the two sections that
/// need temporarily edited mock fixtures (C7 closed-waiting, B3 / C10 empty
/// via an approved persona with no events); the default fixtures cannot
/// produce those states.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final failures = <String>[];

  const approvedEmail = 'nadia@example.com';
  const emptyEmail = 'empty@example.com';
  const password = 'password1';
  const variant = String.fromEnvironment('QA_VARIANT');
  const fixturesVariant = variant == 'fixtures';

  /// `--dart-define=QA_ONLY=C1,C9` runs just those sections (plus B1-B2).
  const onlyDefine = String.fromEnvironment('QA_ONLY');
  final onlySections = onlyDefine.isEmpty
      ? <String>{}
      : onlyDefine.split(',').toSet();

  /// Pumps frames for [milliseconds]; the mock answers in 300–800 ms and the
  /// skeleton pulse never settles, so a fixed window replaces pumpAndSettle.
  Future<void> settle(WidgetTester tester, [int milliseconds = 2000]) async {
    final end = DateTime.now().add(Duration(milliseconds: milliseconds));
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  /// Pumps until [finder] matches, or fails listing every visible text.
  Future<void> waitFor(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 50));
      if (finder.evaluate().isNotEmpty) return;
    }
    final visibleTexts = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data ?? text.textSpan?.toPlainText())
        .whereType<String>()
        .toList();
    fail('Timed out waiting for $finder. Visible texts: $visibleTexts');
  }

  /// Pumps until [finder] no longer matches.
  Future<void> waitGone(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 50));
      if (finder.evaluate().isEmpty) return;
    }
    fail('Timed out waiting for $finder to go away.');
  }

  /// Logs the name so the drive log shows progress, and fails instead of
  /// hanging the whole run if the platform never answers.
  Future<void> shoot(String name) async {
    debugPrint('[QA] shoot $name');
    await binding.takeScreenshot(name).timeout(const Duration(seconds: 30));
  }

  GoRouter router(WidgetTester tester) =>
      GoRouter.of(tester.element(find.byType(Scaffold).first));

  Finder signInButton() => find.widgetWithText(FilledButton, 'Sign in');

  Finder field(String label) => find.ancestor(
    of: find.text(label.toUpperCase()),
    matching: find.byType(Column),
  );

  /// The TextFormField under the eyebrow [label] (labels render uppercase).
  Finder textField(String label) => find
      .descendant(of: field(label).first, matching: find.byType(TextFormField))
      .first;

  /// Focuses [target] and lets the text-input client attach before typing
  /// (`enterText` straight after an `unfocus()` is dropped on the simulator).
  Future<void> typeIntoFinder(
    WidgetTester tester,
    Finder target,
    String value,
  ) async {
    await tester.ensureVisible(target);
    await tester.tap(target);
    await settle(tester, 350);
    await tester.enterText(target, value);
    await tester.pump();
  }

  Future<void> typeInto(WidgetTester tester, String label, String value) =>
      typeIntoFinder(tester, textField(label), value);

  Future<void> tapButton(WidgetTester tester, Finder button) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await settle(tester, 400);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
  }

  /// Taps a tab of the floating pill nav by its icon (inactive tabs render
  /// no label).
  Future<void> tapTab(WidgetTester tester, IconData icon) async {
    await tester.tap(find.byIcon(icon).last);
    await tester.pump();
  }

  /// Signs in and returns as soon as the Home scaffold is on screen, so the
  /// caller can catch the B2 skeleton before the sections load.
  Future<void> signIn(WidgetTester tester, String email) async {
    await typeInto(tester, 'Email', email);
    await typeInto(tester, 'Password', password);
    await tapButton(tester, signInButton());
    await waitFor(tester, find.byIcon(Icons.home_outlined));
  }

  /// Profile tab → danger "Sign out" → confirm sheet → back on A2.
  Future<void> signOut(WidgetTester tester) async {
    await tapTab(tester, Icons.account_circle_outlined);
    await waitFor(tester, find.text('Change password'));
    // "Sign out" (danger = OutlinedButton) sits below the fold of a lazy list.
    final signOutButton = find.widgetWithText(OutlinedButton, 'Sign out');
    await tester.scrollUntilVisible(
      signOutButton,
      300,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    await settle(tester, 600);
    await tapButton(tester, signOutButton);
    await waitFor(tester, find.text('Sign out?'));
    await settle(tester, 600);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Sign out').last);
    await waitFor(tester, signInButton());
    await settle(tester, 1000);
  }

  Finder backCircle() => find.byIcon(Icons.arrow_back);

  Future<void> goBack(WidgetTester tester, Finder expected) async {
    // A toast at the top can cover the back button until it slides away.
    final end = DateTime.now().add(const Duration(seconds: 6));
    while (tester
            .hitTestOnBinding(tester.getCenter(backCircle()))
            .path
            .every(
              (entry) => entry.target != tester.renderObject(backCircle()),
            ) &&
        DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.tap(backCircle());
    await waitFor(tester, expected);
    await settle(tester, 800);
  }

  /// Opens the Events tab on [tab] (`Open` / `Tracked`) and waits for
  /// [card] in its list.
  Future<void> openEventsTab(
    WidgetTester tester,
    String tab,
    Finder card,
  ) async {
    if (find.text('Events').evaluate().isEmpty) {
      await tapTab(tester, Icons.explore_outlined);
      await waitFor(tester, find.text('Events'));
    }
    await tester.tap(find.text(tab));
    await settle(tester, 1500);
    if (tab == 'Open' && find.byIcon(Icons.close).evaluate().isNotEmpty) {
      await tester.tap(find.byIcon(Icons.close));
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester, 1500);
    }
    // The tab keeps its scroll offset between sections and the list is lazy,
    // so a card above or below the viewport is not built yet.
    final list = find
        .byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        )
        .first;
    tester.state<ScrollableState>(list).position.jumpTo(0);
    await settle(tester, 300);
    // scrollUntilVisible aligns the card to the top, hiding the header, so
    // only use it when the card is really off screen.
    if (card.evaluate().isEmpty) {
      await tester.scrollUntilVisible(card, 300, scrollable: list);
    }
    await settle(tester, 800);
  }

  Future<void> openCard(WidgetTester tester, String title) async {
    await tester.ensureVisible(find.text(title).first);
    await settle(tester, 300);
    await tester.tap(find.text(title).first);
    await tester.pump();
  }

  /// Scrolls the first scrollable on screen by [offset] and settles.
  Future<void> scrollBy(WidgetTester tester, double offset) async {
    await tester.drag(find.byType(Scrollable).first, Offset(0, -offset));
    await settle(tester, 600);
  }

  /// Withdraw from the C5 page: sheet → [sheetScreenshot] → confirm → C3.
  Future<void> withdraw(
    WidgetTester tester, {
    String? sheetScreenshot,
    String? busyScreenshot,
    String? toastScreenshot,
  }) async {
    await tapButton(
      tester,
      find.widgetWithText(OutlinedButton, 'Withdraw application'),
    );
    await waitFor(tester, find.text('Withdraw application?'));
    await settle(tester, 600);
    if (sheetScreenshot != null) await shoot(sheetScreenshot);
    await tester.tap(find.widgetWithText(FilledButton, 'Withdraw'));
    await tester.pump(const Duration(milliseconds: 120));
    if (busyScreenshot != null) await shoot(busyScreenshot);
    await waitFor(tester, find.text('Application withdrawn'));
    await settle(tester, 400);
    if (toastScreenshot != null) await shoot(toastScreenshot);
    await waitFor(tester, find.widgetWithText(FilledButton, 'Apply'));
    await waitGone(tester, find.text('Application withdrawn'));
    await settle(tester, 600);
  }

  /// Whatever state the app is in, get back to Home so the next section can
  /// start from a known screen.
  Future<void> recover(WidgetTester tester) async {
    try {
      Navigator.of(
        tester.element(find.byType(Scaffold).first),
        rootNavigator: true,
      ).popUntil((route) => route.isFirst);
      await settle(tester, 500);
      router(tester).go(AppRoutes.home);
      await settle(tester, 1500);
      if (signInButton().evaluate().isNotEmpty) {
        await signIn(tester, approvedEmail);
        await settle(tester, 2500);
      }
    } catch (error) {
      failures.add('recover: $error');
    }
  }

  Future<void> section(
    WidgetTester tester,
    String name,
    Future<void> Function() body,
  ) async {
    // B1-B2 signs in, so it always runs.
    if (onlySections.isNotEmpty &&
        name != 'B1-B2' &&
        !onlySections.contains(name)) {
      return;
    }
    debugPrint('[QA] section $name');
    try {
      await body();
    } catch (error, stackTrace) {
      debugPrint('[QA] FAILED $name: $error');
      failures.add('$name: $error\n$stackTrace');
      try {
        await shoot('FAIL-$name');
      } catch (_) {
        // Screenshot failure must not hide the original error.
      }
      await recover(tester);
    }
  }

  testWidgets('visual QA group B: home + events screens', (tester) async {
    app.main();
    await tester.pump();
    await waitFor(tester, signInButton());
    await settle(tester, 1500);

    if (fixturesVariant) {
      // ── C7 Event detail · closed, waiting (fixture: 304 → waiting) ─────
      await section(tester, 'C7', () async {
        await signIn(tester, approvedEmail);
        await waitFor(tester, find.text('Open for you'));
        await settle(tester, 1000);
        await openEventsTab(
          tester,
          'Tracked',
          find.text('Mahesa Group town hall'),
        );
        await shoot('C2-tracked-with-closed-waiting');
        await openCard(tester, 'Mahesa Group town hall');
        await waitFor(
          tester,
          find.text("Applications closed. This can't be changed now."),
        );
        await settle(tester, 1000);
        await shoot('C7-closed-waiting');
        await goBack(tester, find.text('Events'));
        await signOut(tester);
      });

      // ── B3 Home · empty + C10 both tabs (fixture: empty persona) ───────
      await section(tester, 'B3-C10', () async {
        await signIn(tester, emptyEmail);
        // Sign-in after a sign-out from Profile lands on Profile (the old
        // `from`); go Home explicitly — reported as a finding.
        await settle(tester, 1500);
        router(tester).go(AppRoutes.home);
        await waitFor(tester, find.text("You're verified and ready."));
        await settle(tester, 1500);
        await shoot('B3-empty');

        await tapTab(tester, Icons.explore_outlined);
        await waitFor(tester, find.text('No open events right now.'));
        await settle(tester, 1000);
        await shoot('C10-open-empty');

        await tester.tap(find.text('Tracked'));
        await waitFor(tester, find.text("You haven't applied to any events."));
        await settle(tester, 800);
        await shoot('C10-tracked-empty');

        await tester.tap(find.text('Browse open events'));
        await waitFor(tester, find.text('No open events right now.'));
        await settle(tester, 600);
        await shoot('C10-tracked-empty-after-browse');
      });

      expect(failures, isEmpty, reason: failures.join('\n\n'));
      return;
    }

    // ── B2 Home · loading → B1 Home ──────────────────────────────────────
    await section(tester, 'B1-B2', () async {
      await signIn(tester, approvedEmail);
      await tester.pump(const Duration(milliseconds: 80));
      await shoot('B2-loading');
      await waitFor(tester, find.text('Open for you'));
      await settle(tester, 1200);
      expect(find.text('Greetings, Nadia!'), findsOneWidget);
      expect(find.text('WAITING'), findsOneWidget);
      expect(find.text('WORKED'), findsOneWidget);
      await shoot('B1-default');

      await scrollBy(tester, 600);
      await shoot('B1-scrolled');
      await scrollBy(tester, -600);

      // Pull to refresh (data stays, no skeleton expected).
      await tester.drag(find.text('Greetings, Nadia!'), const Offset(0, 260));
      await tester.pump(const Duration(milliseconds: 150));
      await shoot('B2-refreshing');
      await settle(tester, 2500);
      expect(find.text('Greetings, Nadia!'), findsOneWidget);
    });

    // ── B1 Inspect → C8 selected (next shift) ───────────────────────────
    await section(tester, 'B1-inspect-C8', () async {
      await tapButton(tester, find.widgetWithText(FilledButton, 'Inspect'));
      await tester.pump(const Duration(milliseconds: 100));
      await shoot('C3-loading');
      await waitFor(tester, find.text("You're on the crew."));
      await settle(tester, 1000);
      expect(find.text('NOTES FROM ADMIN'), findsOneWidget);
      await shoot('C8-selected');
      await goBack(tester, find.text('Open for you'));
    });

    // ── B1 carousel card → C3 (already applied) ─────────────────────────
    await section(tester, 'B1-carousel', () async {
      await scrollBy(tester, 600);
      await openCard(tester, 'Arunika annual gathering');
      await waitFor(tester, find.text('Applied as Crew'));
      await settle(tester, 1000);
      await shoot('C5-applied-from-home');
      await goBack(tester, find.text('Open for you'));
      await scrollBy(tester, -600);
    });

    // ── C1 Events · open (loading, default, scrolled, search) ───────────
    await section(tester, 'C1', () async {
      await tapTab(tester, Icons.explore_outlined);
      await tester.pump(const Duration(milliseconds: 100));
      await shoot('C1-loading');
      await waitFor(tester, find.text('Arunika annual gathering'));
      await settle(tester, 1200);
      expect(find.text('3 OPEN · JAKARTA'), findsOneWidget);
      await shoot('C1-open-default');
      await scrollBy(tester, 700);
      await shoot('C1-open-scrolled');
      await scrollBy(tester, -700);

      final searchField = find.byType(TextField);
      await typeIntoFinder(tester, searchField, 'wedding');
      await settle(tester, 700);
      await shoot('C1-search-keyboard');
      await waitGone(tester, find.text('Arunika annual gathering'));
      // With the keyboard up the list gets zero height (finding C1-01), so
      // results only show once it is dismissed.
      FocusManager.instance.primaryFocus?.unfocus();
      await waitFor(tester, find.text('Wedding of Nadia & Reza'));
      await settle(tester, 1200);
      await shoot('C1-search-results');

      await typeIntoFinder(tester, searchField, 'zzz');
      FocusManager.instance.primaryFocus?.unfocus();
      await waitFor(tester, find.text('No open events right now.'));
      await settle(tester, 1000);
      await shoot('C10-search-no-results');

      await tester.tap(find.byIcon(Icons.close));
      await waitFor(tester, find.text('Arunika annual gathering'));
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester, 1000);
      await shoot('C1-search-cleared');
    });

    // ── C2 Events · tracked ─────────────────────────────────────────────
    await section(tester, 'C2', () async {
      await openEventsTab(
        tester,
        'Tracked',
        find.text('Rumah Dansa studio opening'),
      );
      expect(find.text('12 APPLICATIONS'), findsOneWidget);
      expect(
        find.text('Monitor your applications and selection results.'),
        findsOneWidget,
      );
      await shoot('C2-tracked');
      await scrollBy(tester, 500);
      await shoot('C2-tracked-scrolled');
      await scrollBy(tester, -500);
    });

    // ── C9 not selected → Browse open events ────────────────────────────
    await section(tester, 'C9', () async {
      await openEventsTab(
        tester,
        'Tracked',
        find.text('Rumah Dansa studio opening'),
      );
      await openCard(tester, 'Rumah Dansa studio opening');
      await waitFor(tester, find.text('NOT SELECTED'));
      await settle(tester, 1000);
      await shoot('C9-not-selected');
      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Browse open events'),
      );
      await waitFor(tester, find.text('Arunika annual gathering'));
      await settle(tester, 1000);
      await shoot('C9-after-browse-open-events');
    });

    // ── C8 selected (closed event, Mahesa) ──────────────────────────────
    await section(tester, 'C8-mahesa', () async {
      await openEventsTab(
        tester,
        'Tracked',
        find.text('Mahesa Group town hall'),
      );
      await openCard(tester, 'Mahesa Group town hall');
      await waitFor(tester, find.text("You're on the crew."));
      await settle(tester, 1000);
      await shoot('C8-selected-mahesa');
      await goBack(tester, find.text('Events'));
    });

    // ── C5 → C6 → C3 → C4 → C5: Arunika (three positions, one locked) ───
    await section(tester, 'C5-C6-C3-C4', () async {
      await openEventsTab(
        tester,
        'Tracked',
        find.text('Arunika annual gathering'),
      );
      await openCard(tester, 'Arunika annual gathering');
      await waitFor(tester, find.text('Applied as Crew'));
      await settle(tester, 1000);
      expect(find.text('WAITING FOR SELECTION'), findsOneWidget);
      await shoot('C5-applied');

      // Keep application first.
      await tapButton(
        tester,
        find.widgetWithText(OutlinedButton, 'Withdraw application'),
      );
      await waitFor(tester, find.text('Withdraw application?'));
      await settle(tester, 600);
      await shoot('C6-withdraw-sheet');
      await tester.tap(find.widgetWithText(TextButton, 'Keep application'));
      await waitGone(tester, find.text('Withdraw application?'));
      await settle(tester, 600);
      expect(find.text('Applied as Crew'), findsOneWidget);

      await withdraw(
        tester,
        busyScreenshot: 'C5-withdraw-busy',
        toastScreenshot: 'C6-withdrawn-toast',
      );
      expect(find.text('Positions'), findsOneWidget);
      expect(find.text('Not one of your roles'), findsOneWidget);
      await shoot('C3-open-default');
      await scrollBy(tester, 700);
      await shoot('C3-open-scrolled');
      await scrollBy(tester, -700);

      await tapButton(tester, find.widgetWithText(FilledButton, 'Apply'));
      await waitFor(tester, find.text('Apply as'));
      await settle(tester, 800);
      expect(find.text('Trainee'), findsWidgets);
      await shoot('C4-apply-sheet');
      await tester.tap(find.text('Event Manager').last);
      await settle(tester, 500);
      await shoot('C4-apply-sheet-event-manager');
      // Locked row: tapping must not change the selection.
      await tester.tap(find.text('Trainee').last);
      await settle(tester, 400);
      await tester.tap(find.widgetWithText(FilledButton, 'Send application'));
      await tester.pump(const Duration(milliseconds: 120));
      await shoot('C3-apply-busy');
      await waitFor(tester, find.text('Application sent'));
      await settle(tester, 400);
      await shoot('C5-applied-toast');
      await waitFor(tester, find.text('Applied as Event Manager'));
      await waitGone(tester, find.text('Application sent'));
      await settle(tester, 600);
      await shoot('C5-applied-event-manager');

      // Tracked must show the new application.
      await goBack(tester, find.text('Events'));
      await waitFor(tester, find.textContaining('AS EVENT MANAGER'));
      await settle(tester, 800);
      await shoot('C2-tracked-after-apply');

      // Withdraw again, Tracked must drop it.
      await openCard(tester, 'Arunika annual gathering');
      await waitFor(tester, find.text('Applied as Event Manager'));
      await settle(tester, 800);
      await withdraw(
        tester,
        sheetScreenshot: 'C6-withdraw-sheet-event-manager',
      );
      await goBack(tester, find.text('Events'));
      await waitFor(tester, find.text('11 APPLICATIONS'));
      await settle(tester, 800);
      await shoot('C2-tracked-after-withdraw');
    });

    // ── C3 / C4 single-position variant: Wedding of Nadia & Reza ─────────
    await section(tester, 'C4-single', () async {
      await openEventsTab(
        tester,
        'Tracked',
        find.text('Wedding of Nadia & Reza'),
      );
      await openCard(tester, 'Wedding of Nadia & Reza');
      await waitFor(tester, find.text('Applied as Crew'));
      await settle(tester, 800);
      await withdraw(tester);
      await shoot('C3-open-single-position');
      await tapButton(tester, find.widgetWithText(FilledButton, 'Apply'));
      await waitFor(tester, find.text('Apply as Crew'));
      await settle(tester, 800);
      await shoot('C4-apply-sheet-single');
      await tester.tap(find.widgetWithText(FilledButton, 'Send application'));
      await waitFor(tester, find.text('Applied as Crew'));
      await waitGone(tester, find.text('Application sent'));
      await settle(tester, 600);
      await goBack(tester, find.text('Events'));
    });

    // ── C3 date_conflict: Kirana (same day as the selected Mahesa) ───────
    await section(tester, 'C3-date-conflict', () async {
      await openEventsTab(tester, 'Open', find.text('Kirana 17th birthday'));
      await openCard(tester, 'Kirana 17th birthday');
      await waitFor(tester, find.text("You're already booked on this date."));
      await settle(tester, 1000);
      await shoot('C3-date-conflict');
      await scrollBy(tester, 700);
      await shoot('C3-date-conflict-scrolled');
      await goBack(tester, find.text('Events'));
    });

    // ── C3 error: unknown event id (mock 404) ───────────────────────────
    await section(tester, 'C3-error', () async {
      // push completes only when the page pops; awaiting it hangs the test.
      unawaited(router(tester).push(EventsRoutes.detail(999)));
      await waitFor(tester, find.text('Event not found.'));
      await settle(tester, 800);
      await shoot('C3-error-not-found');
      await tapButton(tester, find.widgetWithText(OutlinedButton, 'Try again'));
      await tester.pump(const Duration(milliseconds: 100));
      await shoot('C3-error-retrying');
      await waitFor(tester, find.text('Event not found.'));
      await settle(tester, 600);
      // Back lands wherever the push came from (Events, or Home after a
      // recover).
      await goBack(tester, find.byIcon(Icons.explore_outlined));
    });

    // ── Home after the flow: counters refetched? ────────────────────────
    await section(tester, 'B1-after-flow', () async {
      await tapTab(tester, Icons.home_outlined);
      await waitFor(tester, find.text('Open for you'));
      await settle(tester, 1200);
      await shoot('B1-after-flow');
      await tester.drag(find.text('Greetings, Nadia!'), const Offset(0, 260));
      await settle(tester, 3000);
      await shoot('B1-after-flow-refreshed');
    });

    expect(failures, isEmpty, reason: failures.join('\n\n'));
  });
}
