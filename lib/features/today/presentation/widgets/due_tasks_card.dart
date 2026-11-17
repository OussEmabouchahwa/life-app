import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';
import '../../../plan/data/tasks.dart';

/// "2 tasks due today" with the first ones listed; opens Tasks.
class DueTasksCard extends StatelessWidget {
  const DueTasksCard({super.key, required this.tasks, required this.now});

  final List<Task> tasks;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final overdue = tasks.where((t) => t.due.isBefore(now)).length;
    return AppCard(
      padding: 14,
      onTap: () => context.go(Routes.tasks),
      child: Row(
        children: [
          Icon(
            Icons.checklist_rounded,
            size: context.dp(AppSizes.icon),
            color: overdue > 0 ? c.danger : c.brand,
          ),
          const HGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overdue > 0
                      ? '$overdue overdue · ${tasks.length - overdue} due today'
                      : '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'} due today',
                  style: context.text.bodyStrong,
                ),
                Text(
                  tasks.take(2).map((t) => t.title).join(' · '),
                  style: context.text.bodySmall.tint(c.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(AppIcons.chevron, color: c.textSecondary),
        ],
      ),
    );
  }
}
