import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';
import '../../data/tasks.dart';

/// ◯ Report chapter 3 / UX/UI · due Thu 19 Nov 23:59
class TaskRow extends StatelessWidget {
  const TaskRow({
    super.key,
    required this.task,
    required this.now,
    required this.onToggle,
    required this.onTap,
    this.courseName,
  });

  final Task task;
  final DateTime now;
  final String? courseName;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final overdue = !task.done && task.due.isBefore(now);
    final days = task.due.dateOnly.difference(now.dateOnly).inDays;
    final when = switch (days) {
      0 => 'today ${TimeFormat.hm(task.due)}',
      1 => 'tomorrow ${TimeFormat.hm(task.due)}',
      _ => DateFormat('EEE d MMM · HH:mm', locale).format(task.due),
    };

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: context.padSym(h: 14, v: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckCircle(checked: task.done, onTap: onToggle),
            const HGap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: context.text.bodyStrong.copyWith(
                      decoration: task.done ? TextDecoration.lineThrough : null,
                      color: task.done ? c.textSecondary : null,
                    ),
                  ),
                  if (courseName != null)
                    Text(courseName!, style: context.text.bodySmall.tint(c.textSecondary)),
                  const VGap(2),
                  Text(
                    overdue ? 'Overdue · was due $when' : 'Due $when',
                    style: context.text.caption.tint(overdue ? c.danger : c.textSecondary).bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
