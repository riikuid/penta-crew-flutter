import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/auth/auth_routes.dart';
import 'package:penta_crew/features/auth/usecases/change_password.dart';
import 'package:penta_crew/features/profile/presentation/cubit/change_password_cubit.dart';
import 'package:penta_crew/features/profile/presentation/screens/change_password_screen.dart';
import 'package:penta_crew/features/profile/profile_routes.dart';

import 'profile_test_harness.dart';

class _MockChangePassword extends Mock implements ChangePassword {}

void main() {
  late _MockChangePassword changePassword;
  late AuthHarness auth;

  setUpAll(() => registerFallbackValue(
    const ChangePasswordParams(currentPassword: '', password: ''),
  ));

  setUp(() => changePassword = _MockChangePassword());
  tearDown(() => auth.dispose());

  Future<GoRouter> pump(WidgetTester tester) async {
    auth = AuthHarness(approvedUser);
    final router = await pumpRouted(
      tester,
      home: const Scaffold(body: Text('root')),
      auth: auth.cubit,
      stubPaths: [AuthRoutes.forgotPassword],
      extraRoutes: [
        GoRoute(
          path: ProfileRoutes.password,
          builder: (context, state) => BlocProvider(
            create: (_) => ChangePasswordCubit(changePassword),
            child: const ChangePasswordScreen(),
          ),
        ),
      ],
    );
    router.push(ProfileRoutes.password);
    await tester.pumpAndSettle();
    return router;
  }

  Finder field(String label) => find.descendant(
    of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
    matching: find.byType(TextFormField),
  );

  FilledButton updateButton(WidgetTester tester) =>
      tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Update password'));

  testWidgets('renders copy, fields and the rule checklist; CTA disabled',
      (tester) async {
    await pump(tester);

    expect(find.text('Change password.'), findsOneWidget);
    expect(find.text("You'll stay signed in on this phone."), findsOneWidget);
    expect(find.text('CURRENT PASSWORD'), findsOneWidget);
    expect(find.text('Enter current password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('NEW PASSWORD'), findsOneWidget);
    expect(find.text('At least 8 characters'), findsNWidgets(2)); // hint + rule
    expect(find.text('CONFIRM NEW PASSWORD'), findsOneWidget);
    expect(find.text('Type it again'), findsOneWidget);
    expect(find.text('Contains a number'), findsOneWidget);
    expect(find.text('Both new passwords match'), findsOneWidget);
    expect(find.text('Update password'), findsOneWidget);
    expect(updateButton(tester).onPressed, isNull);
  });

  testWidgets('rules tick live and the CTA enables once all pass', (tester) async {
    await pump(tester);

    await tester.enterText(field('CURRENT PASSWORD'), 'password1');
    await tester.enterText(field('NEW PASSWORD'), 'abc');
    await tester.pump();
    expect(find.byIcon(Icons.check), findsNothing);

    await tester.enterText(field('NEW PASSWORD'), 'abcdefgh');
    await tester.pump();
    expect(find.byIcon(Icons.check), findsOneWidget); // length only
    expect(updateButton(tester).onPressed, isNull);

    await tester.enterText(field('NEW PASSWORD'), 'abcdefg1');
    await tester.enterText(field('CONFIRM NEW PASSWORD'), 'abcdefg1');
    await tester.pump();
    expect(find.byIcon(Icons.check), findsNWidgets(3));
    expect(updateButton(tester).onPressed, isNotNull);
  });

  testWidgets('wrong current password shows the server error inline', (tester) async {
    when(() => changePassword(any())).thenAnswer(
      (_) async => const Result.failed(
        'The given data was invalid.',
        statusCode: 422,
        fieldErrors: {
          'current_password': ['The current password is incorrect.'],
        },
      ),
    );
    await pump(tester);

    await tester.enterText(field('CURRENT PASSWORD'), 'wrong');
    await tester.enterText(field('NEW PASSWORD'), 'abcdefg1');
    await tester.enterText(field('CONFIRM NEW PASSWORD'), 'abcdefg1');
    await tester.pump();
    await tester.tap(find.text('Update password'));
    await tester.pumpAndSettle();

    expect(find.text('The current password is incorrect.'), findsOneWidget);
    expect(find.text('The given data was invalid.'), findsNothing);
    expect(find.text('Change password.'), findsOneWidget); // still here
  });

  testWidgets('success toasts and pops', (tester) async {
    when(() => changePassword(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    await pump(tester);

    await tester.enterText(field('CURRENT PASSWORD'), 'password1');
    await tester.enterText(field('NEW PASSWORD'), 'abcdefg1');
    await tester.enterText(field('CONFIRM NEW PASSWORD'), 'abcdefg1');
    await tester.pump();
    await tester.tap(find.text('Update password'));
    await tester.pumpAndSettle();

    final params = verify(() => changePassword(captureAny())).captured.single
        as ChangePasswordParams;
    expect(params.currentPassword, 'password1');
    expect(params.password, 'abcdefg1');
    expect(find.text('Password updated'), findsOneWidget);
    expect(find.text("You're still signed in on this phone."), findsOneWidget);
    expect(find.text('root'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('Forgot password? opens the auth route', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    expect(find.text(AuthRoutes.forgotPassword), findsOneWidget);
  });
}
