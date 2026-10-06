import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/main.dart' as app;

/// TASK-020 visual QA, group C (Schedule + Profile + Notifications) with
/// `USE_MOCK=true`. Same harness as `visual_qa_group_b_test.dart`: one
/// screenshot per state (`<screen-id>-<state>`), soft-failing sections, and
/// the test fails at the end if anything was recorded. Run with
/// `flutter drive` (see test_driver/integration_test.dart).
///
/// Pass `--dart-define=QA_VARIANT=fixtures` for the empty states (D3, D2
/// empty, N1 empty), which need a temporarily added approved persona with no
/// events, applications or notifications (`empty@example.com`).

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

  /// The first vertical scrollable on screen (skips text fields and pagers).
  Finder verticalScrollable() => find
      .byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      )
      .first;

  testWidgets('visual QA group C: schedule + profile + notifications', (
    tester,
  ) async {
    app.main();
    await tester.pump();
    await waitFor(tester, signInButton());
    await settle(tester, 1500);

    if (fixturesVariant) {
      // ── D3 / D2 empty / N1 empty (fixture: empty persona) ──────────────
      await section(tester, 'D3-N1-empty', () async {
        await signIn(tester, emptyEmail);
        await settle(tester, 1500);
        router(tester).go(AppRoutes.home);
        await waitFor(tester, find.text("You're verified and ready."));
        await settle(tester, 800);

        await tapTab(tester, Icons.event_available_outlined);
        await waitFor(tester, find.text('No confirmed events.'));
        await settle(tester, 1000);
        await shoot('D3-empty');

        await tester.tap(find.text('History'));
        await waitFor(tester, find.text('No history yet.'));
        await settle(tester, 800);
        await shoot('D2-history-empty');
        await tester.tap(find.text('Upcoming'));
        await settle(tester, 600);

        await tapButton(
          tester,
          find.widgetWithText(FilledButton, 'Browse events'),
        );
        await waitFor(tester, find.text('No open events right now.'));
        await settle(tester, 800);
        await shoot('D3-after-browse-events');

        await tapTab(tester, Icons.home_outlined);
        await waitFor(tester, find.byIcon(Icons.notifications_outlined));
        await tester.tap(find.byIcon(Icons.notifications_outlined));
        await waitFor(tester, find.text('No notifications yet.'));
        await settle(tester, 1000);
        await shoot('N1-empty');
      });

      expect(failures, isEmpty, reason: failures.join('\n\n'));
      return;
    }

    // ── D1 Schedule · upcoming ───────────────────────────────────────────
    await section(tester, 'D1', () async {
      await signIn(tester, approvedEmail);
      await waitFor(tester, find.text('Open for you'));
      await settle(tester, 1000);
      await tapTab(tester, Icons.event_available_outlined);
      await tester.pump(const Duration(milliseconds: 100));
      await shoot('D1-loading');
      await waitFor(tester, find.text('Wedding of Laras & Bima'));
      await settle(tester, 1200);
      await shoot('D1-default');
      await scrollBy(tester, 600);
      await shoot('D1-scrolled');
      await scrollBy(tester, -600);
    });

    // ── D2 Schedule · history ────────────────────────────────────────────
    await section(tester, 'D2', () async {
      await tester.tap(find.text('History'));
      await waitFor(tester, find.text('Rumah Dansa studio opening'));
      await settle(tester, 1200);
      await shoot('D2-history');
      await scrollBy(tester, 700);
      await shoot('D2-history-scrolled');
      await scrollBy(tester, -700);
      await tester.tap(find.text('Upcoming'));
      await settle(tester, 800);
    });

    // ── D1 card → event detail (selected) ───────────────────────────────
    await section(tester, 'D1-open-card', () async {
      await openCard(tester, 'Wedding of Laras & Bima');
      await waitFor(tester, find.text("You're on the crew."));
      await settle(tester, 1000);
      await shoot('D1-card-to-C8');
      await goBack(tester, find.text('CONFIRMED SHIFTS'));
    });

    // ── N1 Notifications: bell → list → tap → event detail → mark read ──
    await section(tester, 'N1', () async {
      await tapTab(tester, Icons.home_outlined);
      await waitFor(tester, find.text('Open for you'));
      await settle(tester, 800);
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pump(const Duration(milliseconds: 100));
      await shoot('N1-loading');
      await waitFor(tester, find.text('Mark all read'));
      await settle(tester, 1200);
      await shoot('N1-unread');
      await scrollBy(tester, 600);
      await shoot('N1-unread-scrolled');
      await scrollBy(tester, -600);

      await tester.tap(find.text("You're selected").first);
      await waitFor(tester, find.text("You're on the crew."));
      await settle(tester, 1000);
      await shoot('N1-tap-to-event-detail');
      await goBack(tester, find.text('Notifications'));

      await tester.tap(find.text('Mark all read'));
      await tester.pump(const Duration(milliseconds: 120));
      await shoot('N1-mark-all-busy');
      await waitFor(tester, find.text('All caught up'.toUpperCase()));
      await settle(tester, 1000);
      await shoot('N1-all-read');
      await goBack(tester, find.text('Open for you'));
      await settle(tester, 800);
      await shoot('B1-bell-after-read');
    });

    // ── E1 Profile + sign-out sheet ──────────────────────────────────────
    await section(tester, 'E1', () async {
      await tapTab(tester, Icons.account_circle_outlined);
      await tester.pump(const Duration(milliseconds: 100));
      await shoot('E1-loading');
      await waitFor(tester, find.text('Change password'));
      await settle(tester, 1000);
      await shoot('E1-default');
      final signOutButton = find.widgetWithText(OutlinedButton, 'Sign out');
      await tester.scrollUntilVisible(
        signOutButton,
        300,
        scrollable: verticalScrollable(),
      );
      await settle(tester, 600);
      await shoot('E1-scrolled');
      await tapButton(tester, signOutButton);
      await waitFor(tester, find.text('Sign out?'));
      await settle(tester, 600);
      await shoot('E1-sign-out-sheet');
      await tester.tap(find.text('Stay signed in'));
      await waitGone(tester, find.text('Sign out?'));
      await settle(tester, 600);
      tester.state<ScrollableState>(verticalScrollable()).position.jumpTo(0);
      await settle(tester, 400);
    });

    // ── E2 Edit profile → header updates ────────────────────────────────
    await section(tester, 'E2', () async {
      await tester.tap(find.text('Edit profile'));
      await waitFor(tester, find.text('Save changes'));
      await settle(tester, 1000);
      await shoot('E2-default');
      await scrollBy(tester, 500);
      await shoot('E2-scrolled');
      await scrollBy(tester, -500);

      await typeInto(tester, 'Full name', 'Nadia Putri Lestari');
      await settle(tester, 600);
      await shoot('E2-keyboard');
      await typeInto(tester, 'Full name', '');
      FocusManager.instance.primaryFocus?.unfocus();
      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Save changes'),
      );
      await settle(tester, 800);
      await shoot('E2-validation');

      await typeInto(tester, 'Full name', 'Nadia Putri Lestari');
      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Save changes'),
      );
      await tester.pump(const Duration(milliseconds: 120));
      await shoot('E2-busy');
      await waitFor(tester, find.text('Profile updated'));
      await settle(tester, 400);
      await shoot('E2-saved-toast');
      // Save does not pop: the page reloads and stays on Edit profile
      // (finding E2-01), so record that state and go back by hand.
      await waitFor(tester, find.widgetWithText(FilledButton, 'Save changes'));
      await waitGone(tester, find.text('Profile updated'));
      await settle(tester, 800);
      await shoot('E2-after-save-still-open');
      await goBack(tester, find.text('Change password'));
      await waitFor(tester, find.text('Nadia Putri Lestari'));
      await settle(tester, 600);
      await shoot('E1-after-edit');
    });

    // ── E3 Change password (last: it changes the password) ──────────────
    await section(tester, 'E3', () async {
      await tester.ensureVisible(find.text('Change password'));
      await settle(tester, 400);
      await tester.tap(find.text('Change password'));
      await waitFor(tester, find.text('Update password'));
      await settle(tester, 1000);
      await shoot('E3-default');

      await typeInto(tester, 'Current password', 'wrongpass1');
      await typeInto(tester, 'New password', 'abcdefgh');
      await settle(tester, 500);
      await shoot('E3-rules-partial');
      await typeInto(tester, 'New password', 'password2');
      await typeInto(tester, 'Confirm new password', 'password2');
      await settle(tester, 500);
      await shoot('E3-keyboard');
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester, 500);
      await shoot('E3-filled');

      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Update password'),
      );
      await waitFor(tester, find.text('The current password is incorrect.'));
      await settle(tester, 800);
      await shoot('E3-error-wrong-current');

      await typeInto(tester, 'Current password', password);
      FocusManager.instance.primaryFocus?.unfocus();
      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Update password'),
      );
      await tester.pump(const Duration(milliseconds: 120));
      await shoot('E3-busy');
      await waitFor(tester, find.text('Password updated'));
      await settle(tester, 400);
      await shoot('E3-success-toast');
    });

    expect(failures, isEmpty, reason: failures.join('\n\n'));
  });
}
