import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';

/// Labelled value box ("Date  Mon 26", "Starts  15:00").
class FieldBox extends StatelessWidget {
  const FieldBox({super.key, required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
        side: BorderSide(color: c.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: context.padSym(h: 14, v: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.text.caption.tint(c.textSecondary)),
              SizedBox(height: context.dp(4)),
              Text(value, style: context.text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
