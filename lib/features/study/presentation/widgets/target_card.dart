import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../application/grade_calculator_controller.dart';

/// Target average with a slider and quick presets.
class TargetCard extends StatelessWidget {
  const TargetCard({super.key, required this.target, required this.onChanged});

  final double target;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const min = GradeCalculatorController.minTarget, max = GradeCalculatorController.maxTarget;
    return AppCard(
      padding: 15,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Target average', style: context.text.bodyStrong)),
              ValueWithUnit(value: target.toStringAsFixed(1), unit: '/ 20'),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: c.brand,
              inactiveTrackColor: c.bgSunken,
              thumbColor: c.accent,
              overlayColor: c.accent.withValues(alpha: 0.15),
              trackHeight: context.dp(6),
            ),
            child: Slider(
              value: target.clamp(min, max),
              min: min,
              max: max,
              divisions: ((max - min) * 2).round(),
              onChanged: onChanged,
            ),
          ),
          Row(
            children: [
              for (final p in GradeCalculatorController.presets) ...[
                if (p != GradeCalculatorController.presets.first) const HGap(8),
                Expanded(
                  child: ChoicePill(
                    label: p.toStringAsFixed(0),
                    height: 34,
                    selected: p == target,
                    onTap: () => onChanged(p),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
