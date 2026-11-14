import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/theme_context.dart';

/// 42 × 42 square outlined icon button (settings, add, back).
class IconBoxButton extends StatelessWidget {
  const IconBoxButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = AppSizes.iconButton,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  /// Side length in Figma px.
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final side = context.dp(size);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
      side: BorderSide(color: c.line),
    );
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: c.bgCard,
        shape: shape,
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: SizedBox.square(
            dimension: side,
            child: Icon(icon, size: side * 0.47, color: c.textPrimary),
          ),
        ),
      ),
    );
  }
}
