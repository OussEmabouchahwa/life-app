import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/training_models.dart';

/// Set 1 · 60 kg × 8 ✓ … current set marked NOW, later sets show the target.
class LoggedSetsList extends StatelessWidget {
  const LoggedSetsList({super.key, required this.exercise, required this.logged});

  final Exercise exercise;
  final List<LoggedSet> logged;

  @override
  Widget build(BuildContext context) {
    final target = '${formatKg(exercise.weightKg)} kg × ${exercise.reps}';
    return AppCard(
      padding: 0,
      child: DividedColumn(
        children: [
          for (var i = 0; i < exercise.sets; i++)
            AppTile(
              title: 'Set ${i + 1}',
              subtitle: i < logged.length
                  ? '${formatKg(logged[i].weightKg)} kg × ${logged[i].reps}'
                  : i == logged.length
                  ? '$target · now'
                  : 'Target $target',
              inlineSubtitle: true,
              trailing: i == logged.length ? const NowBadge() : CheckCircle(checked: i < logged.length),
            ),
        ],
      ),
    );
  }
}
