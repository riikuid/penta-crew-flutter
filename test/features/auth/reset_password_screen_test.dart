import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/core/widgets/app_button.dart';
import 'package:penta_crew/features/auth/auth_routes.dart';
import 'package:penta_crew/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/reset_password_state.dart';
import 'package:penta_crew/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:penta_crew/features/auth/presentation/widgets/circle_back_button.dart';

import 'auth_test_app.dart';

class _MockResetPasswordCubit extends MockCubit<ResetPasswordState>
    implements ResetPasswordCubit {}

void main() {
  late _MockResetPasswordCubit cubit;
  late StreamController<ResetPasswordState> states;

  setUp(() {
    cubit = _MockResetPasswordCubit();
    states = StreamController<ResetPasswordState>.broadcast();
    when(() => cubit.submit(any())).thenAnswer((_) async {});
  });

  tearDown(() => states.close());

  Future<GoRouter> pump(
    WidgetTester tester, {
    ResetPasswordState initial = const ResetPasswordState.idle(),
  }) {
    whenListen(cubit, states.stream, initialState: initial);
    return pumpAuthScreen(
      tester,
      BlocProvider<ResetPasswordCubit>.value(
        value: cubit,
        child: const ResetPasswordScreen(token: 'mock-token', email: 'a@b.c'),
      ),
    );
  }

  Future<void> emit(WidgetTester tester, ResetPasswordState state) async {
    states.add(state);
    await tester.pump();
    await tester.pump();
  }

  AppButton updateButton(WidgetTester tester) => tester.widget<AppButton>(
    find.widgetWithText(AppButton, 'Update password'),
  );

  testWidgets('A2d: copy, two fields, rules card, CTA disabled', (
    tester,
  ) async {
    await pump(tester);

    expect(find.byType(CircleBackButton), findsOneWidget);
    expect(find.text('CREW ACCOUNT'), findsOneWidget);
    expect(find.text('Choose a new password.'), findsOneWidget);
    expect(find.text('Use it to sign in on every device.'), findsOneWidget);
    expect(find.text('NEW PASSWORD'), findsOneWidget);
    expect(find.text('At least 8 characters'), findsNWidgets(2));
    expect(find.text('CONFIRM NEW PASSWORD'), findsOneWidget);
    expect(find.text('Type it again'), findsOneWidget);
    expect(find.text('Contains a number'), findsOneWidget);
    expect(find.text('Both new passwords match'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNothing);
    expect(updateButton(tester).onPressed, isNull);

    // Rule rows are 14 px text next to 22 px circles.
    expect(
      tester.widget<Text>(find.text('Contains a number')).style?.fontSize,
      14,
    );
  });

  testWidgets('rules tick live; CTA enables once all three pass', (
    tester,
  ) async {
    await pump(tester);

    await tester.enterText(fieldLabeled('New password'), 'abcdefgh');
    await tester.pump();
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(updateButton(tester).onPressed, isNull);

    await tester.enterText(fieldLabeled('New password'), 'abcdefg1');
    await tester.pump();
    expect(find.byIcon(Icons.check), findsNWidgets(2));
    expect(updateButton(tester).onPressed, isNull);

    await tester.enterText(fieldLabeled('Confirm new password'), 'abcdefg1');
    await tester.pump();
    expect(find.byIcon(Icons.check), findsNWidgets(3));
    expect(updateButton(tester).onPressed, isNotNull);

    // Breaking the match disables it again.
    await tester.enterText(fieldLabeled('Confirm new password'), 'abcdefg2');
    await tester.pump();
    expect(find.byIcon(Icons.check), findsNWidgets(2));
    expect(updateButton(tester).onPressed, isNull);
  });

  testWidgets('Update password → cubit.submit(new password)', (tester) async {
    await pump(tester);
    await tester.enterText(fieldLabeled('New password'), 'abcdefg1');
    await tester.enterText(fieldLabeled('Confirm new password'), 'abcdefg1');
    await tester.pump();

    await tester.tap(find.text('Update password'));
    await tester.pump();

    verify(() => cubit.submit('abcdefg1')).called(1);
  });

  testWidgets('submitting → busy CTA, fields disabled', (tester) async {
    await pump(tester);
    await emit(tester, const ResetPasswordState.submitting());

    expect(updateButton(tester).loading, isTrue);
    expect(
      tester.widget<TextFormField>(fieldLabeled('New password')).enabled,
      isFalse,
    );
  });

  testWidgets('success → toast and go to Sign in', (tester) async {
    final router = await pump(tester);
    await emit(tester, const ResetPasswordState.success());
    await showToastFrames(tester);

    expect(find.text('Password updated'), findsOneWidget);
    expect(find.text('Sign in with your new password.'), findsOneWidget);
    expect(router.state.uri.path, AppRoutes.login);
    await settleToasts(tester);
  });

  testWidgets('failure → error toast, form kept', (tester) async {
    final router = await pump(tester);
    await emit(tester, const ResetPasswordState.failure('Server unavailable'));
    await showToastFrames(tester);

    expect(find.text('Server unavailable'), findsOneWidget);
    expect(router.state.uri.path, authScreenPath);
    expect(find.text('Choose a new password.'), findsOneWidget);
    await settleToasts(tester);
  });

  testWidgets('expired → headline, body, Request new link → Forgot', (
    tester,
  ) async {
    final router = await pump(
      tester,
      initial: const ResetPasswordState.expired(),
    );

    expect(find.text('This link has expired.'), findsOneWidget);
    expect(
      find.text(
        'Reset links work for 60 minutes. Request a new one to continue.',
      ),
      findsOneWidget,
    );
    expect(find.text('Request new link'), findsOneWidget);
    expect(find.text('Update password'), findsNothing);
    expect(find.byType(TextFormField), findsNothing);

    await tester.tap(find.text('Request new link'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, AuthRoutes.forgotPassword);
  });

  testWidgets('expired after submit swaps the form for the expired view', (
    tester,
  ) async {
    await pump(tester);
    await emit(tester, const ResetPasswordState.expired());

    expect(find.text('This link has expired.'), findsOneWidget);
    expect(find.text('Choose a new password.'), findsNothing);
  });
}
