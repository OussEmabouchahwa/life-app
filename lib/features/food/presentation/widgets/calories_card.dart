import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/food_models.dart';
import 'calorie_ring.dart';

/// Ring on the left, kcal left and macro bars on the right.
class CaloriesCard extends StatelessWidget {
  const CaloriesCard({super.key, required this.eaten, required this.goal});

  final Macros eaten;
  final Macros goal;

  @override
  Widget build(BuildContext context) {
    final left = (goal.kcal - eaten.kcal).round();
    final macros = [
      ('Protein', eaten.protein, goal.protein),
      ('Carbs', eaten.carbs, goal.carbs),
      ('Fat', eaten.fat, goal.fat),
    ];
    return AppCard(
      padding: 17,
      child: Row(
        children: [
          CalorieRing(eaten: eaten.kcal, goal: goal.kcal),
          const HGap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(left >= 0 ? '$left kcal left' : '${-left} kcal over', style: context.text.title),
                for (final (label, value, target) in macros) ...[
                  const VGap(10),
                  _MacroBar(label: label, value: value, target: target),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({required this.label, required this.value, required this.target});

  final String label;
  final double value;
  final double target;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: context.text.bodySmall)),
            Text(
              '${value.round()} / ${target.round()} g',
              style: context.text.bodySmall.tint(c.textSecondary),
            ),
          ],
        ),
        const VGap(4),
        AppProgressBar(value: target == 0 ? 0 : value / target),
      ],
    );
  }
}
