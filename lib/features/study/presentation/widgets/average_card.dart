import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// WEIGHTED AVERAGE 13.6 / 20 with the trend vs last term.
class AverageCard extends StatelessWidget {
  const AverageCard({super.key, required this.average, required this.lastTerm});

  final double average;
  final double lastTerm;

  @override
  Widget build(BuildContext context) {
    final delta = average - lastTerm;
    final sign = delta >= 0 ? '+' : '';
    return AppCard(
      padding: 17,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Weighted average'),
                ValueWithUnit(value: average.toStringAsFixed(1), unit: '/ 20', style: context.text.hero),
              ],
            ),
          ),
          SoftTag(
            label: '$sign${delta.toStringAsFixed(1)} vs last term',
            icon: AppIcons.trend,
            warning: delta < 0,
          ),
        ],
      ),
    );
  }
}
