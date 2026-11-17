import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/time_format.dart';
import '../../../shared/models/event_category.dart';
import '../../../shared/models/plan_item.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../../study/application/study_providers.dart';
import '../../timetable/application/timetable_providers.dart';
import '../../training/application/training_providers.dart';
import '../data/tasks.dart';
import '../data/work_shifts.dart';
import 'coach_choice.dart';
import 'personal_events.dart';

export 'personal_events.dart';

final workShiftsProvider = NotifierProvider<WorkShiftsController, List<WorkShift>>(WorkShiftsController.new);

final tasksProvider = NotifierProvider<TasksController, List<Task>>(TasksController.new);

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
        courseCode: s.code,
        route: Routes.timetable,
      ),
  ],
);

/// Exams entered in Study.
final examPlanItemsProvider = Provider<List<PlanItem>>(
  (ref) => [
    for (final e in ref.watch(examsProvider))
      PlanItem(
        id: 'exam-${e.id}',
        title: 'Exam · ${e.subject}',
        detail: [e.type.label, if (e.room.isNotEmpty) e.room].join(' · '),
        start: e.start,
        duration: Duration(minutes: e.minutes),
        category: EventCategory.exam,
        courseCode: e.courseCode,
        route: Routes.withId(Routes.examForm, e.id),
      ),
  ],
);

/// Items generated for one day from weekly rules: gym, work, coach.
final _routineForDayProvider = Provider.family<List<PlanItem>, DateTime>((ref, day) {
  final key = day.toIso8601String().substring(0, 10);
  final workout = ref.watch(workoutOnProvider(day.weekday));
  final gymAt = ref.watch(programmeProvider.select((p) => p.gymMinutes));
  final settings = ref.watch(settingsProvider);
  final coach = ref.watch(coachChoiceProvider);
  final hasClass = ref.watch(classPlanItemsProvider).any((c) => c.start.isSameDay(day));

  return [
    if (workout != null)
      PlanItem(
        id: 'gym-$key',
        title: 'Gym · ${workout.name}',
        detail: '${workout.exercises.length} exercises',
        start: day.add(Duration(minutes: gymAt)),
        duration: Duration(minutes: workout.minutes),
        category: EventCategory.gym,
        route: Routes.train,
      ),
    for (final s in ref.watch(workShiftsProvider))
      if (s.weekday == day.weekday)
        PlanItem(
          id: 'work-${s.id}-$key',
          title: s.place.isEmpty ? 'Work shift' : 'Work · ${s.place}',
          detail: TimeFormat.length(Duration(minutes: s.lengthMinutes)),
          start: day.add(Duration(minutes: s.startMinutes)),
          duration: Duration(minutes: s.lengthMinutes),
          category: EventCategory.work,
          route: Routes.withId(Routes.shiftForm, s.id),
        ),
    // From the far place, a coach on class days.
    if (settings.sleepPlace == SleepPlace.far && hasClass && coach != null)
      PlanItem(
        id: 'coach-$key',
        title: 'Coach to faculty',
        detail: 'From ${settings.farPlace} · ${settings.commuteMinutes} min',
        start: day.add(
          Duration(minutes: int.parse(coach.substring(0, 2)) * 60 + int.parse(coach.substring(3))),
        ),
        duration: Duration(minutes: settings.commuteMinutes),
        category: EventCategory.commute,
        route: Routes.commuteSettings,
      ),
  ];
});

/// Everything on one day, sorted by start time, with done ticks applied.
final itemsForDayProvider = Provider.family<List<PlanItem>, DateTime>((ref, day) {
  final done = ref.watch(completedItemsProvider);
  bool onDay(PlanItem i) => i.start.isSameDay(day);
  return [
    for (final i in [
      ...ref.watch(classPlanItemsProvider).where(onDay),
      ...ref.watch(examPlanItemsProvider).where(onDay),
      ...ref.watch(_routineForDayProvider(day.dateOnly)),
      for (final e in ref.watch(personalEventsProvider))
        if (onDay(e)) e.copyWith(editable: true, route: Routes.withId(Routes.addEvent, e.id)),
    ])
      i.copyWith(done: done.contains(i.id)),
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
  void shiftWeeks(int weeks) => state = state.add(Duration(days: 7 * weeks));
  void today() => state = DateTime.now().dateOnly;
}

/// The seven days of the week that holds the selected day, Monday first.
final planWeekProvider = Provider<List<DateTime>>((ref) {
  final monday = mondayOf(ref.watch(selectedDayProvider));
  return [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];
});
