import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/stored_list_controller.dart';
import '../../../core/utils/time_format.dart';
import '../../../shared/models/event_category.dart';
import '../../../shared/models/plan_item.dart';
import '../../prayers/data/prayer_repository.dart';
import '../../prayers/domain/prayer.dart';
import 'plan_controller.dart';

/// How the form was opened: `id` to edit, `category` to preselect.
typedef AddEventArgs = ({String? id, String? category});

@immutable
class AddEventState {
  const AddEventState({
    required this.date,
    this.existingId,
    this.title = '',
    this.notes = '',
    this.category = EventCategory.study,
    this.courseCode,
    this.startMinutes = 15 * 60,
    this.length = const Duration(minutes: 90),
    this.repeatWeeks = 0,
    this.keepConflict = false,
  });

  final String? existingId;
  final String title;
  final String notes;
  final EventCategory category;

  /// Course of a study session (counts towards its revision goal).
  final String? courseCode;
  final DateTime date;

  /// Minutes after midnight.
  final int startMinutes;
  final Duration length;

  /// Extra weekly copies to create (new events only).
  final int repeatWeeks;

  /// The user chose "Keep anyway" for the current prayer conflict.
  final bool keepConflict;

  bool get isEditing => existingId != null;
  DateTime get start => date.add(Duration(minutes: startMinutes));
  DateTime get end => start.add(length);
  bool get canSave => title.trim().isNotEmpty;

  AddEventState copyWith({
    String? title,
    String? notes,
    EventCategory? category,
    String? courseCode,
    bool clearCourse = false,
    DateTime? date,
    int? startMinutes,
    Duration? length,
    int? repeatWeeks,
    bool? keepConflict,
  }) => AddEventState(
    existingId: existingId,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    category: category ?? this.category,
    courseCode: clearCourse ? null : courseCode ?? this.courseCode,
    date: date ?? this.date,
    startMinutes: startMinutes ?? this.startMinutes,
    length: length ?? this.length,
    repeatWeeks: repeatWeeks ?? this.repeatWeeks,
    // Any change to the time resets the "keep anyway" choice.
    keepConflict:
        keepConflict ?? (date == null && startMinutes == null && length == null && this.keepConflict),
  );
}

/// Form state of "Add / edit event". Auto-disposed so it resets every time.
final addEventProvider = NotifierProvider.autoDispose.family<AddEventController, AddEventState, AddEventArgs>(
  AddEventController.new,
);

class AddEventController extends Notifier<AddEventState> {
  AddEventController(this.args);

  final AddEventArgs args;

  @override
  AddEventState build() {
    final existing = args.id == null ? null : ref.read(personalEventsProvider.notifier).byId(args.id!);
    if (existing != null) {
      return AddEventState(
        existingId: existing.id,
        title: existing.title,
        notes: existing.detail,
        category: existing.category,
        courseCode: existing.courseCode,
        date: existing.start.dateOnly,
        startMinutes: existing.start.hour * 60 + existing.start.minute,
        length: existing.duration,
      );
    }
    final category = EventCategory.values.where((c) => c.name == args.category).firstOrNull;
    return AddEventState(date: ref.read(selectedDayProvider), category: category ?? EventCategory.study);
  }

  void setTitle(String v) => state = state.copyWith(title: v);
  void setNotes(String v) => state = state.copyWith(notes: v);
  void setCategory(EventCategory c) => state = state.copyWith(
    category: c,
    clearCourse: c != EventCategory.study && c != EventCategory.classes,
  );
  void setCourse(String? code, {String? name}) {
    final autoTitle = state.title.isEmpty || state.title.startsWith('Revision · ');
    state = state.copyWith(
      courseCode: code,
      clearCourse: code == null,
      title: autoTitle && name != null && state.category == EventCategory.study ? 'Revision · $name' : null,
    );
  }

  void setDate(DateTime d) => state = state.copyWith(date: d.dateOnly);
  void setStart(int minutes) => state = state.copyWith(startMinutes: minutes);
  void setLength(Duration d) => state = state.copyWith(length: d);
  void setRepeat(int weeks) => state = state.copyWith(repeatWeeks: weeks);
  void keepAnyway() => state = state.copyWith(keepConflict: true);

  /// Moves the event to right after the prayer window.
  void moveAfter(PrayerTime p) {
    final end = p.windowEnd;
    setStart(end.hour * 60 + end.minute);
  }

  PlanItem _item(String id, int weekOffset) => PlanItem(
    id: id,
    title: state.title.trim(),
    detail: state.notes.trim(),
    start: state.start.add(Duration(days: 7 * weekOffset)),
    duration: state.length,
    category: state.category,
    courseCode: state.courseCode,
    editable: true,
  );

  /// Saves into the plan (and the weekly copies). Returns false if invalid.
  bool save() {
    if (!state.canSave) return false;
    final events = ref.read(personalEventsProvider.notifier);
    if (state.isEditing) {
      events.save(_item(state.existingId!, 0));
    } else {
      events.saveAll([for (var w = 0; w <= state.repeatWeeks; w++) _item(newId(), w)]);
    }
    return true;
  }

  void delete() {
    if (state.isEditing) ref.read(personalEventsProvider.notifier).remove(state.existingId!);
  }
}

/// First prayer the event overlaps, unless the user kept it.
final addEventConflictProvider = Provider.autoDispose.family<PrayerTime?, AddEventArgs>((ref, args) {
  final s = ref.watch(addEventProvider(args));
  if (s.keepConflict) return null;
  final prayers = ref.watch(prayerRepositoryProvider).timesFor(s.date);
  return prayers.where((p) => p.time.isBefore(s.end) && p.windowEnd.isAfter(s.start)).firstOrNull;
});

/// Other items on the chosen day, for the "Day at a glance" lanes.
final addEventDayItemsProvider = Provider.autoDispose.family<List<PlanItem>, AddEventArgs>((ref, args) {
  final s = ref.watch(addEventProvider(args));
  return [
    for (final i in ref.watch(itemsForDayProvider(s.date)))
      if (i.id != s.existingId) i,
  ];
});
