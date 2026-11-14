import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/time_format.dart';
import '../../../shared/models/event_category.dart';
import '../../../shared/models/plan_item.dart';
import '../../prayers/data/prayer_repository.dart';
import '../../prayers/domain/prayer.dart';
import 'plan_controller.dart';

@immutable
class AddEventState {
  const AddEventState({
    required this.date,
    this.title = '',
    this.category = EventCategory.study,
    this.startMinutes = 15 * 60,
    this.length = const Duration(minutes: 90),
    this.keepConflict = false,
  });

  final String title;
  final EventCategory category;
  final DateTime date;

  /// Minutes after midnight.
  final int startMinutes;
  final Duration length;

  /// The user chose "Keep anyway" for the current prayer conflict.
  final bool keepConflict;

  DateTime get start => date.add(Duration(minutes: startMinutes));
  DateTime get end => start.add(length);
  bool get canSave => title.trim().isNotEmpty;

  AddEventState copyWith({
    String? title,
    EventCategory? category,
    DateTime? date,
    int? startMinutes,
    Duration? length,
    bool? keepConflict,
  }) => AddEventState(
    title: title ?? this.title,
    category: category ?? this.category,
    date: date ?? this.date,
    startMinutes: startMinutes ?? this.startMinutes,
    length: length ?? this.length,
    // Any change to the time resets the "keep anyway" choice.
    keepConflict:
        keepConflict ?? (date == null && startMinutes == null && length == null && this.keepConflict),
  );
}

/// Form state of "Add event". Auto-disposed so it resets every time.
final addEventProvider = NotifierProvider.autoDispose<AddEventController, AddEventState>(
  AddEventController.new,
);

class AddEventController extends Notifier<AddEventState> {
  @override
  AddEventState build() => AddEventState(date: DateTime.now().dateOnly);

  void setTitle(String v) => state = state.copyWith(title: v);
  void setCategory(EventCategory c) => state = state.copyWith(category: c);
  void setDate(DateTime d) => state = state.copyWith(date: d.dateOnly);
  void setStart(int minutes) => state = state.copyWith(startMinutes: minutes);
  void setLength(Duration d) => state = state.copyWith(length: d);
  void keepAnyway() => state = state.copyWith(keepConflict: true);

  /// Moves the event to right after the prayer window.
  void moveAfter(PrayerTime p) {
    final end = p.windowEnd;
    setStart(end.hour * 60 + end.minute);
  }

  /// Saves into the plan. Returns false if the form is not valid.
  bool save() {
    if (!state.canSave) return false;
    ref
        .read(planControllerProvider.notifier)
        .add(
          PlanItem(
            id: 'new-${DateTime.now().microsecondsSinceEpoch}',
            title: state.title.trim(),
            detail: TimeFormat.length(state.length),
            start: state.start,
            duration: state.length,
            category: state.category,
          ),
        );
    return true;
  }
}

/// First prayer the new event overlaps, unless the user kept it.
final addEventConflictProvider = Provider.autoDispose<PrayerTime?>((ref) {
  final s = ref.watch(addEventProvider);
  if (s.keepConflict) return null;
  final prayers = ref.watch(prayerRepositoryProvider).timesFor(s.date);
  return prayers.where((p) => p.time.isBefore(s.end) && p.windowEnd.isAfter(s.start)).firstOrNull;
});

/// Existing items on the chosen day, for the "Day at a glance" lanes.
final addEventDayItemsProvider = Provider.autoDispose<List<PlanItem>>((ref) {
  final date = ref.watch(addEventProvider.select((s) => s.date));
  return ref.watch(itemsForDayProvider(date));
});
