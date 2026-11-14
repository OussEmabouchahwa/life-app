import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/training_models.dart';

final trainingRepositoryProvider = Provider<TrainingRepository>((ref) => const TrainingRepository());

final trainingWeekProvider = Provider<TrainingWeek>(
  (ref) => ref.watch(trainingRepositoryProvider).currentWeek(),
);

/// Training programme from the design.
class TrainingRepository {
  const TrainingRepository();

  TrainingWeek currentWeek() => const TrainingWeek(
    label: 'Week 6 · Hypertrophy',
    streakWeeks: 4,
    split: ['Push', 'Pull', 'Legs', 'Rest', 'Push', 'Pull', 'Rest'],
    today: Workout(
      name: 'Push day',
      minutes: 55,
      exercises: [
        Exercise(name: 'Bench press', sets: 4, reps: 8, weightKg: 60, lastWeekKg: 57.5),
        Exercise(name: 'Incline dumbbell press', sets: 3, reps: 10, weightKg: 22, lastWeekKg: 22),
        Exercise(name: 'Overhead press', sets: 3, reps: 8, weightKg: 35, lastWeekKg: 32.5),
        Exercise(name: 'Triceps pushdown', sets: 3, reps: 12, weightKg: 25, lastWeekKg: 25),
        Exercise(name: 'Lateral raise', sets: 3, reps: 15, weightKg: 8, lastWeekKg: 8),
      ],
    ),
  );
}
