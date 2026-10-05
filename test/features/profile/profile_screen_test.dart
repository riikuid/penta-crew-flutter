import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/widgets/status_pill.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_state.dart';
import 'package:penta_crew/features/profile/presentation/screens/profile_screen.dart';
import 'package:penta_crew/features/profile/presentation/widgets/avatar_circle.dart';
import 'package:penta_crew/features/profile/profile_routes.dart';

import 'profile_test_harness.dart';

void main() {
  late AuthHarness auth;

  setUp(() => auth = AuthHarness(approvedUser));
  tearDown(() => auth.dispose());

  Future<GoRouter> pump(WidgetTester tester) => pumpRouted(
    tester,
    home: const ProfileScreen(),
    auth: auth.cubit,
    stubPaths: [ProfileRoutes.edit, ProfileRoutes.password],
  );

  testWidgets('E1 renders identity, badges, roles, rows and actions', (tester) async {
    await pump(tester);

    expect(find.text('CREW ACCOUNT'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byType(AvatarCircle), findsOneWidget);
    expect(find.text('RA'), findsOneWidget);
    expect(find.text('Rina Anggraini'), findsOneWidget);
    expect(find.text('rina.anggraini@email.com'), findsOneWidget);
    expect(find.text('VERIFIED'), findsOneWidget);
    expect(find.text('JAKARTA BRANCH'), findsOneWidget);
    expect(find.text('ROLES · SET BY ADMIN'), findsOneWidget);
    expect(find.text('Crew'), findsOneWidget);
    expect(find.text('Event Manager'), findsOneWidget);
    expect(find.text('PHONE'), findsOneWidget);
    expect(find.text('+62 812 3456 7890'), findsOneWidget);
    expect(find.text('DATE OF BIRTH'), findsOneWidget);
    expect(find.text('14 March 2000 · Female'), findsOneWidget);
    expect(find.text('HOME ADDRESS'), findsOneWidget);
    expect(find.text('Jl. Tebet Raya 21, Tebet, Jakarta Selatan'), findsOneWidget);
    expect(find.text('MEMBER SINCE'), findsOneWidget);
    expect(find.text('20 Jun 2026'), findsOneWidget);
    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Change password'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
    // D-08: no re-review note anywhere on the profile.
    expect(find.textContaining('admin review'), findsNothing);
  });

  testWidgets('header updates when AuthCubit.updateUser emits a new name', (tester) async {
    await pump(tester);

    auth.cubit.updateUser(approvedUser.copyWith(name: 'Rina Putri'));
    await tester.pumpAndSettle();

    expect(find.text('Rina Putri'), findsOneWidget);
    expect(find.text('RP'), findsOneWidget);
  });

  testWidgets('shows the network avatar instead of initials when avatar_url is set',
      (tester) async {
    auth.cubit.updateUser(approvedUser.copyWith(avatarUrl: 'https://example.com/a.png'));
    await pump(tester);

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('RA'), findsNothing);
  });

  testWidgets('Edit profile and Change password push their routes', (tester) async {
    final router = await pump(tester);

    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();
    expect(find.text(ProfileRoutes.edit), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Change password'));
    await tester.pumpAndSettle();
    expect(find.text(ProfileRoutes.password), findsOneWidget);
  });

  testWidgets('Sign out asks for confirmation, then logs out', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget);
    expect(find.byType(StatusPill), findsNWidgets(2));

    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    verify(() => auth.logout(any())).called(1);
    expect(auth.cubit.state, const AuthState.unauthenticated());
  });
}
