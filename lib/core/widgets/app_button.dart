import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';

enum AppButtonVariant {
  /// Brass: the one main action of a screen.
  primary,

  /// Bottle green.
  brand,

  /// Ivory with a hairline border.
  outlined,
}

/// Full-width 52 px button with an optional leading icon.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.height = AppSizes.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  /// Height in Figma px.
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg, border) = switch (variant) {
      AppButtonVariant.primary => (c.accent, c.onAccent, c.accent),
      AppButtonVariant.brand => (c.brand, c.onBrand, c.brand),
      AppButtonVariant.outlined => (c.bgCard, c.textPrimary, c.line),
    };
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
      side: BorderSide(color: border),
    );

    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: Material(
        color: bg,
        shape: shape,
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: SizedBox(
            height: context.dp(height),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: fg, size: context.dp(18)),
                  SizedBox(width: context.dp(8)),
                ],
                Flexible(
                  child: Text(label, style: context.text.button.tint(fg), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
