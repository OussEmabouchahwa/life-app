import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';

/// Small markers that sit at the end of list rows.

/// 3 px coloured bar that marks the category of an event.
class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key, required this.color, this.height = 32});

  final Color color;

  /// Height in Figma px.
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    width: context.dp(AppSizes.categoryBar),
    height: context.dp(height),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(context.dp(2))),
  );
}

/// Round 24 px tick: filled green when done, hairline circle otherwise.
class CheckCircle extends StatelessWidget {
  const CheckCircle({super.key, required this.checked, this.onTap});

  final bool checked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = context.dp(AppSizes.checkCircle);
    return Semantics(
      checked: checked,
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: checked ? c.brand : Colors.transparent,
            border: Border.all(color: checked ? c.brand : c.line, width: 1.5),
          ),
          child: checked ? Icon(AppIcons.check, size: size * 0.6, color: c.onBrand) : null,
        ),
      ),
    );
  }
}

/// Brass "NOW" pill. Brass is reserved for this marker and the main action.
class NowBadge extends StatelessWidget {
  const NowBadge({super.key, this.label = 'NOW'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: context.padSym(h: 9, v: 3),
      decoration: BoxDecoration(
        color: c.accent,
        borderRadius: BorderRadius.circular(context.dp(AppRadius.pill)),
      ),
      child: Text(label, style: context.text.eyebrow.tint(c.onAccent)),
    );
  }
}

/// Soft tag ("in 5 days", "BEHIND", "4 wk streak").
class SoftTag extends StatelessWidget {
  const SoftTag({super.key, required this.label, this.icon, this.warning = false});

  final String label;
  final IconData? icon;

  /// Uses the danger colour instead of the brand colour.
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = warning ? c.danger : c.brand;
    final bg = warning ? c.danger.withValues(alpha: 0.12) : c.brandSoft;
    return Container(
      padding: context.padSym(h: 9, v: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(context.dp(AppRadius.pill))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: context.dp(14), color: fg), SizedBox(width: context.dp(4))],
          Text(label, style: context.text.caption.tint(fg).bold),
        ],
      ),
    );
  }
}
