import 'package:flutter/foundation.dart';

import '../../../core/storage/stored_list_controller.dart';

@immutable
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    this.weightKg = 0,
  });

  final String id;
  final String name;
  final int sets;
  final int reps;

  /// Planned working weight (0 for body weight).
  final double weightKg;

  Exercise copyWith({String? name, int? sets, int? reps, double? weightKg}) => Exercise(
    id: id,
    name: name ?? this.name,
    sets: sets ?? this.sets,
    reps: reps ?? this.reps,
    weightKg: weightKg ?? this.weightKg,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'sets': sets, 'reps': reps, 'kg': weightKg};

  factory Exercise.fromJson(Map<String, dynamic> j) => Exercise(
    id: j['id'] as String,
    name: j['name'] as String,
    sets: j['sets'] as int,
    reps: j['reps'] as int,
    weightKg: Json.toDouble(j['kg']),
  );
}

/// A named workout (Push day) with its exercises.
@immutable
class Workout implements Stored {
  const Workout({required this.id, required this.name, required this.minutes, required this.exercises});

  @override
  final String id;
  final String name;
  final int minutes;
  final List<Exercise> exercises;

  Workout copyWith({String? name, int? minutes, List<Exercise>? exercises}) => Workout(
    id: id,
    name: name ?? this.name,
    minutes: minutes ?? this.minutes,
    exercises: exercises ?? this.exercises,
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'minutes': minutes,
    'exercises': [for (final e in exercises) e.toJson()],
  };

  factory Workout.fromJson(Map<String, dynamic> j) => Workout(
    id: j['id'] as String,
    name: j['name'] as String,
    minutes: j['minutes'] as int,
    exercises: [for (final e in j['exercises'] as List) Exercise.fromJson(e as Map<String, dynamic>)],
  );
}

/// Which workout on which weekday, and the usual gym time.
@immutable
class TrainingProgramme {
  const TrainingProgramme({required this.split, this.gymMinutes = 17 * 60 + 15});

  /// DateTime.monday … DateTime.sunday → workout id (absent = rest).
  final Map<int, String> split;

  /// Usual start time, minutes after midnight.
  final int gymMinutes;

  String? workoutOn(int weekday) => split[weekday];

  Map<String, dynamic> toJson() => {
    'split': {for (final e in split.entries) '${e.key}': e.value},
    'gymMinutes': gymMinutes,
  };

  factory TrainingProgramme.fromJson(Map<String, dynamic> j) => TrainingProgramme(
    split: {for (final e in (j['split'] as Map).entries) int.parse(e.key as String): e.value as String},
    gymMinutes: j['gymMinutes'] as int? ?? 17 * 60 + 15,
  );
}

@immutable
class LoggedSet {
  const LoggedSet(this.weightKg, this.reps);

  final double weightKg;
  final int reps;

  Map<String, dynamic> toJson() => {'kg': weightKg, 'reps': reps};
  factory LoggedSet.fromJson(Map<String, dynamic> j) => LoggedSet(Json.toDouble(j['kg']), j['reps'] as int);
}

/// A finished workout, kept as history.
@immutable
class WorkoutSession implements Stored {
  const WorkoutSession({required this.id, required this.workoutName, required this.date, required this.sets});

  @override
  final String id;
  final String workoutName;
  final DateTime date;

  /// Exercise name → sets done.
  final Map<String, List<LoggedSet>> sets;

  int get setCount => sets.values.fold(0, (s, l) => s + l.length);

  /// Total kilograms lifted (weight × reps).
  double get volume => sets.values.expand((l) => l).fold(0, (s, x) => s + x.weightKg * x.reps);

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'workout': workoutName,
    'date': Json.date(date),
    'sets': {
      for (final e in sets.entries) e.key: [for (final s in e.value) s.toJson()],
    },
  };

  factory WorkoutSession.fromJson(Map<String, dynamic> j) => WorkoutSession(
    id: j['id'] as String,
    workoutName: j['workout'] as String,
    date: Json.toDate(j['date']),
    sets: {
      for (final e in (j['sets'] as Map).entries)
        e.key as String: [for (final s in e.value as List) LoggedSet.fromJson(s as Map<String, dynamic>)],
    },
  );
}

/// "60" / "57.5"
String formatKg(double kg) => kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : kg.toStringAsFixed(1);
