import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// WEIGHT / 60 kg / [-] [+]
class ValueStepper extends StatelessWidget {
  const ValueStepper({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final String value;
  final String unit;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) => Container(
    padding: context.padSym(v: 12),
    decoration: BoxDecoration(
      color: context.colors.bgSunken,
      borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
    ),
    child: Column(
      children: [
        Eyebrow(label),
        const VGap(6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: ValueWithUnit(value: value, unit: unit, style: context.text.hero),
        ),
        const VGap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconBoxButton(icon: AppIcons.minus, size: 38, onPressed: onMinus, tooltip: 'Less'),
            const HGap(10),
            IconBoxButton(icon: AppIcons.plus, size: 38, onPressed: onPlus, tooltip: 'More'),
          ],
        ),
      ],
    ),
  );
}
