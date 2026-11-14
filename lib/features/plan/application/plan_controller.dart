import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/time_format.dart';
import '../../../shared/models/event_category.dart';
import '../../../shared/models/plan_item.dart';
import '../../timetable/application/timetable_providers.dart';
import '../data/plan_repository.dart';

/// Personal items (routine + events the user adds).
final planControllerProvider = NotifierProvider<PlanController, List<PlanItem>>(PlanController.new);

class PlanController extends Notifier<List<PlanItem>> {
  @override
  List<PlanItem> build() => ref.read(planRepositoryProvider).weekOf(DateTime.now());

  void add(PlanItem item) => state = [...state, item];
}

/// Ids the user ticked as done. Kept apart from the items so classes from the
/// timetable can be ticked too.
final completedItemsProvider = NotifierProvider<CompletedItems, Set<String>>(CompletedItems.new);

class CompletedItems extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  void toggle(String id) => state = state.contains(id) ? ({...state}..remove(id)) : {...state, id};
}

/// Classes of the faculty timetable as plan items.
final classPlanItemsProvider = Provider<List<PlanItem>>(
  (ref) => [
    for (final s in ref.watch(allSessionsProvider))
      PlanItem(
        id: s.id,
        title: s.title,
        detail: [s.professor, ?s.roomShort].join(' · '),
        start: s.start,
        duration: s.duration,
        category: EventCategory.classes,
      ),
  ],
);

/// Classes + personal items of one day, sorted by start time.
final itemsForDayProvider = Provider.family<List<PlanItem>, DateTime>((ref, day) {
  final done = ref.watch(completedItemsProvider);
  return [
    for (final i in [...ref.watch(classPlanItemsProvider), ...ref.watch(planControllerProvider)])
      if (i.start.isSameDay(day)) i.copyWith(done: i.done || done.contains(i.id)),
  ]..sort((a, b) => a.start.compareTo(b.start));
});

final todayItemsProvider = Provider<List<PlanItem>>((ref) {
  final now = ref.watch(nowProvider);
  return ref.watch(itemsForDayProvider(now.dateOnly));
});

/// Day selected in the Plan week strip.
final selectedDayProvider = NotifierProvider<SelectedDay, DateTime>(SelectedDay.new);

class SelectedDay extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now().dateOnly;

  void select(DateTime day) => state = day.dateOnly;
}

/// The seven days of the current week, Monday first.
final currentWeekProvider = Provider<List<DateTime>>((ref) {
  final monday = mondayOf(ref.watch(nowProvider));
  return [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];
});
