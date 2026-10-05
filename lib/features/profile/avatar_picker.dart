import 'package:image_picker/image_picker.dart';

/// Lets the user choose a profile photo and returns its local path, or `null`
/// when they cancel. Abstracted so `EditProfileCubit` can be unit-tested
/// without the `image_picker` plugin.
abstract interface class AvatarPicker {
  Future<String?> pick();
}

/// Photo library via `image_picker`, downscaled so the upload stays well
/// under the contract's 5 MB cap (§2.9; the backend resizes to 512 px anyway).
class ImagePickerAvatarPicker implements AvatarPicker {
  ImagePickerAvatarPicker({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> pick() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    return file?.path;
  }
}
