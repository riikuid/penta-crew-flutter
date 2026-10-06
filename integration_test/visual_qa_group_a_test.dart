import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/features/auth/auth_routes.dart';
import 'package:penta_crew/main.dart' as app;

/// TASK-020 visual QA, group A (auth + verification) with `USE_MOCK=true`.
/// Walks every A-group screen and state, taking one screenshot per state
/// (`<screen-id>-<state>`), so the PNGs in build/screenshots/ can be compared
/// with `docs/prototype/screens.html`. Sections are soft-failing: a failed
/// step is recorded (and screenshotted as `FAIL-<section>`), the app is
/// steered back to Sign in and the next section runs; the test fails at the
/// end if anything was recorded. Run with `flutter drive` (see
/// test_driver/integration_test.dart).
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final failures = <String>[];

  const approvedEmail = 'nadia@example.com';
  const pendingEmail = 'pending@example.com';
  const rejectedEmail = 'rejected@example.com';
  const password = 'password1';

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

  Future<void> shoot(String name) async {
    await binding.takeScreenshot(name);
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

  Future<void> typeInto(WidgetTester tester, String label, String value) async {
    final target = textField(label);
    await tester.ensureVisible(target);
    // On a real simulator the text-input client is attached over the
    // platform channel; focus the field and let that round-trip finish, or
    // `enterText` straight after an `unfocus()` is silently dropped.
    await tester.tap(target);
    await settle(tester, 350);
    if (target.evaluate().isEmpty) {
      // Seen once on A2 right after a sign-out: the page went blank for a
      // moment after the tap. Give it time to come back and focus again.
      await shoot('QUIRK-blank-after-tap-$label');
      await waitFor(tester, target);
      await settle(tester, 800);
      await tester.tap(target);
      await settle(tester, 350);
    }
    await tester.enterText(target, value);
    await tester.pump();
  }

  Future<void> tapButton(WidgetTester tester, Finder button) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await settle(tester, 400);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
  }

  Future<void> signIn(WidgetTester tester, String email, String pass) async {
    await typeInto(tester, 'Email', email);
    await typeInto(tester, 'Password', pass);
    await tapButton(tester, signInButton());
    await settle(tester, 2500);
  }

  /// Danger "Sign out" (A6/A7) → confirm sheet → back on A2.
  Future<void> signOut(WidgetTester tester, {String? sheetScreenshot}) async {
    final signOutButton = find.widgetWithText(TextButton, 'Sign out');
    await tapButton(tester, signOutButton);
    await waitFor(tester, find.text('Sign out?'));
    await settle(tester, 600);
    if (sheetScreenshot != null) await shoot(sheetScreenshot);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Sign out'));
    await waitFor(tester, signInButton());
    await settle(tester, 1000);
  }

  /// Whatever state the app is in, get back to A2 so the next section can
  /// start from a known screen.
  Future<void> recover(WidgetTester tester) async {
    try {
      Navigator.of(
        tester.element(find.byType(Scaffold).first),
        rootNavigator: true,
      ).popUntil((route) => route.isFirst);
      await settle(tester, 500);
      router(tester).go(AppRoutes.login);
      await settle(tester, 1500);
      if (signInButton().evaluate().isEmpty &&
          find.widgetWithText(TextButton, 'Sign out').evaluate().isNotEmpty) {
        await signOut(tester);
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
    try {
      await body();
    } catch (error, stackTrace) {
      failures.add('$name: $error\n$stackTrace');
      try {
        await shoot('FAIL-$name');
      } catch (_) {
        // Screenshot failure must not hide the original error.
      }
      await recover(tester);
    }
  }

  testWidgets('visual QA group A: auth + verification screens', (tester) async {
    // ── A1 Splash ────────────────────────────────────────────────────────
    app.main();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    await shoot('A1-default');
    await waitFor(tester, signInButton());
    await settle(tester, 1500);

    // ── A2 Sign in ───────────────────────────────────────────────────────
    await section(tester, 'A2', () async {
      await shoot('A2-default');

      await tapButton(tester, signInButton());
      await settle(tester, 500);
      expect(find.text('Enter your email.'), findsOneWidget);
      expect(find.text('Enter your password.'), findsOneWidget);
      await shoot('A2-validation-empty');

      await typeInto(tester, 'Email', 'nadia');
      await tapButton(tester, signInButton());
      await settle(tester, 500);
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      await shoot('A2-validation-bad-email');

      // Keyboard: focus the email field and type into it.
      await tester.tap(textField('Email'));
      await settle(tester, 700);
      await typeInto(tester, 'Email', approvedEmail);
      await settle(tester, 700);
      await shoot('A2-keyboard');

      await typeInto(tester, 'Password', 'wrongpass');
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester, 700);
      await shoot('A2-filled');

      // Password eye toggle.
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await settle(tester, 400);
      await shoot('A2-password-visible');
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await settle(tester, 300);

      await tapButton(tester, signInButton());
      await tester.pump(const Duration(milliseconds: 120));
      await shoot('A2-busy');
      await waitFor(tester, find.text('Email or password is incorrect.'));
      await settle(tester, 600);
      expect(find.text(approvedEmail), findsOneWidget, reason: 'email kept');
      await shoot('A2-error-invalid-credentials');
    });

    // ── A2b Forgot password ─────────────────────────────────────────────
    await section(tester, 'A2b', () async {
      await tapButton(tester, find.text('Forgot password?'));
      await waitFor(tester, find.text('Reset your password.'));
      await settle(tester, 800);
      await shoot('A2b-default');

      await typeInto(tester, 'Email', '');
      await tapButton(tester, find.widgetWithText(FilledButton, 'Send link'));
      await settle(tester, 500);
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      await shoot('A2b-validation');

      await typeInto(tester, 'Email', approvedEmail);
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester, 600);
      await shoot('A2b-filled');

      await tapButton(tester, find.widgetWithText(FilledButton, 'Send link'));
      await tester.pump(const Duration(milliseconds: 120));
      await shoot('A2b-busy');

      // ── A2c Check your email ─────────────────────────────────────────
      await waitFor(tester, find.text('Check your email.'));
      await settle(tester, 800);
      expect(find.textContaining('Resend in'), findsOneWidget);
      await shoot('A2c-default');

      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Back to sign in'),
      );
      await waitFor(tester, signInButton());
      await settle(tester, 800);
    });

    // ── A2d Reset password (deep-link target) ───────────────────────────
    await section(tester, 'A2d', () async {
      router(tester)
          .go('${AuthRoutes.resetPassword}?token=mock-qa&email=$approvedEmail');
      await waitFor(tester, find.text('Choose a new password.'));
      await settle(tester, 800);
      await shoot('A2d-default');

      await typeInto(tester, 'New password', 'short');
      await settle(tester, 300);
      await shoot('A2d-rules-partial');

      await typeInto(tester, 'New password', 'password1');
      await typeInto(tester, 'Confirm new password', 'password1');
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester, 600);
      await shoot('A2d-filled');

      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Update password'),
      );
      await tester.pump(const Duration(milliseconds: 120));
      await shoot('A2d-busy');
      await waitFor(tester, find.text('Password updated'));
      await settle(tester, 400);
      await shoot('A2d-success-toast');
      await waitFor(tester, signInButton());
      await settle(tester, 3500);

      // No token → expired view straight away.
      router(tester).go(AuthRoutes.resetPassword);
      await waitFor(tester, find.text('This link has expired.'));
      await settle(tester, 800);
      await shoot('A2d-expired');

      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Request new link'),
      );
      await waitFor(tester, find.text('Reset your password.'));
      await settle(tester, 500);
      // Back circle: nothing beneath → falls back to Sign in.
      await tester.tap(find.byIcon(Icons.arrow_back));
      await waitFor(tester, signInButton());
      await settle(tester, 800);
    });

    // ── A4 / A5 Create account ──────────────────────────────────────────
    await section(tester, 'A4-A5', () async {
      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Create account'),
      );
      await waitFor(tester, find.text('Tell us who you are.'));
      await settle(tester, 800);
      await shoot('A4-default');

      await tapButton(tester, find.widgetWithText(FilledButton, 'Continue'));
      await settle(tester, 600);
      expect(find.text('Enter your full name.'), findsOneWidget);
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(find.text('Enter your phone number.'), findsOneWidget);
      expect(
        find.text('Use at least 8 characters with a number.'),
        findsOneWidget,
      );
      await shoot('A4-validation');

      await typeInto(tester, 'Full name', 'Rina Maharani');
      await settle(tester, 300);
      await shoot('A4-keyboard');
      // Existing email first, to see the 422 round-trip from step 02.
      await typeInto(tester, 'Email', approvedEmail);
      await typeInto(tester, 'Phone number', '0812 3456 7890');
      await typeInto(tester, 'Password', 'password1');
      await typeInto(tester, 'Confirm password', 'password2');
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester, 600);
      await tapButton(tester, find.widgetWithText(FilledButton, 'Continue'));
      await settle(tester, 600);
      expect(find.text("Passwords don't match."), findsOneWidget);
      await shoot('A4-validation-mismatch');

      await typeInto(tester, 'Confirm password', 'password1');
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester, 600);
      await shoot('A4-filled');

      await tapButton(tester, find.widgetWithText(FilledButton, 'Continue'));
      await waitFor(tester, find.text('Your crew profile.'));
      await settle(tester, 800);
      await shoot('A5-default');

      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Submit for review'),
      );
      await settle(tester, 600);
      expect(find.text('Enter your date of birth.'), findsOneWidget);
      expect(find.text('Select your gender.'), findsOneWidget);
      expect(find.text('Select your branch.'), findsOneWidget);
      expect(find.text('Enter your home address.'), findsOneWidget);
      await shoot('A5-validation');

      // Date of birth picker.
      await tester.tap(find.text('DD / MM / YYYY'));
      await settle(tester, 1000);
      await shoot('A5-date-picker');
      await tester.tap(find.text('OK'));
      await settle(tester, 800);

      // Gender sheet.
      await tester.tap(find.text('Select').first);
      await settle(tester, 800);
      await shoot('A5-gender-sheet');
      await tester.tap(find.text('Female'));
      await settle(tester, 800);

      // Branch sheet: skeleton rows first, then the list.
      await tester.tap(find.text('Select').first);
      await tester.pump(const Duration(milliseconds: 150));
      await shoot('A5-branch-sheet-loading');
      await waitFor(tester, find.text('Jakarta'));
      await settle(tester, 600);
      await shoot('A5-branch-sheet');
      await tester.tap(find.text('Jakarta'));
      await settle(tester, 800);

      await typeInto(tester, 'Home address', 'Jl. Kemang Raya 12, Jakarta');
      await settle(tester, 300);
      await shoot('A5-keyboard');
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester, 600);
      await shoot('A5-filled');

      // Existing email → 422 on the email field → back on step 01.
      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Submit for review'),
      );
      await tester.pump(const Duration(milliseconds: 120));
      await shoot('A5-busy');
      await waitFor(tester, find.text('The email has already been taken.'));
      await settle(tester, 800);
      expect(find.text('Tell us who you are.'), findsOneWidget);
      await shoot('A4-error-email-taken');

      await typeInto(tester, 'Email', 'rina.maharani@example.com');
      await tapButton(tester, find.widgetWithText(FilledButton, 'Continue'));
      await waitFor(tester, find.text('Your crew profile.'));
      await settle(tester, 600);
      // Step 02 values must still be there.
      expect(find.text('Female'), findsOneWidget, reason: 'gender kept');
      expect(find.text('Jakarta'), findsOneWidget, reason: 'branch kept');
      await shoot('A5-filled-after-back');

      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Submit for review'),
      );
      // register → pending → guard parks the new user on A6.
      await waitFor(tester, find.text('UNDER REVIEW'));
      await settle(tester, 1200);
      await shoot('A6-after-register');
      await signOut(tester);
    });

    // ── A6 Verification · pending ───────────────────────────────────────
    await section(tester, 'A6', () async {
      await signIn(tester, pendingEmail, password);
      await waitFor(tester, find.text('UNDER REVIEW'));
      await settle(tester, 1000);
      await shoot('A6-pending');

      // Pull to refresh.
      await tester.drag(
        find.text("We're reviewing your profile."),
        const Offset(0, 260),
      );
      await tester.pump(const Duration(milliseconds: 150));
      await shoot('A6-refreshing');
      // `checkSession()` emits `unknown` first, so the router may park the
      // page on the splash while `GET /me` is in flight — catch that frame.
      await settle(tester, 450);
      await shoot('A6-refreshing-late');
      await settle(tester, 2500);
      expect(find.text('UNDER REVIEW'), findsOneWidget);

      // View my data.
      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'View my data'),
      );
      await waitFor(tester, find.text('My data'));
      await settle(tester, 1000);
      await shoot('A6a-view-my-data');
      await tester.tap(find.byIcon(Icons.arrow_back));
      await waitFor(tester, find.text('UNDER REVIEW'));
      await settle(tester, 600);

      await signOut(tester, sheetScreenshot: 'A6-sign-out-sheet');
      await shoot('A2-after-sign-out');
    });

    // ── A7 Verification · not approved ──────────────────────────────────
    await section(tester, 'A7', () async {
      await signIn(tester, rejectedEmail, password);
      await waitFor(tester, find.text('Your profile needs changes.'));
      await settle(tester, 1000);
      await shoot('A7-rejected');

      await tapButton(
        tester,
        find.widgetWithText(FilledButton, 'Edit profile'),
      );
      await waitFor(tester, find.text('Submit again'));
      await settle(tester, 1000);
      await shoot('A7-edit-profile');
      await tester.tap(find.byIcon(Icons.arrow_back));
      await waitFor(tester, find.text('Your profile needs changes.'));
      await settle(tester, 600);

      await signOut(tester, sheetScreenshot: 'A7-sign-out-sheet');
    });

    expect(failures, isEmpty, reason: failures.join('\n\n'));
  });
}
