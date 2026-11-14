import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/study_models.dart';

final studyRepositoryProvider = Provider<StudyRepository>((ref) => const StudyRepository());

/// Semester data from the design.
class StudyRepository {
  const StudyRepository();

  List<Exam> upcomingExams(DateTime today) => [
    Exam(
      subject: 'Databases',
      detail: 'Prof. Ben Salah · Room B12',
      date: today.add(const Duration(days: 5)),
      when: '09:00 · Written · 1h 30',
    ),
    Exam(
      subject: 'Computer Networks',
      detail: 'Prof. Trabelsi · Lab 3',
      date: today.add(const Duration(days: 10)),
      when: '10:30 · Practical · 2 h',
    ),
    Exam(
      subject: 'Algorithms',
      detail: 'Prof. Gharbi · Room A04',
      date: today.add(const Duration(days: 17)),
      when: '14:00 · Written · 2 h',
    ),
  ];

  List<RevisionGoal> revisionGoals() => const [
    RevisionGoal('Databases', 6, 8),
    RevisionGoal('Computer Networks', 3, 6),
    RevisionGoal('Algorithms', 2, 6),
  ];

  RevisionWeek revisionWeek() => const RevisionWeek(8, 5, 6);

  List<SubjectGrades> grades() => const [
    SubjectGrades(
      name: 'Databases',
      prof: 'Prof. Ben Salah',
      coef: 3,
      marks: {Assessment.ds: 14.5, Assessment.tp: 16},
    ),
    SubjectGrades(
      name: 'Networks',
      prof: 'Prof. Trabelsi',
      coef: 2.5,
      marks: {Assessment.ds: 12, Assessment.tp: 15},
    ),
    SubjectGrades(name: 'Algorithms', prof: 'Prof. Gharbi', coef: 3, marks: {Assessment.ds: 11}),
    SubjectGrades(name: 'English', prof: 'Mrs. Hamdi', coef: 1, marks: {Assessment.ds: 17}),
  ];

  /// Average of the previous term, for the trend tag.
  double lastTermAverage() => 13.2;
}
