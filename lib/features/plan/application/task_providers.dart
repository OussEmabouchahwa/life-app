import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/time_format.dart';
import '../../timetable/application/timetable_providers.dart';
import '../data/tasks.dart';
import 'plan_controller.dart';

enum TaskFilter { open, thisWeek, done }

final taskFilterProvider = NotifierProvider<TaskFilterController, TaskFilter>(TaskFilterController.new);

class TaskFilterController extends Notifier<TaskFilter> {
  @override
  TaskFilter build() => TaskFilter.open;

  void select(TaskFilter f) => state = f;
}

/// Tasks grouped for the list, after the filter.
typedef TaskGroups = ({List<Task> overdue, List<Task> thisWeek, List<Task> later, List<Task> done});

final taskGroupsProvider = Provider<TaskGroups>((ref) {
  final now = ref.watch(nowProvider);
  final weekEnd = mondayOf(now).add(const Duration(days: 7));
  final filter = ref.watch(taskFilterProvider);
  final all = [...ref.watch(tasksProvider)]..sort((a, b) => a.due.compareTo(b.due));
  final open = [
    for (final t in all)
      if (!t.done) t,
  ];

  return (
    overdue: filter == TaskFilter.done
        ? const []
        : [
            for (final t in open)
              if (t.due.isBefore(now)) t,
          ],
    thisWeek: filter == TaskFilter.done
        ? const []
        : [
            for (final t in open)
              if (!t.due.isBefore(now) && t.due.isBefore(weekEnd)) t,
          ],
    later: filter == TaskFilter.open
        ? [
            for (final t in open)
              if (!t.due.isBefore(weekEnd)) t,
          ]
        : const [],
    done: filter == TaskFilter.done
        ? [
            for (final t in all.reversed)
              if (t.done) t,
          ]
        : const [],
  );
});

/// Progress on tasks due this week (done / total).
final weekTaskProgressProvider = Provider<({int done, int total})>((ref) {
  final now = ref.watch(nowProvider);
  final monday = mondayOf(now);
  final end = monday.add(const Duration(days: 7));
  final week = [
    for (final t in ref.watch(tasksProvider))
      if (!t.due.isBefore(monday) && t.due.isBefore(end)) t,
  ];
  return (done: week.where((t) => t.done).length, total: week.length);
});

/// Open tasks due today or overdue, for the Today screen.
final dueNowTasksProvider = Provider<List<Task>>((ref) {
  final endOfToday = ref.watch(nowProvider).dateOnly.add(const Duration(days: 1));
  return [
    for (final t in ref.watch(tasksProvider))
      if (!t.done && t.due.isBefore(endOfToday)) t,
  ]..sort((a, b) => a.due.compareTo(b.due));
});
