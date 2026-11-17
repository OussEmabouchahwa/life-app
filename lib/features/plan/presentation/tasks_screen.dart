import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../../timetable/application/timetable_providers.dart';
import '../application/plan_controller.dart';
import '../application/task_providers.dart';
import '../data/tasks.dart';
import 'widgets/task_row.dart';

/// Figma 21 · Tasks & deadlines.
class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  static const _labels = {TaskFilter.open: 'Open', TaskFilter.thisWeek: 'This week', TaskFilter.done: 'Done'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final now = ref.watch(nowProvider);
    final groups = ref.watch(taskGroupsProvider);
    final week = ref.watch(weekTaskProgressProvider);
    final names = {for (final p in ref.watch(courseProgressProvider)) p.code: p.name};
    final openCount = ref.watch(tasksProvider).where((t) => !t.done).length;
    void open(String? id) => context.push(Routes.withId(Routes.taskForm, id));

    Widget section(String title, List<Task> tasks) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: '$title · ${tasks.length}'),
        const VGap(12),
        AppCard(
          padding: 0,
          child: DividedColumn(
            children: [
              for (final t in tasks)
                TaskRow(
                  task: t,
                  now: now,
                  courseName: names[t.courseCode],
                  onToggle: () => ref.read(tasksProvider.notifier).toggle(t.id),
                  onTap: () => open(t.id),
                ),
            ],
          ),
        ),
      ],
    );

    final sections = [
      if (groups.overdue.isNotEmpty) section('Overdue', groups.overdue),
      if (groups.thisWeek.isNotEmpty) section('This week', groups.thisWeek),
      if (groups.later.isNotEmpty) section('Later', groups.later),
      if (groups.done.isNotEmpty) section('Done', groups.done),
    ];

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: '$openCount open',
          title: 'Tasks',
          showBack: true,
          trailing: IconBoxButton(icon: AppIcons.plus, tooltip: 'Add task', onPressed: () => open(null)),
        ),
        ChoicePillRow<TaskFilter>(
          values: TaskFilter.values,
          selected: ref.watch(taskFilterProvider),
          labelOf: (f) => _labels[f]!,
          onChanged: ref.read(taskFilterProvider.notifier).select,
        ),
        if (week.total > 0)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('This week', style: context.text.title)),
                    Text(
                      '${week.done} of ${week.total} done',
                      style: context.text.body.tint(c.textSecondary),
                    ),
                  ],
                ),
                const VGap(10),
                AppProgressBar(value: week.done / week.total),
              ],
            ),
          ),
        if (sections.isEmpty)
          EmptyCard(
            title: 'Nothing here',
            message: 'Add reports, projects and homework with their deadline. Overdue ones turn red.',
            actionLabel: 'Add task',
            onAction: () => open(null),
          )
        else
          ...sections,
      ],
    );
  }
}
