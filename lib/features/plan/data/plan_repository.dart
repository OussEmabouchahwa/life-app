import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/time_format.dart';
import '../../../shared/models/event_category.dart';
import '../../../shared/models/plan_item.dart';
import '../../timetable/application/timetable_providers.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) => DemoPlanRepository());

/// Personal items: everything that is not a class (classes come from the
/// faculty timetable, see `classPlanItemsProvider`).
abstract interface class PlanRepository {
  /// Personal items of the week (Monday → Sunday) that contains [day].
  List<PlanItem> weekOf(DateTime day);

  /// Coach departures from the place the user sleeps at.
  List<String> coachTimes();
}

/// Demo personal routine, placed around the real class slots
/// (08:30–11:45 and 13:15–16:30). Replace with the user's own data.
class DemoPlanRepository implements PlanRepository {
  @override
  List<String> coachTimes() => const ['07:10', '07:40', '08:15'];

  @override
  List<PlanItem> weekOf(DateTime day) {
    final monday = mondayOf(day);
    return [
      for (var i = 0; i < 7; i++)
        for (final t in _templates[i + 1] ?? const <_T>[]) t.build(monday.add(Duration(days: i))),
    ];
  }

  static const _coach = _T('Coach to faculty', 'Departs 07:10 · 55 min', 7, 10, 55, EventCategory.commute);
  static const _push = _T('Gym · Push day', '5 exercises · 55 min', 17, 15, 55, EventCategory.gym);
  static const _pull = _T('Gym · Pull day', '5 exercises · 55 min', 17, 15, 55, EventCategory.gym);
  static const _rev = _T('Revision', '90 min', 19, 30, 90, EventCategory.study);

  static const _templates = <int, List<_T>>{
    DateTime.monday: [_coach, _push, _rev],
    DateTime.tuesday: [_coach, _pull, _rev],
    DateTime.wednesday: [_coach, _rev],
    DateTime.thursday: [_coach, _T('Work shift', 'Café · 4 h', 17, 0, 240, EventCategory.work)],
    DateTime.friday: [_coach, _push],
    DateTime.saturday: [_T('Work shift', 'Café · 6 h', 9, 0, 300, EventCategory.work), _rev],
  };
}

/// Compact template for demo items.
class _T {
  const _T(this.title, this.detail, this.h, this.m, this.minutes, this.category);

  final String title, detail;
  final int h, m, minutes;
  final EventCategory category;

  PlanItem build(DateTime day) => PlanItem(
    id: '${day.toIso8601String()}-$h$m-$title',
    title: title,
    detail: detail,
    start: day.at(h, m),
    duration: Duration(minutes: minutes),
    category: category,
  );
}
