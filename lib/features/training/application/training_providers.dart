import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/time_format.dart';
import '../../timetable/application/timetable_providers.dart';
import '../data/training_repository.dart';
import '../domain/training_models.dart';

final workoutsProvider = NotifierProvider<WorkoutsController, List<Workout>>(WorkoutsController.new);

final programmeProvider = NotifierProvider<ProgrammeController, TrainingProgramme>(ProgrammeController.new);

final workoutHistoryProvider = NotifierProvider<WorkoutHistoryController, List<WorkoutSession>>(
  WorkoutHistoryController.new,
);

/// Workout planned on a weekday, or null for a rest day.
final workoutOnProvider = Provider.family<Workout?, int>((ref, weekday) {
  final id = ref.watch(programmeProvider).workoutOn(weekday);
  return ref.watch(workoutsProvider).where((w) => w.id == id).firstOrNull;
});

/// Weekday shown on the Training screen (today by default).
final selectedTrainingDayProvider = NotifierProvider<SelectedTrainingDay, int>(SelectedTrainingDay.new);

class SelectedTrainingDay extends Notifier<int> {
  @override
  int build() => DateTime.now().weekday;

  void select(int weekday) => state = weekday;
}

/// Heaviest set of each exercise in the most recent session that had it.
final lastBestSetProvider = Provider<Map<String, LoggedSet>>((ref) {
  final history = [...ref.watch(workoutHistoryProvider)]..sort((a, b) => b.date.compareTo(a.date));
  final best = <String, LoggedSet>{};
  for (final session in history) {
    for (final MapEntry(key: name, value: sets) in session.sets.entries) {
      if (best.containsKey(name) || sets.isEmpty) continue;
      best[name] = sets.reduce((a, b) => b.weightKg > a.weightKg ? b : a);
    }
  }
  return best;
});

typedef TrainingWeekStats = ({int done, int planned, int streakWeeks});

final trainingStatsProvider = Provider<TrainingWeekStats>((ref) {
  final now = ref.watch(nowProvider);
  final history = ref.watch(workoutHistoryProvider);
  final thisMonday = mondayOf(now);
  final weeks = {for (final s in history) mondayOf(s.date)};

  // Weeks in a row with at least one workout, counting back from this week
  // (or last week, so the streak does not drop on Monday morning).
  var week = weeks.contains(thisMonday) ? thisMonday : thisMonday.subtract(const Duration(days: 7));
  var streak = 0;
  while (weeks.contains(week)) {
    streak++;
    week = mondayOf(week.subtract(const Duration(days: 7)));
  }
  return (
    done: history
        .where((s) => !s.date.isBefore(thisMonday) && s.date.isBefore(now.add(const Duration(days: 1))))
        .length,
    planned: ref.watch(programmeProvider).split.length,
    streakWeeks: streak,
  );
});

/// Latest finished workouts, newest first.
final recentSessionsProvider = Provider<List<WorkoutSession>>(
  (ref) =>
      ([...ref.watch(workoutHistoryProvider)]..sort((a, b) => b.date.compareTo(a.date))).take(5).toList(),
);

/// Session already done today (the Start button becomes "Done").
final doneTodayProvider = Provider<bool>((ref) {
  final today = ref.watch(nowProvider);
  return ref.watch(workoutHistoryProvider).any((s) => s.date.isSameDay(today));
});
