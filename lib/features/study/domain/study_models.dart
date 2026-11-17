import 'package:flutter/foundation.dart';

import '../../../core/storage/stored_list_controller.dart';

enum ExamType {
  written('Written'),
  practical('Practical'),
  oral('Oral'),
  project('Project');

  const ExamType(this.label);
  final String label;
}

/// An exam the user entered.
@immutable
class Exam implements Stored {
  const Exam({
    required this.id,
    required this.subject,
    required this.start,
    required this.minutes,
    required this.type,
    this.courseCode,
    this.room = '',
  });

  @override
  final String id;

  /// Course name ("Mobile Android & Flutter") or free text.
  final String subject;

  /// Timetable course it belongs to, if any.
  final String? courseCode;
  final DateTime start;
  final int minutes;
  final ExamType type;
  final String room;

  DateTime get end => start.add(Duration(minutes: minutes));

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'courseCode': courseCode,
    'start': Json.date(start),
    'minutes': minutes,
    'type': type.name,
    'room': room,
  };

  factory Exam.fromJson(Map<String, dynamic> j) => Exam(
    id: j['id'] as String,
    subject: j['subject'] as String,
    courseCode: j['courseCode'] as String?,
    start: Json.toDate(j['start']),
    minutes: j['minutes'] as int,
    type: ExamType.values.byName(j['type'] as String),
    room: j['room'] as String? ?? '',
  );
}

/// Kinds of marks in a subject.
enum Assessment {
  ds('DS'),
  tp('TP'),
  exam('Exam');

  const Assessment(this.label);
  final String label;
}

/// Grades of one course. The id is the course code.
@immutable
class SubjectGrades implements Stored {
  const SubjectGrades({
    required this.id,
    required this.name,
    this.professor = '',
    this.coef = 1,
    this.weights = defaultWeights,
    this.marks = const {},
  });

  /// Common split in Tunisian faculties; editable per subject.
  static const defaultWeights = {Assessment.ds: 0.3, Assessment.tp: 0.1, Assessment.exam: 0.6};

  @override
  final String id;
  final String name;
  final String professor;
  final double coef;

  /// Share of each assessment in the final mark (sums to 1).
  final Map<Assessment, double> weights;

  /// Marks out of 20 already known.
  final Map<Assessment, double> marks;

  double weightOf(Assessment a) => weights[a] ?? 0;

  /// Assessments that count for this subject (weight above zero).
  List<Assessment> get assessments => [
    for (final a in Assessment.values)
      if (weightOf(a) > 0) a,
  ];

  /// Average of the marks known so far, weighted. Null when nothing is graded.
  double? get average {
    var sum = 0.0, w = 0.0;
    for (final a in assessments) {
      final m = marks[a];
      if (m == null) continue;
      sum += m * weightOf(a);
      w += weightOf(a);
    }
    return w == 0 ? null : sum / w;
  }

  bool get hasMarks => marks.isNotEmpty;

  SubjectGrades copyWith({
    String? name,
    String? professor,
    double? coef,
    Map<Assessment, double>? weights,
    Map<Assessment, double>? marks,
  }) => SubjectGrades(
    id: id,
    name: name ?? this.name,
    professor: professor ?? this.professor,
    coef: coef ?? this.coef,
    weights: weights ?? this.weights,
    marks: marks ?? this.marks,
  );

  static Map<String, double> _encode(Map<Assessment, double> m) => {
    for (final e in m.entries) e.key.name: e.value,
  };
  static Map<Assessment, double> _decode(Object? m) => {
    for (final e in ((m as Map?) ?? const {}).entries)
      Assessment.values.byName(e.key as String): (e.value as num).toDouble(),
  };

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'professor': professor,
    'coef': coef,
    'weights': _encode(weights),
    'marks': _encode(marks),
  };

  factory SubjectGrades.fromJson(Map<String, dynamic> j) => SubjectGrades(
    id: j['id'] as String,
    name: j['name'] as String,
    professor: j['professor'] as String? ?? '',
    coef: Json.toDouble(j['coef']),
    weights: _decode(j['weights']),
    marks: _decode(j['marks']),
  );
}

/// Weekly revision target for one course. The id is the course code.
@immutable
class RevisionGoal implements Stored {
  const RevisionGoal({required this.id, required this.hoursPerWeek});

  @override
  final String id;
  final double hoursPerWeek;

  @override
  Map<String, dynamic> toJson() => {'id': id, 'hours': hoursPerWeek};

  factory RevisionGoal.fromJson(Map<String, dynamic> j) =>
      RevisionGoal(id: j['id'] as String, hoursPerWeek: Json.toDouble(j['hours']));
}

/// Revision progress of one course this week.
@immutable
class RevisionProgress {
  const RevisionProgress({
    required this.code,
    required this.name,
    required this.doneHours,
    required this.goalHours,
  });

  final String code;
  final String name;
  final double doneHours;
  final double goalHours;

  double get progress => goalHours == 0 ? 0 : (doneHours / goalHours).clamp(0, 1);

  /// Less than 40 % done is flagged as behind.
  bool get behind => progress < 0.4;
}
