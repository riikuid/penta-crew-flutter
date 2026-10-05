import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/core/widgets/app_button.dart';
import 'package:penta_crew/features/auth/presentation/cubit/check_email_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/check_email_state.dart';
import 'package:penta_crew/features/auth/presentation/screens/check_email_screen.dart';

import 'auth_test_app.dart';

class _MockCheckEmailCubit extends MockCubit<CheckEmailState>
    implements CheckEmailCubit {}

void main() {
  late _MockCheckEmailCubit cubit;
  late StreamController<CheckEmailState> states;

  setUp(() {
    cubit = _MockCheckEmailCubit();
    states = StreamController<CheckEmailState>.broadcast();
    when(() => cubit.resend()).thenAnswer((_) async {});
  });

  tearDown(() => states.close());

  Future<GoRouter> pump(
    WidgetTester tester, {
    CheckEmailState initial = const CheckEmailState.coolingDown(60),
  }) {
    whenListen(cubit, states.stream, initialState: initial);
    return pumpAuthScreen(
      tester,
      BlocProvider<CheckEmailCubit>.value(
        value: cubit,
        child: const CheckEmailScreen(email: 'nadia@example.com'),
      ),
    );
  }

  AppButton resendButton(WidgetTester tester) => tester.widget<AppButton>(
    find.byWidgetPredicate(
      (widget) => widget is AppButton && widget.label.startsWith('Resend'),
    ),
  );

  testWidgets('A2c: copy with the email, cooldown label, resend disabled', (
    tester,
  ) async {
    await pump(tester, initial: const CheckEmailState.coolingDown(42));

    expect(find.text('CREW ACCOUNT'), findsOneWidget);
    expect(find.text('Check your email.'), findsOneWidget);
    expect(
      find.text(
        "If nadia@example.com is registered, we've sent a link to reset your "
        'password. The link works for 60 minutes.',
      ),
      findsOneWidget,
    );
    expect(find.text('Back to sign in'), findsOneWidget);
    expect(find.text('Resend in 42s'), findsOneWidget);
    expect(find.text('Resend'), findsNothing);

    final resend = resendButton(tester);
    expect(resend.onPressed, isNull);
    expect(resend.variant, AppButtonVariant.ghost);
    expect(resend.size, AppButtonSize.medium);
  });

  testWidgets('counts down as the cubit ticks', (tester) async {
    await pump(tester, initial: const CheckEmailState.coolingDown(2));
    expect(find.text('Resend in 2s'), findsOneWidget);

    states.add(const CheckEmailState.coolingDown(1));
    await tester.pump();
    await tester.pump();
    expect(find.text('Resend in 1s'), findsOneWidget);
  });

  testWidgets('ready → "Resend" enabled, tap → cubit.resend', (tester) async {
    await pump(tester, initial: const CheckEmailState.ready());

    expect(find.text('Resend'), findsOneWidget);
    expect(resendButton(tester).onPressed, isNotNull);

    await tester.tap(find.text('Resend'));
    await tester.pump();
    verify(() => cubit.resend()).called(1);
  });

  testWidgets('resending → busy ghost button', (tester) async {
    await pump(tester, initial: const CheckEmailState.resending());

    expect(resendButton(tester).loading, isTrue);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('resent → "Link sent again" toast', (tester) async {
    await pump(tester, initial: const CheckEmailState.ready());
    states.add(const CheckEmailState.resent());
    await tester.pump();
    await tester.pump();
    await showToastFrames(tester);

    expect(find.text('Link sent again'), findsOneWidget);
    await settleToasts(tester);
  });

  testWidgets('failure → error toast with the message', (tester) async {
    await pump(tester, initial: const CheckEmailState.ready());
    states.add(const CheckEmailState.failure('Too many attempts.'));
    await tester.pump();
    await tester.pump();
    await showToastFrames(tester);

    expect(find.text('Too many attempts.'), findsOneWidget);
    await settleToasts(tester);
  });

  testWidgets('Back to sign in → /login', (tester) async {
    final router = await pump(tester);
    await tester.tap(find.text('Back to sign in'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.login);
  });
}
