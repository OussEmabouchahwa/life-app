import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui.dart';
import '../application/workout_session_controller.dart';
import 'widgets/current_set_card.dart';
import 'widgets/logged_sets_list.dart';
import 'widgets/rest_timer_card.dart';

/// Figma 05 · Workout log.
class WorkoutLogScreen extends ConsumerWidget {
  const WorkoutLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(workoutSessionProvider);

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: '${s.workout.name} · Exercise ${s.exerciseIndex + 1} of ${s.workout.exercises.length}',
          title: s.exercise.name,
          showBack: true,
          trailing: SizedBox(
            width: context.wp(0.17),
            child: AppButton(
              label: 'Finish',
              height: 34,
              variant: AppButtonVariant.outlined,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        RestTimerCard(
          left: s.restLeft,
          progress: s.restProgress,
          onAddTime: () => ref.read(workoutSessionProvider.notifier).addRest(const Duration(seconds: 15)),
        ),
        const CurrentSetCard(),
        LoggedSetsList(exercise: s.exercise, logged: s.logged),
      ],
    );
  }
}
