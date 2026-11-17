import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/time_format.dart';
import '../../../shared/models/event_category.dart';
import '../../plan/application/personal_events.dart';
import '../../timetable/application/timetable_providers.dart';
import '../data/study_repository.dart';
import '../domain/grade_math.dart';
import '../domain/study_models.dart';

enum StudyTab { exams, revision, grades }

final studyTabProvider = NotifierProvider<StudyTabController, StudyTab>(StudyTabController.new);

class StudyTabController extends Notifier<StudyTab> {
  @override
  StudyTab build() => StudyTab.exams;

  void select(StudyTab tab) => state = tab;
}

// ── Exams ────────────────────────────────────────────────────────────────

final examsProvider = NotifierProvider<ExamsController, List<Exam>>(ExamsController.new);

/// Exams from today on, soonest first.
final upcomingExamsProvider = Provider<List<Exam>>((ref) {
  final today = ref.watch(nowProvider).dateOnly;
  return [
    for (final e in ref.watch(examsProvider))
      if (!e.start.isBefore(today)) e,
  ]..sort((a, b) => a.start.compareTo(b.start));
});

final pastExamsProvider = Provider<List<Exam>>((ref) {
  final today = ref.watch(nowProvider).dateOnly;
  return [
    for (final e in ref.watch(examsProvider))
      if (e.start.isBefore(today)) e,
  ]..sort((a, b) => b.start.compareTo(a.start));
});

// ── Grades ───────────────────────────────────────────────────────────────

final gradesProvider = NotifierProvider<GradesController, List<SubjectGrades>>(GradesController.new);

/// Every course of the timetable with its grades (defaults when none saved),
/// plus saved subjects that are not in the timetable.
final subjectsProvider = Provider<List<SubjectGrades>>((ref) {
  final saved = {for (final g in ref.watch(gradesProvider)) g.id: g};
  final courses = ref.watch(courseProgressProvider);
  final fromTimetable = [
    for (final c in courses)
      saved[c.code]?.copyWith(name: c.name, professor: c.professor) ??
          SubjectGrades(id: c.code, name: c.name, professor: c.professor),
  ];
  final codes = {for (final c in courses) c.code};
  return [
    ...fromTimetable,
    for (final g in saved.values)
      if (!codes.contains(g.id)) g,
  ];
});

final weightedAverageProvider = Provider<double?>(
  (ref) => GradeMath.weightedAverage(ref.watch(subjectsProvider)),
);

// ── Revision ─────────────────────────────────────────────────────────────

final revisionGoalsProvider = NotifierProvider<RevisionGoalsController, List<RevisionGoal>>(
  RevisionGoalsController.new,
);

/// Hours of ticked study sessions per course code this week ('' = no course).
final _studyHoursThisWeekProvider = Provider<Map<String, double>>((ref) {
  final monday = mondayOf(ref.watch(nowProvider));
  final end = monday.add(const Duration(days: 7));
  final done = ref.watch(completedItemsProvider);
  final hours = <String, double>{};
  for (final e in ref.watch(personalEventsProvider)) {
    if (e.category != EventCategory.study || !done.contains(e.id)) continue;
    if (e.start.isBefore(monday) || !e.start.isBefore(end)) continue;
    hours.update(
      e.courseCode ?? '',
      (h) => h + e.duration.inMinutes / 60,
      ifAbsent: () => e.duration.inMinutes / 60,
    );
  }
  return hours;
});

/// One row per course that has a weekly goal.
final revisionProgressProvider = Provider<List<RevisionProgress>>((ref) {
  final hours = ref.watch(_studyHoursThisWeekProvider);
  final names = {for (final s in ref.watch(subjectsProvider)) s.id: s.name};
  return [
    for (final g in ref.watch(revisionGoalsProvider))
      RevisionProgress(
        code: g.id,
        name: names[g.id] ?? g.id,
        doneHours: hours[g.id] ?? 0,
        goalHours: g.hoursPerWeek,
      ),
  ];
});

typedef RevisionWeek = ({double planned, double done, int streakDays});

final revisionWeekProvider = Provider<RevisionWeek>((ref) {
  final planned = ref.watch(revisionGoalsProvider).fold<double>(0, (s, g) => s + g.hoursPerWeek);
  final done = ref.watch(_studyHoursThisWeekProvider).values.fold<double>(0, (s, h) => s + h);

  // Consecutive days with a ticked study session, ending today (or yesterday).
  final ticked = ref.watch(completedItemsProvider);
  final days = {
    for (final e in ref.watch(personalEventsProvider))
      if (e.category == EventCategory.study && ticked.contains(e.id)) e.start.dateOnly,
  };
  var day = ref.watch(nowProvider).dateOnly;
  if (!days.contains(day)) day = day.subtract(const Duration(days: 1));
  var streak = 0;
  while (days.contains(day)) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return (planned: planned, done: done, streakDays: streak);
});
