import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/grade_math.dart';

/// YOU NEED IN THE EXAM 13.4 / 20 + how realistic it is.
class NeededResultCard extends StatelessWidget {
  const NeededResultCard({super.key, required this.needed});

  /// Null when every mark is already in.
  final double? needed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final value = needed;
    final reach = value == null ? null : Reachability.of(value);
    return AppCard(
      padding: 17,
      color: c.brand,
      borderColor: c.brand,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('You need in the exam', color: c.onBrand.withValues(alpha: 0.7)),
          const VGap(4),
          ValueWithUnit(
            value: value == null ? '—' : value.clamp(0, 99).toStringAsFixed(1),
            unit: '/ 20',
            style: context.text.hero,
            color: c.onBrand,
          ),
          const VGap(4),
          Text(
            reach?.message ?? 'All marks are in for this subject.',
            style: context.text.body.tint(reach == Reachability.impossible ? c.accent : c.onBrand),
          ),
        ],
      ),
    );
  }
}
