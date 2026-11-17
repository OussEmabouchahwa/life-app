import 'package:flutter/material.dart';

import '../../responsive/responsive.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_context.dart';
import '../icon_box_button.dart';

/// "Sets   [-]  4  [+]" for small whole numbers.
class StepperField extends StatelessWidget {
  const StepperField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.unit,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: context.padSym(h: 14, v: 8),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: context.text.body.tint(c.textSecondary))),
          IconBoxButton(
            icon: AppIcons.minus,
            size: 34,
            tooltip: 'Less',
            onPressed: value - step >= min ? () => onChanged(value - step) : null,
          ),
          SizedBox(
            width: context.dp(64),
            child: Text(
              unit == null ? '$value' : '$value $unit',
              textAlign: TextAlign.center,
              style: context.text.bodyStrong,
            ),
          ),
          IconBoxButton(
            icon: AppIcons.plus,
            size: 34,
            tooltip: 'More',
            onPressed: value + step <= max ? () => onChanged(value + step) : null,
          ),
        ],
      ),
    );
  }
}
