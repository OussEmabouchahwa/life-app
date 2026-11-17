import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/training_models.dart';
import 'exercise_card.dart';

/// Shows the first exercises and a "+2 more" row that expands the rest.
class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key, required this.exercises, required this.lastBest, this.visible = 3});

  final List<Exercise> exercises;
  final Map<String, LoggedSet> lastBest;
  final int visible;

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final all = widget.exercises;
    final shown = _expanded ? all : all.take(widget.visible).toList();
    final hidden = all.skip(widget.visible).toList();

    return Column(
      children: [
        for (final e in shown) ...[
          ExerciseCard(exercise: e, lastBest: widget.lastBest[e.name]),
          const VGap(12),
        ],
        if (hidden.isNotEmpty)
          AppCard(
            padding: 12,
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _expanded
                        ? 'Show less'
                        : '+${hidden.length} more · ${hidden.map((e) => e.name).join(', ')}',
                    style: context.text.body.tint(context.colors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.25 : 0,
                  duration: AppDurations.fast,
                  child: Icon(AppIcons.chevron, color: context.colors.textSecondary),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
