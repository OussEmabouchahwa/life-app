import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';
import 'gaps.dart';

/// "Today's plan ............ Full plan →" with a divider underneath.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: Text(title, style: context.text.title)),
            if (action != null)
              GestureDetector(
                onTap: onAction,
                behavior: HitTestBehavior.opaque,
                child: Text(action!, style: context.text.bodySmall.tint(c.textSecondary).bold),
              ),
          ],
        ),
        const VGap(8),
        const Divider(),
      ],
    );
  }
}
