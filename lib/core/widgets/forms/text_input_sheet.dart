import 'package:flutter/material.dart';

import '../../responsive/responsive.dart';
import '../../theme/theme_context.dart';
import '../app_button.dart';
import 'app_text_field.dart';

/// Small sheet to edit one text value. Returns null when dismissed.
Future<String?> showTextInputSheet({
  required BuildContext context,
  required String title,
  String initialValue = '',
  String? hint,
}) {
  var value = initialValue;
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.colors.bgCard,
    builder: (sheet) => Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        context.dp(22),
        0,
        context.dp(22),
        MediaQuery.viewInsetsOf(sheet).bottom + context.dp(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            label: title,
            hint: hint,
            initialValue: initialValue,
            autofocus: true,
            onChanged: (v) => value = v,
          ),
          SizedBox(height: context.dp(12)),
          AppButton(label: 'Save', onPressed: () => Navigator.pop(sheet, value.trim())),
        ],
      ),
    ),
  );
}
