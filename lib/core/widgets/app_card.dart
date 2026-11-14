import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/theme_context.dart';

/// The ivory bordered card used by almost every block in the design.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.lg,
    this.color,
    this.borderColor,
    this.onTap,
  });

  final Widget child;

  /// Inner padding in Figma px. Use 0 for cards that hold full-width rows.
  final double padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: color ?? c.bgCard,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dp(AppRadius.lg)),
        side: BorderSide(color: borderColor ?? c.line),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: context.padAll(padding), child: child),
      ),
    );
  }
}
