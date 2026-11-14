import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/food_models.dart';

/// Chosen food with a gram stepper and its macros for that amount.
class SelectedFoodCard extends StatelessWidget {
  const SelectedFoodCard({
    super.key,
    required this.food,
    required this.grams,
    required this.onMinus,
    required this.onPlus,
  });

  final Food food;
  final double grams;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final m = food.forGrams(grams);
    final macros = [
      ('${m.kcal.round()}', 'Calories'),
      ('${m.protein.round()} g', 'Protein'),
      ('${m.carbs.round()} g', 'Carbs'),
      ('${m.fat.round()} g', 'Fat'),
    ];
    return AppCard(
      padding: 15,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food.name, style: context.text.bodyStrong),
                    Text(
                      'Per 100 g · ${food.per100g.kcal.round()} kcal',
                      style: context.text.bodySmall.tint(c.textSecondary),
                    ),
                  ],
                ),
              ),
              IconBoxButton(icon: AppIcons.minus, size: 34, onPressed: onMinus, tooltip: 'Less'),
              SizedBox(
                width: context.dp(56),
                child: Center(
                  child: ValueWithUnit(value: '${grams.round()}', unit: 'g', style: context.text.title),
                ),
              ),
              IconBoxButton(icon: AppIcons.plus, size: 34, onPressed: onPlus, tooltip: 'More'),
            ],
          ),
          const VGap(14),
          const Divider(),
          const VGap(12),
          Row(
            children: [
              for (final (value, label) in macros)
                Expanded(
                  child: Column(
                    children: [
                      Text(value, style: context.text.title),
                      Eyebrow(label),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
