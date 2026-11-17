import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../application/training_providers.dart';
import 'widgets/exercise_list.dart';
import 'widgets/history_card.dart';
import 'widgets/split_week_strip.dart';

/// Figma 04 · Training: weekly split, the selected day's workout, history.
class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final stats = ref.watch(trainingStatsProvider);
    final today = DateTime.now().weekday;
    final day = ref.watch(selectedTrainingDayProvider);
    final workout = ref.watch(workoutOnProvider(day));
    final labels = [
      for (var d = 1; d <= 7; d++) ref.watch(workoutOnProvider(d))?.name.split(' ').first ?? 'Rest',
    ];
    final recent = ref.watch(recentSessionsProvider);
    final doneToday = day == today && ref.watch(doneTodayProvider);

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: '${stats.done} of ${stats.planned} workouts this week',
          title: 'Training',
          trailing: SoftTag(label: '${stats.streakWeeks} wk streak', icon: AppIcons.flame),
        ),
        SplitWeekStrip(
          labels: labels,
          today: today,
          selected: day,
          onSelect: ref.read(selectedTrainingDayProvider.notifier).select,
        ),
        if (workout == null)
          EmptyCard(
            title: 'Rest day',
            message: 'Recovery is part of the plan. Change the split if you want to train this day.',
            actionLabel: 'Edit programme',
            onAction: () => context.push(Routes.programme),
          )
        else ...[
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push(Routes.withId(Routes.workoutForm, workout.id)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(workout.name, style: context.text.headline),
                      Text(
                        '${workout.exercises.length} exercises · about ${workout.minutes} min · Edit',
                        style: context.text.body.tint(c.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: context.wp(0.22),
                child: AppButton(
                  label: doneToday ? 'Again' : 'Start',
                  height: 44,
                  onPressed: workout.exercises.isEmpty
                      ? null
                      : () => context.push(Routes.withId(Routes.workoutLog, workout.id)),
                ),
              ),
            ],
          ),
          ExerciseList(exercises: workout.exercises, lastBest: ref.watch(lastBestSetProvider)),
        ],
        AppButton(
          label: 'Edit programme',
          icon: AppIcons.sliders,
          variant: AppButtonVariant.outlined,
          onPressed: () => context.push(Routes.programme),
        ),
        const SectionHeader(title: 'History'),
        if (recent.isEmpty)
          Text('Finish a workout and it shows up here.', style: context.text.body.tint(c.textSecondary))
        else
          HistoryCard(sessions: recent),
      ],
    );
  }
}
