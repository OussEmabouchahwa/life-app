import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/ui.dart';
import '../../application/profile_photo_controller.dart';
import '../../application/settings_controller.dart';

/// Round profile photo. Shows the initial when there is no photo; a small
/// camera badge says it can be tapped to change it.
class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key, this.size = 52, this.onTap});

  /// Diameter in Figma px.
  final double size;

  /// Defaults to the photo sheet (gallery / camera / remove).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final photo = ref.watch(profilePhotoProvider);
    final name = ref.watch(settingsProvider.select((s) => s.userName));
    final d = context.dp(size);

    return Semantics(
      button: true,
      label: 'Profile photo',
      child: GestureDetector(
        onTap: onTap ?? () => showProfilePhotoSheet(context, ref),
        child: SizedBox.square(
          dimension: d,
          child: Stack(
            children: [
              Container(
                width: d,
                height: d,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.brand,
                  border: Border.all(color: c.accent, width: 2),
                ),
                alignment: Alignment.center,
                child: photo != null
                    ? Image.memory(photo, width: d, height: d, fit: BoxFit.cover, gaplessPlayback: true)
                    : Text(
                        name.isEmpty ? '?' : name.characters.first.toUpperCase(),
                        style: context.text.headline.tint(c.onBrand),
                      ),
              ),
              PositionedDirectional(
                end: 0,
                bottom: 0,
                child: Container(
                  width: d * 0.36,
                  height: d * 0.36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.accent,
                    border: Border.all(color: c.bgBase, width: 2),
                  ),
                  child: Icon(Icons.photo_camera_rounded, size: d * 0.2, color: c.onAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gallery / camera / remove.
Future<void> showProfilePhotoSheet(BuildContext context, WidgetRef ref) async {
  final ctrl = ref.read(profilePhotoProvider.notifier);
  final hasPhoto = ref.read(profilePhotoProvider) != null;
  final c = context.colors;
  final action = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    backgroundColor: c.bgCard,
    builder: (sheet) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTile(
            title: 'Choose from gallery',
            leading: Icon(Icons.photo_library_outlined, color: c.textPrimary),
            onTap: () => Navigator.pop(sheet, 'gallery'),
          ),
          AppTile(
            title: 'Take a photo',
            leading: Icon(Icons.photo_camera_outlined, color: c.textPrimary),
            onTap: () => Navigator.pop(sheet, 'camera'),
          ),
          if (hasPhoto)
            AppTile(
              title: 'Remove photo',
              leading: Icon(Icons.delete_outline_rounded, color: c.danger),
              onTap: () => Navigator.pop(sheet, 'remove'),
            ),
        ],
      ),
    ),
  );
  switch (action) {
    case 'gallery':
      await ctrl.pick(ImageSource.gallery);
    case 'camera':
      await ctrl.pick(ImageSource.camera);
    case 'remove':
      await ctrl.remove();
  }
}
