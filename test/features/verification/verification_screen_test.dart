import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/widgets/progress_timeline.dart';
import 'package:penta_crew/core/widgets/status_pill.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_state.dart';
import 'package:penta_crew/features/profile/profile_routes.dart';
import 'package:penta_crew/features/verification/presentation/screens/verification_screen.dart';
import 'package:penta_crew/features/verification/verification_routes.dart';

import '../profile/profile_test_harness.dart';

void main() {
  late AuthHarness auth;

  tearDown(() => auth.dispose());

  Future<void> pump(WidgetTester tester, User user) async {
    auth = AuthHarness(user);
    await pumpRouted(
      tester,
      home: const VerificationScreen(),
      auth: auth.cubit,
      stubPaths: [VerificationRoutes.data, ProfileRoutes.edit],
    );
  }

  group('A6 pending', () {
    testWidgets('renders pill, headline, body and the timeline', (
      tester,
    ) async {
      await pump(tester, pendingUser);

      expect(find.text('UNDER REVIEW'), findsOneWidget);
      expect(find.text("We're reviewing your profile."), findsOneWidget);
      expect(
        find.text(
          'An admin from the Jakarta branch will check your data and assign '
          "your crew roles. We'll notify you when it's done.",
        ),
        findsOneWidget,
      );
      expect(find.byType(ProgressTimeline), findsOneWidget);
      expect(find.text('Profile submitted'), findsOneWidget);
      expect(find.text('25 SEP 2026 · 09:40'), findsOneWidget);
      expect(find.text('Admin review'), findsOneWidget);
      expect(find.text('JAKARTA BRANCH · IN PROGRESS'), findsOneWidget);
      expect(find.text('Roles assigned'), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('View my data'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);
      expect(find.text('Edit profile'), findsNothing);
    });

    testWidgets('View my data opens /verification/data', (tester) async {
      await pump(tester, pendingUser);

      await tester.tap(find.text('View my data'));
      await tester.pumpAndSettle();

      expect(find.text(VerificationRoutes.data), findsOneWidget);
    });

    testWidgets('pull to refresh re-checks the session', (tester) async {
      await pump(tester, pendingUser);
      await auth.storage.saveToken('t0k3n');
      when(() => auth.getMe(any()))
          .thenAnswer((_) async => Result.success(pendingUser));

      // RefreshIndicator triggers after a quarter of the viewport height.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 900));
      await tester.pumpAndSettle();

      verify(() => auth.getMe(any())).called(1);
    });
  });

  group('A7 not approved', () {
    testWidgets('renders pill, headline, admin note and meta', (tester) async {
      await pump(tester, rejectedUser);

      expect(find.byType(StatusPill), findsOneWidget);
      expect(find.text('NOT APPROVED'), findsOneWidget);
      expect(find.text('Your profile needs changes.'), findsOneWidget);
      expect(
        find.text(
          'Update the details below and submit again. Your account stays '
          "inactive until it's approved.",
        ),
        findsOneWidget,
      );
      expect(find.text('NOTE FROM ADMIN'), findsOneWidget);
      expect(
        find.text(
          '"We couldn\'t reach your phone number and your date of birth '
          'doesn\'t match your ID. Please check both."',
        ),
        findsOneWidget,
      );
      expect(find.text('JAKARTA BRANCH · 26 SEP 2026'), findsOneWidget);
      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('View my data'), findsNothing);
    });

    testWidgets('Edit profile opens /profile/edit', (tester) async {
      await pump(tester, rejectedUser);

      await tester.tap(find.text('Edit profile'));
      await tester.pumpAndSettle();

      expect(find.text(ProfileRoutes.edit), findsOneWidget);
    });

    testWidgets('switches to A6 when the user becomes pending', (tester) async {
      await pump(tester, rejectedUser);

      auth.cubit.updateUser(pendingUser);
      await tester.pumpAndSettle();

      expect(find.text("We're reviewing your profile."), findsOneWidget);
      expect(find.text('Your profile needs changes.'), findsNothing);
    });
  });

  group('Sign out', () {
    testWidgets(
      'opens the confirmation sheet; "Stay signed in" keeps the session',
      (tester) async {
        await pump(tester, pendingUser);

        await tester.tap(find.text('Sign out'));
        await tester.pumpAndSettle();

        expect(find.text('Sign out?'), findsOneWidget);
        expect(
          find.text("You'll need your email and password to sign back in."),
          findsOneWidget,
        );
        expect(find.text('Stay signed in'), findsOneWidget);

        await tester.tap(find.text('Stay signed in'));
        await tester.pumpAndSettle();

        expect(find.text('Sign out?'), findsNothing);
        expect(auth.cubit.isAuthenticated, isTrue);
        verifyNever(() => auth.logout(any()));
      },
    );

    testWidgets('confirming signs the user out', (tester) async {
      await pump(tester, pendingUser);

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      // The sheet's primary action is the danger (outlined) "Sign out" button.
      await tester.tap(find.widgetWithText(OutlinedButton, 'Sign out'));
      await tester.pumpAndSettle();

      verify(() => auth.logout(any())).called(1);
      expect(auth.cubit.state, const AuthState.unauthenticated());
    });
  });
}
