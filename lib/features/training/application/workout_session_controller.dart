import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/training_repository.dart';
import '../domain/training_models.dart';

@immutable
class WorkoutSessionState {
  const WorkoutSessionState({
    required this.workout,
    required this.exerciseIndex,
    required this.weightKg,
    required this.reps,
    this.logged = const [],
    this.restLeft = Duration.zero,
    this.restTotal = WorkoutSessionController.defaultRest,
  });

  final Workout workout;
  final int exerciseIndex;
  final double weightKg;
  final int reps;

  /// Sets logged for the current exercise.
  final List<LoggedSet> logged;
  final Duration restLeft;
  final Duration restTotal;

  Exercise get exercise => workout.exercises[exerciseIndex];
  int get currentSet => logged.length; // 0-based
  bool get isLastExercise => exerciseIndex == workout.exercises.length - 1;
  double get restProgress => restTotal.inSeconds == 0 ? 0 : restLeft.inSeconds / restTotal.inSeconds;

  WorkoutSessionState copyWith({
    int? exerciseIndex,
    double? weightKg,
    int? reps,
    List<LoggedSet>? logged,
    Duration? restLeft,
    Duration? restTotal,
  }) => WorkoutSessionState(
    workout: workout,
    exerciseIndex: exerciseIndex ?? this.exerciseIndex,
    weightKg: weightKg ?? this.weightKg,
    reps: reps ?? this.reps,
    logged: logged ?? this.logged,
    restLeft: restLeft ?? this.restLeft,
    restTotal: restTotal ?? this.restTotal,
  );
}

final workoutSessionProvider = NotifierProvider.autoDispose<WorkoutSessionController, WorkoutSessionState>(
  WorkoutSessionController.new,
);

/// Drives the workout log: steppers, logging sets and the rest timer.
class WorkoutSessionController extends Notifier<WorkoutSessionState> {
  static const defaultRest = Duration(seconds: 90);
  static const weightStep = 2.5;

  Timer? _timer;

  @override
  WorkoutSessionState build() {
    ref.onDispose(() => _timer?.cancel());
    final workout = ref.watch(trainingWeekProvider).today;
    return _startExercise(workout, 0);
  }

  WorkoutSessionState _startExercise(Workout w, int index) {
    final e = w.exercises[index];
    return WorkoutSessionState(workout: w, exerciseIndex: index, weightKg: e.weightKg, reps: e.reps);
  }

  void changeWeight(int direction) =>
      state = state.copyWith(weightKg: (state.weightKg + direction * weightStep).clamp(0, 500).toDouble());

  void changeReps(int direction) => state = state.copyWith(reps: (state.reps + direction).clamp(1, 50));

  void logSet() {
    final logged = [...state.logged, LoggedSet(state.weightKg, state.reps)];
    if (logged.length >= state.exercise.sets && !state.isLastExercise) {
      state = _startExercise(state.workout, state.exerciseIndex + 1);
    } else {
      state = state.copyWith(logged: logged);
    }
    _startRest(defaultRest);
  }

  void addRest(Duration extra) {
    state = state.copyWith(restLeft: state.restLeft + extra, restTotal: state.restTotal + extra);
    if (_timer == null) _startRest(state.restLeft);
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
