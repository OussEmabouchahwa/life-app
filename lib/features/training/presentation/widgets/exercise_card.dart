import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/training_models.dart';

/// Exercise with its set bubbles, planned weight and the last time it was done.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key, required this.exercise, this.lastBest});

  final Exercise exercise;

  /// Heaviest set from the last session with this exercise, if any.
  final LoggedSet? lastBest;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final last = lastBest;
    final delta = last == null ? null : exercise.weightKg - last.weightKg;
    final note = switch (delta) {
      null => 'Not done yet',
      > 0 => '+${formatKg(delta)} vs last time',
      < 0 => '${formatKg(delta)} vs last time',
      _ => 'Same as last time',
    };

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
          // At most 30 % of the screen; the note wraps instead of squeezing the sets.
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.wp(0.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: exercise.weightKg == 0
                      ? Text('Body', style: context.text.timeLarge)
                      : ValueWithUnit(value: formatKg(exercise.weightKg), unit: 'kg'),
                ),
                Text(
                  note,
                  textAlign: TextAlign.end,
                  style: context.text.caption.tint((delta ?? 0) > 0 ? c.brand : c.textSecondary).bold,
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
