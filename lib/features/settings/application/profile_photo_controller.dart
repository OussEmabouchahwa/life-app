import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/storage/local_store.dart';

/// The user's profile photo, kept on the phone only.
///
/// Stored as a small JPEG (max 512 px) in local storage, so it works the same
/// on Android, iOS and the web preview, and survives app updates.
final profilePhotoProvider = NotifierProvider<ProfilePhotoController, Uint8List?>(ProfilePhotoController.new);

class ProfilePhotoController extends Notifier<Uint8List?> {
  static const _key = 'profile_photo_v1';
  static const _maxSide = 512.0;

  @override
  Uint8List? build() {
    final saved = ref.watch(sharedPreferencesProvider).getString(_key);
    return saved == null ? null : base64Decode(saved);
  }

  /// Opens the gallery or the camera. Returns false when nothing was chosen.
  Future<bool> pick(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: _maxSide,
      maxHeight: _maxSide,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.front,
    );
    if (file == null) return false;
    final bytes = await file.readAsBytes();
    state = bytes;
    await ref.read(sharedPreferencesProvider).setString(_key, base64Encode(bytes));
    return true;
  }

  Future<void> remove() async {
    state = null;
    await ref.read(sharedPreferencesProvider).remove(_key);
  }
}
