import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/usecase/usecase.dart';
import 'package:penta_crew/core/widgets/state_views.dart';
import 'package:penta_crew/features/auth/models/branch.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/repositories/auth_repository.dart'
    show ProfileFields;
import 'package:penta_crew/features/auth/usecases/get_branches.dart';
import 'package:penta_crew/features/auth/usecases/resubmit_verification.dart';
import 'package:penta_crew/features/auth/usecases/update_profile.dart';
import 'package:penta_crew/features/auth/usecases/upload_avatar.dart';
import 'package:penta_crew/features/profile/avatar_picker.dart';
import 'package:penta_crew/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:penta_crew/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:penta_crew/features/profile/profile_routes.dart';

import 'profile_test_harness.dart';

class _MockGetBranches extends Mock implements GetBranches {}

class _MockUpdateProfile extends Mock implements UpdateProfile {}

class _MockUploadAvatar extends Mock implements UploadAvatar {}

class _MockResubmitVerification extends Mock implements ResubmitVerification {}

class _MockAvatarPicker extends Mock implements AvatarPicker {}

const _branches = [jakarta, Branch(id: 2, name: 'Bandung')];

void main() {
  late _MockGetBranches getBranches;
  late _MockUpdateProfile updateProfile;
  late _MockResubmitVerification resubmitVerification;
  late AuthHarness auth;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      ProfileFields(
        name: '',
        phone: '',
        dateOfBirth: DateTime(2000),
        gender: Gender.female,
        branchId: 1,
        address: '',
      ),
    );
  });

  setUp(() {
    getBranches = _MockGetBranches();
    updateProfile = _MockUpdateProfile();
    resubmitVerification = _MockResubmitVerification();
    when(() => getBranches(any())).thenAnswer(
      (_) async => const Result.success(_branches),
    );
  });

  tearDown(() => auth.dispose());

  /// Pushes E2 on top of a root page so `context.pop()` has somewhere to go.
  Future<GoRouter> pump(WidgetTester tester, {User? user}) async {
    auth = AuthHarness(user ?? approvedUser);
    final router = await pumpRouted(
      tester,
      home: const Scaffold(body: Text('root')),
      auth: auth.cubit,
      extraRoutes: [
        GoRoute(
          path: ProfileRoutes.edit,
          builder: (context, state) => BlocProvider(
            create: (_) => EditProfileCubit(
              getBranches: getBranches,
              updateProfile: updateProfile,
              uploadAvatar: _MockUploadAvatar(),
              resubmitVerification: resubmitVerification,
              avatarPicker: _MockAvatarPicker(),
              auth: auth.cubit,
            )..load(),
            child: const EditProfileScreen(),
          ),
        ),
      ],
    );
    router.push(ProfileRoutes.edit);
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('loading: spinner while branches load, no form yet', (tester) async {
    final completer = Completer<Result<List<Branch>>>();
    when(() => getBranches(any())).thenAnswer((_) => completer.future);
    auth = AuthHarness(approvedUser);
    final router = await pumpRouted(
      tester,
      home: const Scaffold(body: Text('root')),
      auth: auth.cubit,
      extraRoutes: [
        GoRoute(
          path: ProfileRoutes.edit,
          builder: (context, state) => BlocProvider(
            create: (_) => EditProfileCubit(
              getBranches: getBranches,
              updateProfile: updateProfile,
              uploadAvatar: _MockUploadAvatar(),
              resubmitVerification: resubmitVerification,
              avatarPicker: _MockAvatarPicker(),
              auth: auth.cubit,
            )..load(),
            child: const EditProfileScreen(),
          ),
        ),
      ],
    );
    router.push(ProfileRoutes.edit);
    await tester.pump();
    await tester.pump();

    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.byType(LoadingView), findsOneWidget);
    expect(find.text('Save changes'), findsNothing);

    completer.complete(const Result.success(_branches));
    await tester.pumpAndSettle();
    expect(find.text('Save changes'), findsOneWidget);
  });

  testWidgets('error: ErrorView with retry that reloads', (tester) async {
    when(() => getBranches(any())).thenAnswer(
      (_) async => const Result.failed("Can't reach the server."),
    );
    await pump(tester);

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text("Can't reach the server."), findsOneWidget);

    when(() => getBranches(any())).thenAnswer(
      (_) async => const Result.success(_branches),
    );
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Save changes'), findsOneWidget);
    verify(() => getBranches(any())).called(2);
  });

  testWidgets('loaded: prefilled fields, read-only email, no re-review note',
      (tester) async {
    await pump(tester);

    expect(find.text('RA'), findsOneWidget);
    expect(find.text('Change photo'), findsOneWidget);
    expect(find.text('FULL NAME'), findsOneWidget);
    expect(find.text('Rina Anggraini'), findsOneWidget);
    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('rina.anggraini@email.com'), findsOneWidget);
    final email = tester.widget<TextFormField>(
      find.ancestor(
        of: find.text('rina.anggraini@email.com'),
        matching: find.byType(TextFormField),
      ),
    );
    expect(email.enabled, isFalse);
    expect(find.text('PHONE'), findsOneWidget);
    expect(find.text('+62 812 3456 7890'), findsOneWidget);
    expect(find.text('DATE OF BIRTH'), findsOneWidget);
    expect(find.text('14 / 03 / 2000'), findsOneWidget);
    expect(find.text('GENDER'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);
    expect(find.text('BRANCH'), findsOneWidget);
    expect(find.text('Jakarta'), findsOneWidget);
    expect(find.text('HOME ADDRESS'), findsOneWidget);
    expect(find.text('Jl. Tebet Raya 21, Tebet, Jakarta Selatan'), findsOneWidget);
    expect(find.text('Save changes'), findsOneWidget);
    // D-08
    expect(find.textContaining('back to admin review'), findsNothing);
  });

  testWidgets('empty required fields show the A4/A5 validation copy', (tester) async {
    await pump(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Rina Anggraini'), '');
    await tester.enterText(find.widgetWithText(TextFormField, '+62 812 3456 7890'), '');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Jl. Tebet Raya 21, Tebet, Jakarta Selatan'),
      '',
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your full name.'), findsOneWidget);
    expect(find.text('Enter your phone number.'), findsOneWidget);
    expect(find.text('Enter your home address.'), findsOneWidget);
    verifyNever(() => updateProfile(any()));
  });

  testWidgets('branch picker lists GET /branches and updates the field', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Jakarta'));
    await tester.pumpAndSettle();
    expect(find.text('Branch'), findsOneWidget);
    expect(find.text('Bandung'), findsOneWidget);

    await tester.tap(find.text('Bandung'));
    await tester.pumpAndSettle();
    expect(find.text('Bandung'), findsOneWidget);
    expect(find.text('Jakarta'), findsNothing);
  });

  testWidgets('save: sends the fields, updates AuthCubit, toasts and pops',
      (tester) async {
    final updated = approvedUser.copyWith(name: 'Rina Putri');
    when(() => updateProfile(any())).thenAnswer(
      (_) async => Result.success(updated),
    );
    await pump(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Rina Anggraini'),
      'Rina Putri',
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final fields = verify(() => updateProfile(captureAny())).captured.single
        as ProfileFields;
    expect(fields.name, 'Rina Putri');
    expect(fields.phone, '+62 812 3456 7890');
    expect(fields.dateOfBirth, DateTime(2000, 3, 14));
    expect(fields.gender, Gender.female);
    expect(fields.branchId, 1);
    expect(fields.address, 'Jl. Tebet Raya 21, Tebet, Jakarta Selatan');
    expect(auth.cubit.user, updated);
    expect(find.text('Profile updated'), findsOneWidget);
    expect(find.text('Your changes are saved.'), findsOneWidget);
    expect(find.text('root'), findsOneWidget);
    verifyNever(() => resubmitVerification(any()));

    // Let the toast's auto-close timer run out before teardown.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('save: 422 errors land under their fields', (tester) async {
    when(() => updateProfile(any())).thenAnswer(
      (_) async => const Result.failed(
        'The given data was invalid.',
        statusCode: 422,
        fieldErrors: {
          'phone': ['The phone format is invalid.'],
          'branch_id': ['The selected branch is invalid.'],
        },
      ),
    );
    await pump(tester);

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('The phone format is invalid.'), findsOneWidget);
    expect(find.text('The selected branch is invalid.'), findsOneWidget);
    expect(find.text('The given data was invalid.'), findsNothing);
    expect(find.text('Save changes'), findsOneWidget);
  });

  testWidgets('rejected user: CTA reads "Submit again" and resubmits after saving',
      (tester) async {
    final resubmitted = rejectedUser.copyWith(
      verificationStatus: VerificationStatus.pending,
      verificationNote: null,
    );
    when(() => updateProfile(any())).thenAnswer(
      (_) async => Result.success(rejectedUser),
    );
    when(() => resubmitVerification(any())).thenAnswer(
      (_) async => Result.success(resubmitted),
    );
    await pump(tester, user: rejectedUser);

    expect(find.text('Submit again'), findsOneWidget);
    expect(find.text('Save changes'), findsNothing);

    await tester.tap(find.text('Submit again'));
    await tester.pumpAndSettle();

    verifyInOrder([
      () => updateProfile(any()),
      () => resubmitVerification(any()),
    ]);
    expect(auth.cubit.user?.verificationStatus, VerificationStatus.pending);
    expect(find.text('root'), findsOneWidget);
    expect(find.text('Profile updated'), findsNothing);
  });
}
