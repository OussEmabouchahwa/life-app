import 'package:flutter/foundation.dart';

@immutable
class Exercise {
  const Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weightKg,
    required this.lastWeekKg,
  });

  final String name;
  final int sets;
  final int reps;
  final double weightKg;
  final double lastWeekKg;

  double get deltaKg => weightKg - lastWeekKg;
}

@immutable
class Workout {
  const Workout({required this.name, required this.minutes, required this.exercises});

  final String name;
  final int minutes;
  final List<Exercise> exercises;
}

@immutable
class TrainingWeek {
  const TrainingWeek({
    required this.label,
    required this.streakWeeks,
    required this.split,
    required this.today,
  });

  /// "Week 6 · Hypertrophy"
  final String label;
  final int streakWeeks;

  /// Monday → Sunday: Push, Pull, Legs, Rest…
  final List<String> split;
  final Workout today;
}

@immutable
class LoggedSet {
  const LoggedSet(this.weightKg, this.reps);

  final double weightKg;
  final int reps;
}

/// "60" / "57.5"
String formatKg(double kg) => kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : kg.toStringAsFixed(1);
