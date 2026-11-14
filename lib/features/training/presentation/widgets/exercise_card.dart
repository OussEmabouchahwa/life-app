import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/training_models.dart';

/// Exercise with its set bubbles and weight vs last week.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key, required this.exercise});

  final Exercise exercise;

  String get _delta => switch (exercise.deltaKg) {
    > 0 => '+${formatKg(exercise.deltaKg)} vs last week',
    < 0 => '${formatKg(exercise.deltaKg)} vs last week',
    _ => 'Same as last week',
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 15,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.name, style: context.text.bodyStrong),
                Text(
                  '${exercise.sets} sets × ${exercise.reps} reps',
                  style: context.text.bodySmall.tint(c.textSecondary),
                ),
                const VGap(8),
                Wrap(
                  spacing: context.dp(6),
                  runSpacing: context.dp(6),
                  children: [for (var i = 0; i < exercise.sets; i++) _SetBubble(reps: exercise.reps)],
                ),
              ],
            ),
          ),
          const HGap(8),
          // At most 30 % of the screen; the delta wraps instead of squeezing the sets.
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.wp(0.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ValueWithUnit(value: formatKg(exercise.weightKg), unit: 'kg'),
                ),
                Text(
                  _delta,
                  textAlign: TextAlign.end,
                  style: context.text.caption.tint(exercise.deltaKg > 0 ? c.brand : c.textSecondary).bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetBubble extends StatelessWidget {
  const _SetBubble({required this.reps});

  final int reps;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: context.dp(30),
      height: context.dp(30),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c.brandSoft, shape: BoxShape.circle),
      child: Text('$reps', style: context.text.caption.bold.tint(c.brand)),
    );
  }
}
