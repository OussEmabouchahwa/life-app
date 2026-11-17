import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/stored_list_controller.dart';
import '../domain/training_models.dart';
import 'training_providers.dart';

@immutable
class WorkoutSessionState {
  const WorkoutSessionState({
    required this.workout,
    required this.exerciseIndex,
    required this.weightKg,
    required this.reps,
    this.logs = const {},
    this.restLeft = Duration.zero,
    this.restTotal = WorkoutSessionController.defaultRest,
  });

  final Workout workout;
  final int exerciseIndex;
  final double weightKg;
  final int reps;

  /// Exercise index → sets logged in this session.
  final Map<int, List<LoggedSet>> logs;
  final Duration restLeft;
  final Duration restTotal;

  Exercise get exercise => workout.exercises[exerciseIndex];
  List<LoggedSet> get logged => logs[exerciseIndex] ?? const [];
  bool isComplete(int i) => (logs[i]?.length ?? 0) >= workout.exercises[i].sets;
  bool get allComplete => [for (var i = 0; i < workout.exercises.length; i++) isComplete(i)].every((d) => d);
  int get totalSets => logs.values.fold(0, (s, l) => s + l.length);
  double get restProgress => restTotal.inSeconds == 0 ? 0 : restLeft.inSeconds / restTotal.inSeconds;

  WorkoutSessionState copyWith({
    int? exerciseIndex,
    double? weightKg,
    int? reps,
    Map<int, List<LoggedSet>>? logs,
    Duration? restLeft,
    Duration? restTotal,
  }) => WorkoutSessionState(
    workout: workout,
    exerciseIndex: exerciseIndex ?? this.exerciseIndex,
    weightKg: weightKg ?? this.weightKg,
    reps: reps ?? this.reps,
    logs: logs ?? this.logs,
    restLeft: restLeft ?? this.restLeft,
    restTotal: restTotal ?? this.restTotal,
  );
}

/// One running session per workout id. Auto-disposed when the log closes.
final workoutSessionProvider = NotifierProvider.autoDispose
    .family<WorkoutSessionController, WorkoutSessionState, String>(WorkoutSessionController.new);

/// Drives the workout log: steppers, logging sets, rest timer, saving history.
class WorkoutSessionController extends Notifier<WorkoutSessionState> {
  WorkoutSessionController(this.workoutId);

  final String workoutId;

  static const defaultRest = Duration(seconds: 90);
  static const weightStep = 2.5;

  Timer? _timer;

  @override
  WorkoutSessionState build() {
    ref.onDispose(() => _timer?.cancel());
    final workout = ref.read(workoutsProvider).firstWhere((w) => w.id == workoutId);
    final first = workout.exercises.first;
    return WorkoutSessionState(
      workout: workout,
      exerciseIndex: 0,
      weightKg: _startWeight(first),
      reps: first.reps,
    );
  }

  /// Last weight lifted for this exercise, else the planned one.
  double _startWeight(Exercise e) => ref.read(lastBestSetProvider)[e.name]?.weightKg ?? e.weightKg;

  void selectExercise(int i) {
    final e = state.workout.exercises[i];
    final last = state.logs[i]?.lastOrNull;
    state = state.copyWith(
      exerciseIndex: i,
      weightKg: last?.weightKg ?? _startWeight(e),
      reps: last?.reps ?? e.reps,
    );
  }

  void changeWeight(int direction) =>
      state = state.copyWith(weightKg: (state.weightKg + direction * weightStep).clamp(0, 500).toDouble());

  void changeReps(int direction) => state = state.copyWith(reps: (state.reps + direction).clamp(1, 50));

  void logSet() {
    final i = state.exerciseIndex;
    state = state.copyWith(
      logs: {
        ...state.logs,
        i: [...state.logged, LoggedSet(state.weightKg, state.reps)],
      },
    );
    _startRest(defaultRest);
    // Move on to the next unfinished exercise once this one is done.
    if (state.isComplete(i)) {
      final n = state.workout.exercises.length;
      final next = [for (var k = 1; k < n; k++) (i + k) % n].where((k) => !state.isComplete(k)).firstOrNull;
      if (next != null) selectExercise(next);
    }
  }

  void undoLastSet() {
    final i = state.exerciseIndex;
    if (state.logged.isEmpty) return;
    state = state.copyWith(
      logs: {
        ...state.logs,
        i: [...state.logged]..removeLast(),
      },
    );
  }

  void addRest(Duration extra) {
    state = state.copyWith(restLeft: state.restLeft + extra, restTotal: state.restTotal + extra);
    if (_timer == null) _startRest(state.restLeft);
  }

  /// Saves the session to history. Returns false when nothing was logged.
  bool finish() {
    _timer?.cancel();
    if (state.totalSets == 0) return false;
    final ex = state.workout.exercises;
    ref
        .read(workoutHistoryProvider.notifier)
        .save(
          WorkoutSession(
            id: newId(),
            workoutName: state.workout.name,
            date: DateTime.now(),
            sets: {
              for (final MapEntry(key: i, value: sets) in state.logs.entries)
                if (sets.isNotEmpty) ex[i].name: sets,
            },
          ),
        );
    return true;
  }

  void _startRest(Duration d) {
    _timer?.cancel();
    state = state.copyWith(restLeft: d, restTotal: d);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = state.restLeft - const Duration(seconds: 1);
      if (left <= Duration.zero) {
        _timer?.cancel();
        _timer = null;
        state = state.copyWith(restLeft: Duration.zero);
      } else {
        state = state.copyWith(restLeft: left);
      }
    });
  }
}
