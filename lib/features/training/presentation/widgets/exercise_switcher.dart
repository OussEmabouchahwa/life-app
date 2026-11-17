import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../application/workout_session_controller.dart';

/// Horizontal list of the workout's exercises; done ones show a tick.
class ExerciseSwitcher extends StatelessWidget {
  const ExerciseSwitcher({super.key, required this.state, required this.onSelect});

  final WorkoutSessionState state;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final exercises = state.workout.exercises;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < exercises.length; i++) ...[
            if (i > 0) const HGap(8),
            ChoicePill(
              label: exercises[i].name,
              icon: state.isComplete(i) ? AppIcons.check : null,
              selected: i == state.exerciseIndex,
              dense: true,
              height: 32,
              onTap: () => onSelect(i),
            ),
          ],
        ],
      ),
    );
  }
}
