import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/router/app_router.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/core/session/session_info.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/features/auth/auth_routes.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_state.dart';
import 'package:penta_crew/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:penta_crew/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:penta_crew/features/auth/presentation/screens/splash_screen.dart';
import 'package:penta_crew/features/auth/usecases/reset_password.dart';

class _FakeSession implements SessionInfo {
  @override
  bool isResolving = false;
  @override
  bool isAuthenticated = false;
  @override
  bool isVerified = false;
  @override
  Set<String> permissions = const {};
}

class _MockResetPassword extends Mock implements ResetPassword {}

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

/// The deep link the backend emails (D-02), through the REAL router config:
/// `buildAppRouter` with the auth routes exactly as the app registers them.
void main() {
  final sl = GetIt.instance;
  late _FakeSession session;
  late _MockAuthCubit authCubit;
  late List<({String token, String email})> cubitParams;

  setUp(() {
    session = _FakeSession();
    sl.registerSingleton<SessionInfo>(session);
    // Only what the reset route builder resolves; the real cubit runs on a
    // mocked usecase so the token/email handed to it can be asserted.
    cubitParams = [];
    sl.registerFactoryParam<ResetPasswordCubit, String, String>((
      token,
      email,
    ) {
      cubitParams.add((token: token, email: email));
      return ResetPasswordCubit(
        _MockResetPassword(),
        token: token,
        email: email,
      );
    });
    authCubit = _MockAuthCubit();
    whenListen(
      authCubit,
      const Stream<AuthState>.empty(),
      initialState: const AuthState.unknown(),
    );
  });

  tearDown(() async => sl.reset());

  Future<GoRouter> pumpRouter(WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final refresh = ValueNotifier(0);
    addTearDown(refresh.dispose);
    final router = buildAppRouter(refreshListenable: refresh);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  ResetPasswordScreen resetScreen(WidgetTester tester) =>
      tester.widget<ResetPasswordScreen>(find.byType(ResetPasswordScreen));

  testWidgets('/reset-password?token=&email= → Reset screen gets both', (
    tester,
  ) async {
    final router = await pumpRouter(tester);
    router.go('${AuthRoutes.resetPassword}?token=abc&email=a%40b.c');
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AuthRoutes.resetPassword);
    expect(resetScreen(tester).token, 'abc');
    expect(resetScreen(tester).email, 'a@b.c');
    expect(cubitParams, [(token: 'abc', email: 'a@b.c')]);
    expect(find.text('Choose a new password.'), findsOneWidget);
  });

  testWidgets('Laravel shape /reset-password/<token>?email= works too', (
    tester,
  ) async {
    final router = await pumpRouter(tester);
    router.go('${AuthRoutes.resetPassword}/abc?email=a%40b.c');
    await tester.pumpAndSettle();

    expect(resetScreen(tester).token, 'abc');
    expect(resetScreen(tester).email, 'a@b.c');
    expect(cubitParams, [(token: 'abc', email: 'a@b.c')]);
  });

  testWidgets('no token → expired state straight away', (tester) async {
    final router = await pumpRouter(tester);
    router.go('${AuthRoutes.resetPassword}?email=a%40b.c');
    await tester.pumpAndSettle();

    expect(resetScreen(tester).token, isEmpty);
    expect(find.text('This link has expired.'), findsOneWidget);
    expect(find.text('Request new link'), findsOneWidget);
  });

  testWidgets('reachable while signed in (no guestOnly on reset)', (
    tester,
  ) async {
    session
      ..isAuthenticated = true
      ..isVerified = true;
    final router = await pumpRouter(tester);
    router.go('${AuthRoutes.resetPassword}?token=abc&email=a%40b.c');
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AuthRoutes.resetPassword);
    expect(resetScreen(tester).token, 'abc');
  });

  testWidgets('cold start while the session resolves parks on splash '
      'with the full link in ?from=', (tester) async {
    session.isResolving = true;
    final router = await pumpRouter(tester);
    router.go('${AuthRoutes.resetPassword}?token=abc&email=a%40b.c');
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.splash);
    expect(
      router.state.uri.queryParameters[AppRoutes.fromParam],
      '${AuthRoutes.resetPassword}?token=abc&email=a%40b.c',
    );
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(ResetPasswordScreen), findsNothing);
  });
}
