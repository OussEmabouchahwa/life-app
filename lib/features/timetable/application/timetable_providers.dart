import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/time_format.dart';
import '../data/timetable_repository.dart';
import '../domain/class_session.dart';

/// Every class of the semester, sorted by start. Loaded once.
final sessionsProvider = FutureProvider<List<ClassSession>>(
  (ref) => ref.watch(timetableRepositoryProvider).sessions(),
);

/// Synchronous view: empty while loading, so screens never block on it.
final allSessionsProvider = Provider<List<ClassSession>>(
  (ref) => ref.watch(sessionsProvider).value ?? const [],
);

DateTime mondayOf(DateTime d) => d.dateOnly.subtract(Duration(days: d.weekday - DateTime.monday));

/// Monday of the week shown in the Timetable screen.
final timetableWeekProvider = NotifierProvider<TimetableWeek, DateTime>(TimetableWeek.new);

class TimetableWeek extends Notifier<DateTime> {
  @override
  DateTime build() => mondayOf(DateTime.now());

  void next() => state = mondayOf(state.add(const Duration(days: 7)));
  void previous() => state = mondayOf(state.subtract(const Duration(days: 7)));
  void thisWeek() => state = mondayOf(DateTime.now());
}

/// Classes of the week starting on [monday].
final sessionsOfWeekProvider = Provider.family<List<ClassSession>, DateTime>((ref, monday) {
  final end = monday.add(const Duration(days: 7));
  return [
    for (final s in ref.watch(allSessionsProvider))
      if (!s.start.isBefore(monday) && s.start.isBefore(end)) s,
  ];
});

/// Teaching week number (1 = week of the first class), null outside the semester.
final semesterWeekProvider = Provider.family<int?, DateTime>((ref, monday) {
  final all = ref.watch(allSessionsProvider);
  if (all.isEmpty) return null;
  final week = monday.difference(mondayOf(all.first.start)).inDays ~/ 7 + 1;
  final last = monday.difference(mondayOf(all.last.start)).inDays ~/ 7;
  return week < 1 || last > 0 ? null : week;
});

/// Progress of one course through the semester.
@immutable
class CourseProgress {
  const CourseProgress({
    required this.code,
    required this.name,
    required this.professor,
    required this.done,
    required this.total,
    this.next,
  });

  final String code;
  final String name;
  final String professor;
  final int done;
  final int total;
  final ClassSession? next;

  double get progress => total == 0 ? 0 : done / total;
}

/// One entry per course, next session first.
final courseProgressProvider = Provider<List<CourseProgress>>((ref) {
  final now = ref.watch(nowProvider);
  final byCode = <String, List<ClassSession>>{};
  for (final s in ref.watch(allSessionsProvider)) {
    byCode.putIfAbsent(s.code, () => []).add(s);
  }
  final list = [
    for (final MapEntry(key: code, value: sessions) in byCode.entries)
      CourseProgress(
        code: code,
        name: sessions.first.title,
        professor: sessions.first.professor,
        done: sessions.where((s) => s.end.isBefore(now)).length,
        total: sessions.length,
        next: sessions.where((s) => s.end.isAfter(now)).firstOrNull,
      ),
  ];
  final far = DateTime(9999);
  return list..sort((a, b) => (a.next?.start ?? far).compareTo(b.next?.start ?? far));
});
