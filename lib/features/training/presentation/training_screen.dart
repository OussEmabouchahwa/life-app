import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../data/training_repository.dart';
import 'widgets/exercise_list.dart';
import 'widgets/split_week_strip.dart';

/// Figma 04 · Training.
class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final week = ref.watch(trainingWeekProvider);
    final workout = week.today;

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: week.label,
          title: 'Training',
          trailing: SoftTag(label: '${week.streakWeeks} wk streak', icon: AppIcons.flame),
        ),
        SplitWeekStrip(split: week.split, todayIndex: DateTime.now().weekday - 1),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workout.name, style: context.text.headline),
                  Text(
                    '${workout.exercises.length} exercises · about ${workout.minutes} min',
                    style: context.text.body.tint(context.colors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: context.wp(0.22),
              child: AppButton(label: 'Start', height: 44, onPressed: () => context.push(Routes.workoutLog)),
            ),
          ],
        ),
        ExerciseList(exercises: workout.exercises),
      ],
    );
  }
}
