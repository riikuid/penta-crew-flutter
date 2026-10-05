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
import 'package:penta_crew/core/widgets/skeleton.dart';
import 'package:penta_crew/core/widgets/state_views.dart';
import 'package:penta_crew/features/auth/models/branch.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/presentation/cubit/register_cubit.dart';
import 'package:penta_crew/features/auth/presentation/cubit/register_state.dart';
import 'package:penta_crew/features/auth/presentation/screens/register_screen.dart';
import 'package:penta_crew/features/auth/presentation/widgets/circle_back_button.dart';
import 'package:penta_crew/features/auth/presentation/widgets/step_header.dart';

import 'auth_test_app.dart';

class _MockRegisterCubit extends MockCubit<RegisterState>
    implements RegisterCubit {}

const _jakarta = Branch(id: 1, name: 'Jakarta');
const _bandung = Branch(id: 2, name: 'Bandung');

/// The tappable row of the `AppPickerField` labelled [label].
Finder picker(String label) => find.descendant(
  of: find.widgetWithText(AppPickerField, label.toUpperCase()),
  matching: find.byType(InkWell),
);

const _profileStep = RegisterState(
  step: RegisterStep.profile,
  name: 'Rina Maharani',
  email: 'rina@example.com',
  phone: '081234567890',
  password: 'password1',
);

void main() {
  late _MockRegisterCubit cubit;
  late StreamController<RegisterState> states;

  setUpAll(() => registerFallbackValue(Gender.female));

  setUp(() {
    cubit = _MockRegisterCubit();
    states = StreamController<RegisterState>.broadcast();
    when(() => cubit.loadBranches()).thenAnswer((_) async {});
    when(
      () => cubit.submit(address: any(named: 'address')),
    ).thenAnswer((_) async {});
  });

  tearDown(() => states.close());

  Future<GoRouter> pump(
    WidgetTester tester, {
    RegisterState initial = const RegisterState(),
  }) {
    whenListen(cubit, states.stream, initialState: initial);
    return pumpAuthScreen(
      tester,
      BlocProvider<RegisterCubit>.value(
        value: cubit,
        child: const RegisterScreen(),
      ),
    );
  }

  Future<void> emit(WidgetTester tester, RegisterState state) async {
    states.add(state);
    await tester.pump();
    await tester.pump();
  }

  group('A4 account step', () {
    testWidgets('prototype copy, step header 01 / 02, Continue with arrow', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('01 / 02'), findsOneWidget);
      expect(find.byType(CircleBackButton), findsOneWidget);
      expect(find.text('Tell us who you are.'), findsOneWidget);
      expect(
        find.text("Account details. You'll add your crew profile next."),
        findsOneWidget,
      );
      for (final label in [
        'FULL NAME',
        'EMAIL',
        'PHONE NUMBER',
        'PASSWORD',
        'CONFIRM PASSWORD',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      expect(find.text('As on your ID'), findsOneWidget);
      expect(find.text('name@email.com'), findsOneWidget);
      expect(find.text('0812 3456 7890'), findsOneWidget);
      expect(find.text('At least 8 characters'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

      // Counter is the 11/600 eyebrow style, not uppercased (digits only).
      final counter = tester.widget<Text>(find.text('01 / 02'));
      expect(counter.style?.fontSize, 11);
      expect(counter.style?.fontWeight, FontWeight.w600);

      // Two 4 px pills, only the first is ink on step 01.
      final header = tester.widget<StepHeader>(find.byType(StepHeader));
      expect(header.step, 1);
      expect(header.total, 2);
    });

    testWidgets('Continue → submitAccountStep with the typed values', (
      tester,
    ) async {
      await pump(tester);
      await tester.enterText(fieldLabeled('Full name'), 'Rina Maharani');
      await tester.enterText(fieldLabeled('Email'), 'rina@example.com');
      await tester.enterText(fieldLabeled('Phone number'), '081234567890');
      await tester.enterText(fieldLabeled('Password'), 'password1');
      await tester.enterText(fieldLabeled('Confirm password'), 'password1');

      await tester.tap(find.text('Continue'));
      await tester.pump();

      verify(
        () => cubit.submitAccountStep(
          name: 'Rina Maharani',
          email: 'rina@example.com',
          phone: '081234567890',
          password: 'password1',
          confirmPassword: 'password1',
        ),
      ).called(1);
    });

    testWidgets('errors from the state render under their fields', (
      tester,
    ) async {
      await pump(
        tester,
        initial: const RegisterState(
          errors: {
            RegisterField.name: 'Enter your full name.',
            RegisterField.email: 'Enter a valid email address.',
            RegisterField.phone: 'Enter your phone number.',
            RegisterField.password:
                'Use at least 8 characters with a number.',
            RegisterField.passwordConfirmation: "Passwords don't match.",
          },
        ),
      );

      expect(find.byType(FieldError), findsNWidgets(5));
      expect(find.text('Enter your full name.'), findsOneWidget);
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(find.text('Enter your phone number.'), findsOneWidget);
      expect(
        find.text('Use at least 8 characters with a number.'),
        findsOneWidget,
      );
      expect(find.text("Passwords don't match."), findsOneWidget);

      // Editing a field asks the cubit to drop that error.
      await tester.enterText(fieldLabeled('Email'), 'r');
      verify(() => cubit.clearError(RegisterField.email)).called(1);
    });

    testWidgets('back on step 01 leaves the screen (login fallback)', (
      tester,
    ) async {
      final router = await pump(tester);
      await tester.tap(find.byType(CircleBackButton));
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.login);
    });
  });

  group('A5 profile step', () {
    testWidgets('prototype copy, 02 / 02, pickers, note, Submit for review', (
      tester,
    ) async {
      await pump(tester, initial: _profileStep);

      expect(find.text('02 / 02'), findsOneWidget);
      expect(find.text('Your crew profile.'), findsOneWidget);
      expect(
        find.text('An admin reviews this before your first event.'),
        findsOneWidget,
      );
      expect(find.text('DATE OF BIRTH'), findsOneWidget);
      expect(find.text('DD / MM / YYYY'), findsOneWidget);
      expect(find.text('GENDER'), findsOneWidget);
      expect(find.text('BRANCH'), findsOneWidget);
      expect(find.text('Select'), findsNWidgets(2));
      expect(find.text('HOME ADDRESS'), findsOneWidget);
      expect(find.text('Street, district, city'), findsOneWidget);
      expect(
        find.text(
          'Your crew roles and tags are set by an admin after they review '
          'your profile.',
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.text('Submit for review'), findsOneWidget);
      expect(tester.widget<StepHeader>(find.byType(StepHeader)).step, 2);

      // Address is a 3-row text area.
      expect(
        tester.widget<AppTextField>(appField('Home address')).maxLines,
        3,
      );
    });

    testWidgets('shows chosen values: dd / MM / yyyy, gender, branch', (
      tester,
    ) async {
      await pump(
        tester,
        initial: _profileStep.copyWith(
          dateOfBirth: DateTime(1999, 4, 12),
          gender: Gender.male,
          branch: _jakarta,
        ),
      );

      expect(find.text('12 / 04 / 1999'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Jakarta'), findsOneWidget);
      expect(find.text('Select'), findsNothing);
    });

    testWidgets('validation errors render under the pickers and address', (
      tester,
    ) async {
      await pump(
        tester,
        initial: _profileStep.copyWith(
          errors: const {
            RegisterField.dateOfBirth: 'Enter your date of birth.',
            RegisterField.gender: 'Select your gender.',
            RegisterField.branchId: 'Select your branch.',
            RegisterField.address: 'Enter your home address.',
          },
        ),
      );

      expect(find.text('Enter your date of birth.'), findsOneWidget);
      expect(find.text('Select your gender.'), findsOneWidget);
      expect(find.text('Select your branch.'), findsOneWidget);
      expect(find.text('Enter your home address.'), findsOneWidget);
    });

    testWidgets('gender picker: Female / Male → setGender', (tester) async {
      await pump(tester, initial: _profileStep);
      await tester.tap(picker('Gender'));
      await tester.pumpAndSettle();

      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      await tester.tap(find.text('Female'));
      await tester.pumpAndSettle();

      verify(() => cubit.setGender(Gender.female)).called(1);
    });

    testWidgets('branch picker: loads on open, skeleton → rows → setBranch', (
      tester,
    ) async {
      await pump(tester, initial: _profileStep);
      await tester.tap(picker('Branch'));
      await tester.pumpAndSettle();
      verify(() => cubit.loadBranches()).called(1);

      await emit(tester, _profileStep.copyWith(branchesLoading: true));
      expect(find.byType(Skeleton), findsWidgets);

      await emit(
        tester,
        _profileStep.copyWith(branches: const [_jakarta, _bandung]),
      );
      expect(find.byType(Skeleton), findsNothing);
      expect(find.text('Jakarta'), findsOneWidget);
      expect(find.text('Bandung'), findsOneWidget);

      await tester.tap(find.text('Bandung'));
      await tester.pumpAndSettle();
      verify(() => cubit.setBranch(_bandung)).called(1);
    });

    testWidgets('branch picker: error → ErrorView, retry reloads', (
      tester,
    ) async {
      await pump(tester, initial: _profileStep);
      await tester.tap(picker('Branch'));
      await tester.pumpAndSettle();

      await emit(
        tester,
        _profileStep.copyWith(branchesError: 'Network error'),
      );
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();
      verify(() => cubit.loadBranches()).called(2);
    });

    testWidgets('Submit for review → cubit.submit(address)', (tester) async {
      await pump(tester, initial: _profileStep);
      await tester.enterText(
        fieldLabeled('Home address'),
        'Jl. Kemang Raya 10',
      );
      await tester.tap(find.text('Submit for review'));
      await tester.pump();

      verify(() => cubit.submit(address: 'Jl. Kemang Raya 10')).called(1);
    });

    testWidgets('submitting → busy CTA, pickers disabled', (tester) async {
      await pump(
        tester,
        initial: _profileStep.copyWith(status: RegisterStatus.submitting),
      );

      final button = tester.widget<AppButton>(
        find.widgetWithText(AppButton, 'Submit for review'),
      );
      expect(button.loading, isTrue);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final pickers = tester.widgetList<AppPickerField>(
        find.byType(AppPickerField),
      );
      expect(pickers.every((picker) => !picker.enabled), isTrue);
    });

    testWidgets('back → backToAccountStep (values kept by the cubit)', (
      tester,
    ) async {
      await pump(tester, initial: _profileStep);
      await tester.tap(find.byType(CircleBackButton));
      await tester.pump();

      verify(() => cubit.backToAccountStep()).called(1);
    });

    testWidgets('success → go home', (tester) async {
      final router = await pump(tester, initial: _profileStep);
      states.add(_profileStep.copyWith(status: RegisterStatus.success));
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.home);
    });

    testWidgets('failure → error toast with the server message', (
      tester,
    ) async {
      await pump(tester, initial: _profileStep);
      await emit(
        tester,
        _profileStep.copyWith(
          status: RegisterStatus.failure,
          failureMessage: 'Server unavailable',
        ),
      );
      await showToastFrames(tester);

      expect(find.text('Server unavailable'), findsOneWidget);
      await settleToasts(tester);
    });
  });
}
