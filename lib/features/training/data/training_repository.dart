import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/stored_list_controller.dart';
import '../domain/training_models.dart';

/// The user's workouts. First launch starts from an editable push / pull /
/// legs template.
class WorkoutsController extends StoredListController<Workout> {
  @override
  String get storageKey => 'workouts_v1';

  @override
  Workout fromJson(Map<String, dynamic> json) => Workout.fromJson(json);

  @override
  List<Workout> get seed => const [
    Workout(
      id: 'push',
      name: 'Push day',
      minutes: 55,
      exercises: [
        Exercise(id: 'push-1', name: 'Bench press', sets: 4, reps: 8, weightKg: 40),
        Exercise(id: 'push-2', name: 'Incline dumbbell press', sets: 3, reps: 10, weightKg: 14),
        Exercise(id: 'push-3', name: 'Overhead press', sets: 3, reps: 8, weightKg: 25),
        Exercise(id: 'push-4', name: 'Triceps pushdown', sets: 3, reps: 12, weightKg: 20),
        Exercise(id: 'push-5', name: 'Lateral raise', sets: 3, reps: 15, weightKg: 6),
      ],
    ),
    Workout(
      id: 'pull',
      name: 'Pull day',
      minutes: 55,
      exercises: [
        Exercise(id: 'pull-1', name: 'Lat pulldown', sets: 4, reps: 10, weightKg: 40),
        Exercise(id: 'pull-2', name: 'Seated cable row', sets: 3, reps: 10, weightKg: 35),
        Exercise(id: 'pull-3', name: 'Face pull', sets: 3, reps: 15, weightKg: 15),
        Exercise(id: 'pull-4', name: 'Biceps curl', sets: 3, reps: 12, weightKg: 10),
      ],
    ),
    Workout(
      id: 'legs',
      name: 'Leg day',
      minutes: 60,
      exercises: [
        Exercise(id: 'legs-1', name: 'Squat', sets: 4, reps: 8, weightKg: 50),
        Exercise(id: 'legs-2', name: 'Romanian deadlift', sets: 3, reps: 10, weightKg: 40),
        Exercise(id: 'legs-3', name: 'Leg press', sets: 3, reps: 12, weightKg: 80),
        Exercise(id: 'legs-4', name: 'Calf raise', sets: 4, reps: 15, weightKg: 30),
      ],
    ),
  ];
}

/// Which workout on which day. Saved as one document.
class ProgrammeController extends Notifier<TrainingProgramme> {
  static const _key = 'programme_v1';
  static const _seed = TrainingProgramme(
    split: {
      DateTime.monday: 'push',
      DateTime.tuesday: 'pull',
      DateTime.wednesday: 'legs',
      DateTime.friday: 'push',
      DateTime.saturday: 'pull',
    },
  );

  @override
  TrainingProgramme build() {
    final json = ref.watch(localStoreProvider).readMap(_key);
    return json == null ? _seed : TrainingProgramme.fromJson(json);
  }

  void update(TrainingProgramme p) {
    state = p;
    ref.read(localStoreProvider).writeMap(_key, p.toJson());
  }

  /// Days pointing at a deleted workout become rest days.
  void forgetWorkout(String id) => update(
    TrainingProgramme(split: {...state.split}..removeWhere((_, w) => w == id), gymMinutes: state.gymMinutes),
  );
}

/// Finished workouts.
class WorkoutHistoryController extends StoredListController<WorkoutSession> {
  @override
  String get storageKey => 'workout_history_v1';

  @override
  WorkoutSession fromJson(Map<String, dynamic> json) => WorkoutSession.fromJson(json);
}
