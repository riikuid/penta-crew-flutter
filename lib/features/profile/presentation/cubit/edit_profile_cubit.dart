import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/models/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/repositories/auth_repository.dart' show ProfileFields;
import '../../../auth/usecases/get_branches.dart';
import '../../../auth/usecases/resubmit_verification.dart';
import '../../../auth/usecases/update_profile.dart';
import '../../../auth/usecases/upload_avatar.dart';
import '../../avatar_picker.dart';
import 'edit_profile_state.dart';

/// Page-scoped cubit behind E2. Loads the branch options, saves the profile
/// (contract §2.7) and uploads the avatar (§2.9); every success is pushed to
/// `AuthCubit.updateUser` so E1 / the verification screen rebuild without a
/// round-trip.
///
/// While the user is `rejected`, saving also calls §3.1 ("Submit again"):
/// the profile goes back to `pending` and A7 turns into A6.
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    required this._getBranches,
    required this._updateProfile,
    required this._uploadAvatar,
    required this._resubmitVerification,
    required this._avatarPicker,
    required this._auth,
  }) : super(const EditProfileState.loading());

  final GetBranches _getBranches;
  final UpdateProfile _updateProfile;
  final UploadAvatar _uploadAvatar;
  final ResubmitVerification _resubmitVerification;
  final AvatarPicker _avatarPicker;
  final AuthCubit _auth;

  /// True while the signed-in user is `rejected` — the CTA reads
  /// "Submit again" and [save] resubmits after updating.
  bool get resubmits =>
      _auth.user?.verificationStatus == VerificationStatus.rejected;

  Future<void> load() async {
    emit(const EditProfileState.loading());
    switch (await _getBranches(const NoParams())) {
      case Success(:final value):
        emit(EditProfileState.ready(branches: value));
      case Failed(:final message):
        emit(EditProfileState.error(message));
    }
  }

  Future<void> save(ProfileFields fields) async {
    if (state.saving || state.uploadingAvatar) return;
    final branches = state.branches;
    final resubmit = resubmits;
    emit(EditProfileState.ready(branches: branches, saving: true));

    switch (await _updateProfile(fields)) {
      case Success(:final value):
        _auth.updateUser(value);
        if (!resubmit) {
          emit(const EditProfileState.saved());
          return;
        }
        switch (await _resubmitVerification(const NoParams())) {
          case Success(:final value):
            _auth.updateUser(value);
            emit(const EditProfileState.saved(resubmitted: true));
          case Failed(:final message):
            emit(EditProfileState.failure(branches: branches, message: message));
        }
      case Failed(:final message, :final fieldErrors):
        emit(
          EditProfileState.failure(
            branches: branches,
            message: message,
            fieldErrors: fieldErrors ?? const {},
          ),
        );
    }
  }

  /// "Change photo": pick from the library, upload, patch `avatar_url` on the
  /// signed-in user. Cancelling the picker is a no-op.
  Future<void> changePhoto() async {
    if (state.saving || state.uploadingAvatar) return;
    final branches = state.branches;

    final filePath = await _avatarPicker.pick();
    if (filePath == null || isClosed) return;
    emit(EditProfileState.ready(branches: branches, uploadingAvatar: true));

    switch (await _uploadAvatar(UploadAvatarParams(filePath: filePath))) {
      case Success(:final value):
        final user = _auth.user;
        if (user != null) _auth.updateUser(user.copyWith(avatarUrl: value));
        emit(EditProfileState.ready(branches: branches));
      case Failed(:final message):
        emit(EditProfileState.failure(branches: branches, message: message));
    }
  }
}
