import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';

/// Generic row inside a list card: title, optional subtitle, optional
/// leading/trailing widgets. Used by settings, onboarding, recent foods…
class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.inlineSubtitle = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Shows the subtitle next to the title ("English  Default") instead of under it.
  final bool inlineSubtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sub = subtitle == null
        ? null
        : Text(subtitle!, style: context.text.bodySmall.tint(c.textSecondary));
    final titleText = Text(title, style: context.text.bodyStrong);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: context.padSym(h: 14, v: 12),
        child: Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: context.dp(12))],
            Expanded(
              child: inlineSubtitle || sub == null
                  ? Row(
                      children: [
                        Flexible(child: titleText),
                        if (sub != null) ...[SizedBox(width: context.dp(8)), sub],
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleText,
                        SizedBox(height: context.dp(2)),
                        sub,
                      ],
                    ),
            ),
            if (trailing != null) ...[SizedBox(width: context.dp(8)), trailing!],
          ],
        ),
      ),
    );
  }
}

/// "Calculation method ...... Tunisia ›"
class ValueTile extends StatelessWidget {
  const ValueTile({super.key, required this.title, required this.value, this.onTap});

  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppTile(
      title: title,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: context.text.body.tint(c.textSecondary)),
          Icon(AppIcons.chevron, size: context.dp(18), color: c.textSecondary),
        ],
      ),
    );
  }
}
