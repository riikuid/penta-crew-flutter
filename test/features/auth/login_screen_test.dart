import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/core/widgets/app_button.dart';
import 'package:penta_crew/core/widgets/labeled_field.dart';
import 'package:penta_crew/features/auth/auth_routes.dart';
import 'package:penta_crew/features/auth/presentation/cubit/login_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/login_state.dart';
import 'package:penta_crew/features/auth/presentation/screens/login_screen.dart';

import 'auth_test_app.dart';

class _MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  late _MockLoginCubit cubit;
  late StreamController<LoginState> states;

  setUp(() {
    cubit = _MockLoginCubit();
    states = StreamController<LoginState>.broadcast();
    whenListen(cubit, states.stream, initialState: const LoginState.idle());
    when(
      () => cubit.submit(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() => states.close());

  /// Adds [state] and pumps twice: one to deliver the stream event, one to
  /// draw the frame it scheduled.
  Future<void> emit(WidgetTester tester, LoginState state) async {
    states.add(state);
    await tester.pump();
    await tester.pump();
  }

  Future<GoRouter> pump(WidgetTester tester, {String? from}) => pumpAuthScreen(
    tester,
    BlocProvider<LoginCubit>.value(
      value: cubit,
      child: LoginScreen(from: from),
    ),
  );

  Future<void> fillCredentials(WidgetTester tester) async {
    await tester.enterText(fieldLabeled('Email'), 'nadia@example.com');
    await tester.enterText(fieldLabeled('Password'), 'password1');
  }

  testWidgets('A2: prototype copy, link below the password field', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('CREW ACCOUNT'), findsOneWidget);
    expect(find.text('Welcome back.'), findsOneWidget);
    expect(
      find.text('Sign in with the email you registered with.'),
      findsOneWidget,
    );
    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('name@email.com'), findsOneWidget);
    expect(find.text('PASSWORD'), findsOneWidget);
    expect(find.text('Enter password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.byTooltip('Show password'), findsOneWidget);

    // "Forgot password?" sits under the password field, right-aligned.
    final link = tester.getRect(find.text('Forgot password?'));
    final password = tester.getRect(fieldLabeled('Password'));
    expect(link.top, greaterThanOrEqualTo(password.bottom));
    expect(link.right, closeTo(password.right, 8));

    // Headline is the 44 px display variant.
    expect(tester.widget<Text>(find.text('Welcome back.')).style?.fontSize, 44);
  });

  testWidgets('validation messages from the copy table, no cubit call', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Sign in'));
    await tester.pump();
    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await tester.enterText(fieldLabeled('Email'), 'not-an-email');
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    expect(find.text('Enter a valid email address.'), findsOneWidget);

    verifyNever(
      () => cubit.submit(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('valid form → cubit.submit with trimmed email', (tester) async {
    await pump(tester);
    await tester.enterText(fieldLabeled('Email'), '  nadia@example.com ');
    await tester.enterText(fieldLabeled('Password'), 'password1');

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    verify(
      () => cubit.submit(email: 'nadia@example.com', password: 'password1'),
    ).called(1);
  });

  testWidgets('keyboard: email → next, password submits', (tester) async {
    await pump(tester);
    await fillCredentials(tester);

    expect(
      tester.widget<AppTextField>(appField('Email')).textInputAction,
      TextInputAction.next,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    verify(
      () => cubit.submit(email: 'nadia@example.com', password: 'password1'),
    ).called(1);
  });

  testWidgets('submitting → busy button, disabled fields', (tester) async {
    await pump(tester);
    await emit(tester, const LoginState.submitting());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<TextFormField>(fieldLabeled('Email')).enabled,
      isFalse,
    );
    final signIn = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Sign in'),
    );
    expect(signIn.loading, isTrue);
  });

  testWidgets(
    'A3: invalid credentials → inline error, email kept, password cleared',
    (tester) async {
      await pump(tester);
      await fillCredentials(tester);

      await emit(tester, const LoginState.invalidCredentials());

      expect(find.text('Email or password is incorrect.'), findsOneWidget);
      expect(find.byType(FieldError), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(
        tester.widget<TextFormField>(fieldLabeled('Email')).controller?.text,
        'nadia@example.com',
      );
      expect(
        tester.widget<TextFormField>(fieldLabeled('Password')).controller?.text,
        isEmpty,
      );
      // Not a toast.
      await showToastFrames(tester);
      expect(find.byIcon(Icons.close), findsNothing);

      // Typing again clears the row.
      await tester.enterText(fieldLabeled('Password'), 'p');
      await tester.pump();
      expect(find.text('Email or password is incorrect.'), findsNothing);
    },
  );

  testWidgets('generic failure → error toast with the server message', (
    tester,
  ) async {
    await pump(tester);
    await emit(tester, const LoginState.failure(message: 'Server unavailable'));
    await showToastFrames(tester);

    expect(find.text('Server unavailable'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
    await settleToasts(tester);
  });

  testWidgets('422 fieldErrors land under their fields', (tester) async {
    await pump(tester);
    await emit(
      tester,
      const LoginState.failure(
        message: 'Invalid.',
        fieldErrors: {
          'email': ['The email field is required.'],
        },
      ),
    );

    expect(find.text('The email field is required.'), findsOneWidget);
  });

  testWidgets('success → go home, or to `from` when set', (tester) async {
    final router = await pump(tester, from: '${AppRoutes.verification}?tab=2');
    states.add(const LoginState.success());
    await tester.pumpAndSettle();

    expect(router.state.uri.toString(), '${AppRoutes.verification}?tab=2');
  });

  testWidgets('success without `from` → home', (tester) async {
    final router = await pump(tester);
    states.add(const LoginState.success());
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.home);
  });

  testWidgets('Create account → /register', (tester) async {
    final router = await pump(tester);
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AuthRoutes.register);
  });

  testWidgets('Forgot password? → /forgot-password with the typed email', (
    tester,
  ) async {
    final router = await pump(tester);
    await tester.enterText(fieldLabeled('Email'), 'nadia@example.com');
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AuthRoutes.forgotPassword);
    expect(router.state.extra, 'nadia@example.com');
  });
}
