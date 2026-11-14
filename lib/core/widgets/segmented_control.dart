import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';

/// Sunken track with a raised ivory segment for the selected value
/// ("Tunis · Dar / Bir Ali", "System / Light / Dark", food mode).
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.iconOf,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final IconData? Function(T value)? iconOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = context.dp(AppRadius.md);
    return Container(
      padding: context.padAll(3),
      decoration: BoxDecoration(color: c.bgSunken, borderRadius: BorderRadius.circular(radius)),
      child: Row(
        children: [
          for (final v in values)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(v),
                child: AnimatedContainer(
                  duration: AppDurations.normal,
                  height: context.dp(36),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: v == selected ? c.bgCard : Colors.transparent,
                    borderRadius: BorderRadius.circular(radius - 2),
                    border: Border.all(color: v == selected ? c.line : Colors.transparent),
                  ),
                  child: _SegmentLabel(label: labelOf(v), icon: iconOf?.call(v), selected: v == selected),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel({required this.label, required this.icon, required this.selected});

  final String label;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.textPrimary : c.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: context.dp(15), color: color), SizedBox(width: context.dp(6))],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: context.text.body
                .tint(color)
                .copyWith(fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
