import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/config/env.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/widgets/state_views.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_state.dart';
import 'package:penta_crew/features/auth/presentation/screens/splash_screen.dart';

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late _MockAuthCubit authCubit;

  setUp(() => authCubit = _MockAuthCubit());

  Future<void> pump(WidgetTester tester, AuthState state) async {
    whenListen(authCubit, const Stream<AuthState>.empty(), initialState: state);
    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: MaterialApp(theme: AppTheme.light(), home: const SplashScreen()),
      ),
    );
    await tester.pump();
  }

  testWidgets('A1: wordmark over the wide-tracked eyebrow while resolving', (
    tester,
  ) async {
    await pump(tester, const AuthState.unknown());

    expect(find.text(Env.appName), findsOneWidget);
    final eyebrow = tester.widget<Text>(find.text('FREELANCE EVENT CREW'));
    expect(eyebrow.style?.fontSize, 11);
    // 0.08em × 11px — wider than the 0.06em of every other eyebrow.
    expect(eyebrow.style?.letterSpacing, closeTo(0.88, 0.001));
  });

  testWidgets('unavailable → ErrorView with retry', (tester) async {
    when(() => authCubit.checkSession()).thenAnswer((_) async {});
    await pump(tester, const AuthState.unavailable('No connection.'));

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('No connection.'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    verify(() => authCubit.checkSession()).called(1);
  });
}
