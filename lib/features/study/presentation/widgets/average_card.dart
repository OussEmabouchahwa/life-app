import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// WEIGHTED AVERAGE 13.6 / 20, with how many subjects it is based on.
class AverageCard extends StatelessWidget {
  const AverageCard({super.key, required this.average, required this.graded, required this.total});

  final double average;
  final int graded;
  final int total;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: 17,
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Weighted average'),
              ValueWithUnit(value: average.toStringAsFixed(2), unit: '/ 20', style: context.text.hero),
            ],
          ),
        ),
        SoftTag(label: '$graded / $total graded', warning: average < 10),
      ],
    ),
  );
}
