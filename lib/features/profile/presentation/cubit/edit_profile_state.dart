import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/models/branch.dart';

part 'edit_profile_state.freezed.dart';

/// E2. The form's text lives in the screen's controllers; the cubit owns the
/// branch list, the busy flags and the outcome of the last save/upload.
@freezed
sealed class EditProfileState with _$EditProfileState {
  const EditProfileState._();

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

  /// Save, resubmit or upload failed. The form stays usable; [fieldErrors]
  /// (422) go to the fields, otherwise the screen toasts [message].
  const factory EditProfileState.failure({
    required List<Branch> branches,
    required String message,
    @Default({}) Map<String, List<String>> fieldErrors,
  }) = EditProfileFailure;

  /// Profile saved and `AuthCubit` updated — the screen pops. When
  /// [resubmitted] the profile also went back to admin review (A7 → A6).
  const factory EditProfileState.saved({@Default(false) bool resubmitted}) =
      EditProfileSaved;

  /// Branch options once loaded; empty while loading or after a load error.
  List<Branch> get branches => switch (this) {
    EditProfileReady(:final branches) => branches,
    EditProfileFailure(:final branches) => branches,
    _ => const [],
  };

  Map<String, List<String>> get fieldErrors => switch (this) {
    EditProfileFailure(:final fieldErrors) => fieldErrors,
    _ => const {},
  };

  bool get saving =>
      this is EditProfileReady && (this as EditProfileReady).saving;

  bool get uploadingAvatar =>
      this is EditProfileReady && (this as EditProfileReady).uploadingAvatar;
}
