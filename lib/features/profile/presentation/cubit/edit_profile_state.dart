import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/models/branch.dart';

part 'edit_profile_state.freezed.dart';

/// E2. The form's text lives in the screen's controllers; the cubit owns the
/// branch list, the busy flags and the outcome of the last save/upload.
@freezed
sealed class EditProfileState with _$EditProfileState {
  /// `GET /branches` in flight — the form is not shown yet.
  const factory EditProfileState.loading() = EditProfileLoading;

  /// Branches could not be loaded; the screen offers a retry.
  const factory EditProfileState.error(String message) = EditProfileError;

  /// Form shown. [saving] / [uploadingAvatar] drive the busy buttons.
  const factory EditProfileState.ready({
    required List<Branch> branches,
    @Default(false) bool saving,
    @Default(false) bool uploadingAvatar,
  }) = EditProfileReady;

  /// Save or upload failed. The form stays usable; [fieldErrors] (422) go to
  /// the fields, otherwise the screen toasts [message].
  const factory EditProfileState.failure({
    required List<Branch> branches,
    required String message,
    @Default({}) Map<String, List<String>> fieldErrors,
  }) = EditProfileFailure;

  /// Profile saved and `AuthCubit` updated — the screen toasts and pops.
  const factory EditProfileState.saved() = EditProfileSaved;
}
