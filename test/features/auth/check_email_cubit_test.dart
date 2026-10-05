import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/auth/presentation/cubit/check_email_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/check_email_state.dart';
import 'package:penta_crew/features/auth/usecases/forgot_password.dart';

class _MockForgotPassword extends Mock implements ForgotPassword {}

class _FakeParams extends Fake implements ForgotPasswordParams {}

/// The cooldown is a real `Timer`, so these run as widget tests: `tester.pump`
/// advances fake time instead of waiting 60 real seconds.
void main() {
  late _MockForgotPassword forgotPassword;
  late CheckEmailCubit cubit;
  late List<CheckEmailState> emitted;

  setUpAll(() => registerFallbackValue(_FakeParams()));

  setUp(() => forgotPassword = _MockForgotPassword());

  // Pending timers fail a widget test, so every test closes the cubit itself
  // before it returns; this only covers an early failure.
  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
  });

  void start() {
    cubit = CheckEmailCubit(forgotPassword, email: 'nadia@example.com');
    emitted = [];
    cubit.stream.listen(emitted.add);
  }

  testWidgets('starts cooling down at 60 s and counts down to ready', (
    tester,
  ) async {
    start();
    expect(cubit.state, const CheckEmailState.coolingDown(60));

    await tester.pump(const Duration(seconds: 1));
    expect(cubit.state, const CheckEmailState.coolingDown(59));

    await tester.pump(const Duration(seconds: 58));
    expect(cubit.state, const CheckEmailState.coolingDown(1));

    await tester.pump(const Duration(seconds: 1));
    expect(cubit.state, const CheckEmailState.ready());

    // The timer is gone: nothing else is emitted afterwards.
    await tester.pump(const Duration(seconds: 5));
    expect(cubit.state, const CheckEmailState.ready());
    await cubit.close();
  });

  testWidgets('resend is ignored while cooling down', (tester) async {
    start();
    await cubit.resend();
    verifyNever(() => forgotPassword(any()));
    await cubit.close();
  });

  testWidgets('resend success → resent, then the cooldown restarts', (
    tester,
  ) async {
    when(() => forgotPassword(any()))
        .thenAnswer((_) async => const Result.success(null));
    start();
    await tester.pump(const Duration(seconds: 60));
    expect(cubit.state, const CheckEmailState.ready());

    await cubit.resend();
    await tester.pump();

    expect(emitted.sublist(emitted.length - 3), const [
      CheckEmailState.resending(),
      CheckEmailState.resent(),
      CheckEmailState.coolingDown(60),
    ]);
    final params =
        verify(() => forgotPassword(captureAny())).captured.single
            as ForgotPasswordParams;
    expect(params.email, 'nadia@example.com');

    await tester.pump(const Duration(seconds: 1));
    expect(cubit.state, const CheckEmailState.coolingDown(59));
    await cubit.close();
  });

  testWidgets('resend failure → failure(message), then ready again', (
    tester,
  ) async {
    when(() => forgotPassword(any()))
        .thenAnswer((_) async => const Result.failed('Too many attempts.'));
    start();
    await tester.pump(const Duration(seconds: 60));

    await cubit.resend();
    await tester.pump();

    expect(emitted.sublist(emitted.length - 3), const [
      CheckEmailState.resending(),
      CheckEmailState.failure('Too many attempts.'),
      CheckEmailState.ready(),
    ]);
    await cubit.close();
  });
}
