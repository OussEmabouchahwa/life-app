import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui.dart';
import '../application/workout_session_controller.dart';
import 'widgets/current_set_card.dart';
import 'widgets/exercise_switcher.dart';
import 'widgets/logged_sets_list.dart';
import 'widgets/rest_timer_card.dart';

/// Figma 05 · Workout log. "Finish" saves the session to the history.
class WorkoutLogScreen extends ConsumerWidget {
  const WorkoutLogScreen({super.key, required this.workoutId});

  final String workoutId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = workoutSessionProvider(workoutId);
    final s = ref.watch(provider);
    final ctrl = ref.read(provider.notifier);

    void finish() {
      final saved = ctrl.finish();
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      if (saved) {
        messenger.showSnackBar(SnackBar(content: Text('${s.workout.name} saved · ${s.totalSets} sets')));
      }
    }

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: '${s.workout.name} · Exercise ${s.exerciseIndex + 1} of ${s.workout.exercises.length}',
          title: s.exercise.name,
          showBack: true,
          trailing: SizedBox(
            width: context.wp(0.2),
            child: AppButton(
              label: s.allComplete ? 'Save' : 'Finish',
              height: 34,
              variant: s.allComplete ? AppButtonVariant.primary : AppButtonVariant.outlined,
              onPressed: finish,
            ),
          ),
        ),
        ExerciseSwitcher(state: s, onSelect: ctrl.selectExercise),
        RestTimerCard(
          left: s.restLeft,
          progress: s.restProgress,
          onAddTime: () => ctrl.addRest(const Duration(seconds: 15)),
        ),
        CurrentSetCard(workoutId: workoutId),
        LoggedSetsList(exercise: s.exercise, logged: s.logged),
      ],
    );
  }
}
