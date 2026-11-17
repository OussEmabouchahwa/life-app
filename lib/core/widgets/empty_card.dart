import 'package:flutter/material.dart';

import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'gaps.dart';

/// Shown where a list has nothing yet: what goes here and how to add it.
class EmptyCard extends StatelessWidget {
  const EmptyCard({super.key, required this.title, required this.message, this.actionLabel, this.onAction});

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: 18,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: context.text.title),
        const VGap(4),
        Text(message, style: context.text.body.tint(context.colors.textSecondary)),
        if (actionLabel != null) ...[
          const VGap(14),
          AppButton(label: actionLabel!, icon: AppIcons.plus, onPressed: onAction),
        ],
      ],
    ),
  );
}
