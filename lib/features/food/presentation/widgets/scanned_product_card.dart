import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/food_models.dart';

/// Product found by the scanner, with its values per 100 g.
class ScannedProductCard extends StatelessWidget {
  const ScannedProductCard({super.key, required this.food});

  final Food food;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final m = food.per100g;
    final values = [
      ('${m.kcal.round()}', 'kcal'),
      ('${m.protein.toStringAsFixed(1)} g', 'Protein'),
      ('${m.carbs.toStringAsFixed(1)} g', 'Carbs'),
      ('${m.fat.toStringAsFixed(1)} g', 'Fat'),
    ];
    return AppCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(food.name, style: context.text.bodyStrong),
          Text(
            food.portionLabel == null ? 'Per 100 g' : 'Per 100 g · portion ${food.portionLabel}',
            style: context.text.bodySmall.tint(c.textSecondary),
          ),
          const VGap(12),
          const Divider(),
          const VGap(12),
          Row(
            children: [
              for (final (value, label) in values)
                Expanded(
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(value, style: context.text.title),
                      ),
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
