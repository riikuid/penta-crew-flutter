import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/usecase/usecase.dart';
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
import 'package:penta_crew/features/profile/presentation/cubit/edit_profile_state.dart';

import 'profile_test_harness.dart';

class _MockGetBranches extends Mock implements GetBranches {}

class _MockUpdateProfile extends Mock implements UpdateProfile {}

class _MockUploadAvatar extends Mock implements UploadAvatar {}

class _MockResubmitVerification extends Mock implements ResubmitVerification {}

class _MockAvatarPicker extends Mock implements AvatarPicker {}

const _branches = [jakarta, Branch(id: 2, name: 'Bandung')];

final _fields = ProfileFields(
  name: 'Rina Anggraini',
  phone: '+62 812 3456 7890',
  dateOfBirth: DateTime(2000, 3, 14),
  gender: Gender.female,
  branchId: 1,
  address: 'Jl. Tebet Raya 21, Tebet, Jakarta Selatan',
);

void main() {
  late _MockGetBranches getBranches;
  late _MockUpdateProfile updateProfile;
  late _MockUploadAvatar uploadAvatar;
  late _MockResubmitVerification resubmitVerification;
  late _MockAvatarPicker avatarPicker;
  late AuthHarness auth;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(_fields);
    registerFallbackValue(const UploadAvatarParams(filePath: ''));
  });

  setUp(() {
    getBranches = _MockGetBranches();
    updateProfile = _MockUpdateProfile();
    uploadAvatar = _MockUploadAvatar();
    resubmitVerification = _MockResubmitVerification();
    avatarPicker = _MockAvatarPicker();
    when(() => getBranches(any()))
        .thenAnswer((_) async => const Result.success(_branches));
  });

  tearDown(() => auth.dispose());

  EditProfileCubit build({User? user}) {
    auth = AuthHarness(user ?? approvedUser);
    return EditProfileCubit(
      getBranches: getBranches,
      updateProfile: updateProfile,
      uploadAvatar: uploadAvatar,
      resubmitVerification: resubmitVerification,
      avatarPicker: avatarPicker,
      auth: auth.cubit,
    );
  }

  group('load', () {
    blocTest<EditProfileCubit, EditProfileState>(
      'loading → ready with the branches',
      build: build,
      act: (cubit) => cubit.load(),
      expect: () => const [
        EditProfileState.loading(),
        EditProfileState.ready(branches: _branches),
      ],
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'loading → error with the server message',
      setUp: () => when(() => getBranches(any())).thenAnswer(
        (_) async => const Result.failed('Can\'t reach the server.'),
      ),
      build: build,
      act: (cubit) => cubit.load(),
      expect: () => const [
        EditProfileState.loading(),
        EditProfileState.error('Can\'t reach the server.'),
      ],
    );
  });

  group('save (approved user)', () {
    final updated = approvedUser.copyWith(name: 'Rina Putri');

    blocTest<EditProfileCubit, EditProfileState>(
      'success → AuthCubit.updateUser, saved; no resubmit',
      setUp: () =>
          when(() => updateProfile(any()))
              .thenAnswer((_) async => Result.success(updated)),
      build: build,
      seed: () => const EditProfileState.ready(branches: _branches),
      act: (cubit) => cubit.save(_fields),
      expect: () => const [
        EditProfileState.ready(branches: _branches, saving: true),
        EditProfileState.saved(),
      ],
      verify: (cubit) {
        expect(auth.cubit.user, updated);
        verifyNever(() => resubmitVerification(any()));
      },
    );

    blocTest<EditProfileCubit, EditProfileState>(
      '422 → failure with fieldErrors, user untouched',
      setUp: () => when(() => updateProfile(any())).thenAnswer(
        (_) async => const Result.failed(
          'The given data was invalid.',
          statusCode: 422,
          fieldErrors: {
            'phone': ['The phone format is invalid.'],
          },
        ),
      ),
      build: build,
      seed: () => const EditProfileState.ready(branches: _branches),
      act: (cubit) => cubit.save(_fields),
      expect: () => const [
        EditProfileState.ready(branches: _branches, saving: true),
        EditProfileState.failure(
          branches: _branches,
          message: 'The given data was invalid.',
          fieldErrors: {
            'phone': ['The phone format is invalid.'],
          },
        ),
      ],
      verify: (_) => expect(auth.cubit.user, approvedUser),
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'ignored while already saving',
      build: build,
      seed: () =>
          const EditProfileState.ready(branches: _branches, saving: true),
      act: (cubit) => cubit.save(_fields),
      expect: () => const <EditProfileState>[],
      verify: (_) => verifyNever(() => updateProfile(any())),
    );
  });

  group('save (rejected user) — "Submit again"', () {
    final updatedRejected = rejectedUser.copyWith(name: 'Rina Putri');
    final resubmitted = updatedRejected.copyWith(
      verificationStatus: VerificationStatus.pending,
      verificationNote: null,
      reviewedAt: null,
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'resubmits is true for a rejected user',
      build: () => build(user: rejectedUser),
      verify: (cubit) => expect(cubit.resubmits, isTrue),
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'update then resubmit → user is pending, saved(resubmitted)',
      setUp: () {
        when(() => updateProfile(any()))
            .thenAnswer((_) async => Result.success(updatedRejected));
        when(() => resubmitVerification(any()))
            .thenAnswer((_) async => Result.success(resubmitted));
      },
      build: () => build(user: rejectedUser),
      seed: () => const EditProfileState.ready(branches: _branches),
      act: (cubit) => cubit.save(_fields),
      expect: () => const [
        EditProfileState.ready(branches: _branches, saving: true),
        EditProfileState.saved(resubmitted: true),
      ],
      verify: (_) {
        verifyInOrder([
          () => updateProfile(any()),
          () => resubmitVerification(any()),
        ]);
        expect(auth.cubit.user, resubmitted);
        expect(auth.cubit.user?.verificationStatus, VerificationStatus.pending);
      },
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'resubmit fails → profile still saved, failure toast',
      setUp: () {
        when(() => updateProfile(any()))
            .thenAnswer((_) async => Result.success(updatedRejected));
        when(() => resubmitVerification(any())).thenAnswer(
          (_) async => const Result.failed(
            'Only a rejected profile can be submitted again.',
            statusCode: 422,
            code: 'not_rejected',
          ),
        );
      },
      build: () => build(user: rejectedUser),
      seed: () => const EditProfileState.ready(branches: _branches),
      act: (cubit) => cubit.save(_fields),
      expect: () => const [
        EditProfileState.ready(branches: _branches, saving: true),
        EditProfileState.failure(
          branches: _branches,
          message: 'Only a rejected profile can be submitted again.',
        ),
      ],
      verify: (_) => expect(auth.cubit.user, updatedRejected),
    );
  });

  group('changePhoto', () {
    blocTest<EditProfileCubit, EditProfileState>(
      'cancelled picker → nothing happens',
      setUp: () =>
          when(() => avatarPicker.pick()).thenAnswer((_) async => null),
      build: build,
      seed: () => const EditProfileState.ready(branches: _branches),
      act: (cubit) => cubit.changePhoto(),
      expect: () => const <EditProfileState>[],
      verify: (_) => verifyNever(() => uploadAvatar(any())),
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'upload success → avatar_url patched on the user',
      setUp: () {
        when(() => avatarPicker.pick()).thenAnswer((_) async => '/tmp/a.jpg');
        when(() => uploadAvatar(any()))
            .thenAnswer((_) async => const Result.success('https://cdn/a.jpg'));
      },
      build: build,
      seed: () => const EditProfileState.ready(branches: _branches),
      act: (cubit) => cubit.changePhoto(),
      expect: () => const [
        EditProfileState.ready(branches: _branches, uploadingAvatar: true),
        EditProfileState.ready(branches: _branches),
      ],
      verify: (_) {
        final params =
            verify(() => uploadAvatar(captureAny())).captured.single
                as UploadAvatarParams;
        expect(params.filePath, '/tmp/a.jpg');
        expect(auth.cubit.user?.avatarUrl, 'https://cdn/a.jpg');
      },
    );

    blocTest<EditProfileCubit, EditProfileState>(
      'upload failure → failure with the server message',
      setUp: () {
        when(() => avatarPicker.pick()).thenAnswer((_) async => '/tmp/a.jpg');
        when(() => uploadAvatar(any())).thenAnswer(
          (_) async =>
              const Result.failed('The avatar may not be greater than 5 MB.'),
        );
      },
      build: build,
      seed: () => const EditProfileState.ready(branches: _branches),
      act: (cubit) => cubit.changePhoto(),
      expect: () => const [
        EditProfileState.ready(branches: _branches, uploadingAvatar: true),
        EditProfileState.failure(
          branches: _branches,
          message: 'The avatar may not be greater than 5 MB.',
        ),
      ],
      verify: (_) => expect(auth.cubit.user?.avatarUrl, isNull),
    );
  });
}
