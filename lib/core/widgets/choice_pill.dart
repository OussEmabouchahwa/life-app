import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';

/// Selectable pill: meal types, event categories, coach times, presets.
class ChoicePill extends StatelessWidget {
  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.height = 36,
    this.dense = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  /// Height in Figma px.
  final double height;

  /// Smaller text and padding (coach chips).
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.onBrand : c.textPrimary;
    final style = (dense ? context.text.bodySmall : context.text.body).tint(fg).bold;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        height: context.dp(height),
        padding: context.padSym(h: dense ? 10 : 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? c.brand : c.bgCard,
          borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
          border: Border.all(color: selected ? c.brand : c.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: context.dp(15), color: fg),
              SizedBox(width: context.dp(6)),
            ],
            Flexible(
              child: Text(label, style: style, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

/// A row of pills that share the width equally (Figma "Widget choice" rows).
class ChoicePillRow<T> extends StatelessWidget {
  const ChoicePillRow({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.spacing = 8,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  /// Gap between pills in Figma px.
  final double spacing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < values.length; i++) ...[
        if (i > 0) SizedBox(width: context.dp(spacing)),
        Expanded(
          child: ChoicePill(
            label: labelOf(values[i]),
            selected: values[i] == selected,
            onTap: () => onChanged(values[i]),
          ),
        ),
      ],
    ],
  );
}
