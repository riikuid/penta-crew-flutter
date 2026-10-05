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
import 'package:penta_crew/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:penta_crew/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:penta_crew/features/auth/presentation/widgets/circle_back_button.dart';

import 'auth_test_app.dart';

class _MockForgotPasswordCubit extends MockCubit<ForgotPasswordState>
    implements ForgotPasswordCubit {}

void main() {
  late _MockForgotPasswordCubit cubit;
  late StreamController<ForgotPasswordState> states;

  setUp(() {
    cubit = _MockForgotPasswordCubit();
    states = StreamController<ForgotPasswordState>.broadcast();
    whenListen(
      cubit,
      states.stream,
      initialState: const ForgotPasswordState.idle(),
    );
    when(() => cubit.submit(any())).thenAnswer((_) async {});
  });

  tearDown(() => states.close());

  Future<GoRouter> pump(WidgetTester tester, {String? initialEmail}) =>
      pumpAuthScreen(
        tester,
        BlocProvider<ForgotPasswordCubit>.value(
          value: cubit,
          child: ForgotPasswordScreen(initialEmail: initialEmail),
        ),
      );

  Future<void> emit(WidgetTester tester, ForgotPasswordState state) async {
    states.add(state);
    await tester.pump();
    await tester.pump();
  }

  testWidgets('A2b: copy, circle back, email prefilled from Sign in', (
    tester,
  ) async {
    await pump(tester, initialEmail: 'nadia@example.com');

    expect(find.byType(CircleBackButton), findsOneWidget);
    expect(find.text('CREW ACCOUNT'), findsOneWidget);
    expect(find.text('Reset your password.'), findsOneWidget);
    expect(
      find.text(
        "Enter the email you registered with and we'll send you a link.",
      ),
      findsOneWidget,
    );
    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('Send link'), findsOneWidget);
    expect(find.text('Back to sign in'), findsOneWidget);
    expect(
      tester.widget<TextFormField>(fieldLabeled('Email')).controller?.text,
      'nadia@example.com',
    );
    expect(
      tester.widget<Text>(find.text('Reset your password.')).style?.fontSize,
      40,
    );
    final back = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Back to sign in'),
    );
    expect(back.variant, AppButtonVariant.ghost);
    expect(back.size, AppButtonSize.medium);
  });

  testWidgets('empty / invalid email → validation, no cubit call', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('name@email.com'), findsOneWidget);

    await tester.tap(find.text('Send link'));
    await tester.pump();
    expect(find.text('Enter a valid email address.'), findsOneWidget);

    await tester.enterText(fieldLabeled('Email'), 'nope');
    await tester.tap(find.text('Send link'));
    await tester.pump();
    expect(find.text('Enter a valid email address.'), findsOneWidget);

    verifyNever(() => cubit.submit(any()));
  });

  testWidgets('valid email → cubit.submit', (tester) async {
    await pump(tester);
    await tester.enterText(fieldLabeled('Email'), 'nadia@example.com');
    await tester.tap(find.text('Send link'));
    await tester.pump();

    verify(() => cubit.submit('nadia@example.com')).called(1);
  });

  testWidgets('submitting → busy CTA, field disabled', (tester) async {
    await pump(tester);
    await emit(tester, const ForgotPasswordState.submitting());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<TextFormField>(fieldLabeled('Email')).enabled,
      isFalse,
    );
  });

  testWidgets('sent → always moves on to Check your email with the email', (
    tester,
  ) async {
    final router = await pump(tester);
    states.add(const ForgotPasswordState.sent('nadia@example.com'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AuthRoutes.checkEmail);
    expect(router.state.extra, 'nadia@example.com');
  });

  testWidgets('failure → error toast, stays on the form', (tester) async {
    final router = await pump(tester);
    await emit(tester, const ForgotPasswordState.failure('Too many attempts.'));
    await showToastFrames(tester);

    expect(find.text('Too many attempts.'), findsOneWidget);
    expect(router.state.uri.path, authScreenPath);
    await settleToasts(tester);
  });

  testWidgets('Back to sign in → /login', (tester) async {
    final router = await pump(tester);
    await tester.tap(find.text('Back to sign in'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.login);
  });

  testWidgets('circle back with nothing beneath → /login', (tester) async {
    final router = await pump(tester);
    await tester.tap(find.byType(CircleBackButton));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.login);
  });
}
