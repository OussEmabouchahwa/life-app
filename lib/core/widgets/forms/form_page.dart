import 'package:flutter/material.dart';

import '../../theme/app_icons.dart';
import '../app_button.dart';
import '../app_page.dart';
import '../icon_box_button.dart';
import '../screen_header.dart';
import 'confirm_dialog.dart';

/// Scaffold shared by every add / edit form: header with back (and delete
/// when editing), the fields, and a pinned Save button.
class FormPage extends StatelessWidget {
  const FormPage({
    super.key,
    required this.title,
    required this.children,
    required this.onSave,
    this.eyebrow,
    this.saveLabel = 'Save',
    this.canSave = true,
    this.onDelete,
    this.deleteWhat = 'this item',
  });

  final String title;
  final String? eyebrow;
  final List<Widget> children;

  /// Saves the form. The page closes itself afterwards.
  final VoidCallback onSave;
  final String saveLabel;
  final bool canSave;

  /// Shown only when editing an existing record.
  final VoidCallback? onDelete;
  final String deleteWhat;

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    return AppPage(
      bottom: AppButton(
        label: saveLabel,
        icon: AppIcons.check,
        onPressed: canSave
            ? () {
                onSave();
                nav.pop();
              }
            : null,
      ),
      children: [
        ScreenHeader(
          title: title,
          eyebrow: eyebrow,
          showBack: true,
          trailing: onDelete == null
              ? null
              : IconBoxButton(
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Delete',
                  onPressed: () async {
                    if (await confirmDelete(context, deleteWhat)) {
                      onDelete!();
                      nav.pop();
                    }
                  },
                ),
        ),
        ...children,
      ],
    );
  }
}
