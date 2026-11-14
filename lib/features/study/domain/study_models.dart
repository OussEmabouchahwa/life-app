import 'package:flutter/foundation.dart';

@immutable
class Exam {
  const Exam({required this.subject, required this.detail, required this.date, required this.when});

  final String subject;

  /// "Prof. Ben Salah · Room B12"
  final String detail;
  final DateTime date;

  /// "09:00 · Written · 1h 30"
  final String when;
}

@immutable
class RevisionGoal {
  const RevisionGoal(this.subject, this.doneHours, this.plannedHours);

  final String subject;
  final double doneHours;
  final double plannedHours;

  double get progress => plannedHours == 0 ? 0 : doneHours / plannedHours;

  /// Less than 40 % done is flagged as behind.
  bool get behind => progress < 0.4;
}

@immutable
class RevisionWeek {
  const RevisionWeek(this.plannedHours, this.doneHours, this.streakDays);

  final int plannedHours;
  final int doneHours;
  final int streakDays;
}

/// Kinds of marks in a subject and their share of the final grade.
enum Assessment {
  ds('DS', 0.3),
  tp('TP', 0.1),
  exam('Exam', 0.6);

  const Assessment(this.label, this.weight);

  final String label;
  final double weight;
}

@immutable
class SubjectGrades {
  const SubjectGrades({required this.name, required this.prof, required this.coef, required this.marks});

  final String name;
  final String prof;
  final double coef;

  /// Marks out of 20 already known. Missing keys are not graded yet.
  final Map<Assessment, double> marks;

  /// Average of the marks known so far (what the design shows as AVG).
  double? get average => marks.isEmpty ? null : marks.values.reduce((a, b) => a + b) / marks.length;
}
