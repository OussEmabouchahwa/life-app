import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/time_format.dart';
import '../../../shared/models/event_category.dart';
import '../../../shared/models/plan_item.dart';
import 'plan_controller.dart';

enum DayLoad { light, normal, heavy }

@immutable
class DaySummary {
  const DaySummary({required this.day, required this.items});

  final DateTime day;
  final List<PlanItem> items;

  Duration get planned => items.fold(Duration.zero, (sum, i) => sum + i.duration);

  DayLoad get load => switch (planned.inMinutes) {
    >= 8 * 60 => DayLoad.heavy,
    >= 5 * 60 => DayLoad.normal,
    _ => DayLoad.light,
  };

  /// "4 items · 6 h 10"
  String get headline => items.isEmpty ? 'Free day' : '${items.length} items · ${TimeFormat.length(planned)}';

  /// One practical line about the day.
  String get hint {
    if (items.isEmpty) return 'Nothing planned';
    PlanItem? find(EventCategory c) => items.where((i) => i.category == c).firstOrNull;
    final work = find(EventCategory.work);
    if (work != null) return 'Work shift ${TimeFormat.hm(work.start)} – ${TimeFormat.hm(work.end)}';
    if (day.weekday == DateTime.friday) return 'Jumu’a 12:30 replaces Dhuhr';
    final gym = find(EventCategory.gym);
    if (load == DayLoad.light && gym != null) return 'Light day, gym at ${TimeFormat.hm(gym.start)}';
    return 'Free from ${TimeFormat.hm(items.last.end)}';
  }
}

/// One summary per day of the current week.
final weekSummaryProvider = Provider<List<DaySummary>>(
  (ref) => [
    for (final d in ref.watch(currentWeekProvider))
      DaySummary(day: d, items: ref.watch(itemsForDayProvider(d))),
  ],
);

/// The busiest day, if it is heavy enough to warn about.
final heaviestDayProvider = Provider<DaySummary?>((ref) {
  final days = ref.watch(weekSummaryProvider);
  if (days.isEmpty) return null;
  final max = days.reduce((a, b) => a.planned >= b.planned ? a : b);
  return max.load == DayLoad.heavy ? max : null;
});
