import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import '../../theme/theme_context.dart';

/// "Delete this exam?" with Cancel / Delete. Returns true when confirmed.
Future<bool> confirmDelete(BuildContext context, String what) async {
  final c = context.colors;
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      backgroundColor: c.bgCard,
      title: Text('Delete $what?', style: context.text.title),
      content: Text("This can't be undone.", style: context.text.body.tint(c.textSecondary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialog, false),
          child: Text('Cancel', style: context.text.body.tint(c.textSecondary)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialog, true),
          child: Text('Delete', style: context.text.body.tint(c.danger).bold),
        ),
      ],
    ),
  );
  return ok ?? false;
}
