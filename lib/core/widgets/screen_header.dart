import 'package:flutter/material.dart';

import '../theme/app_icons.dart';
import '../theme/theme_context.dart';
import 'eyebrow.dart';
import 'gaps.dart';
import 'icon_box_button.dart';

/// Page header: optional back button, eyebrow + title, optional trailing
/// action and the hairline under it. Pushed screens (with back) use the
/// smaller title, as in the design.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.eyebrow, this.trailing, this.showBack = false});

  final String title;
  final String? eyebrow;
  final Widget? trailing;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final titleStyle = showBack ? context.text.headline : context.text.display;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (showBack) ...[
              IconBoxButton(
                icon: AppIcons.back,
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const HGap(12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (eyebrow != null) ...[Eyebrow(eyebrow!), const VGap(3)],
                  Text(title, style: titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (trailing != null) ...[const HGap(12), trailing!],
          ],
        ),
        const VGap(14),
        const Divider(),
      ],
    );
  }
}
