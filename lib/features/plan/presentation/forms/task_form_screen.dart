import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/stored_list_controller.dart';
import '../../../../core/ui.dart';
import '../../../timetable/application/timetable_providers.dart';
import '../../application/plan_controller.dart';
import '../../data/tasks.dart';

/// Add or edit a task with a deadline.
class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  late final Task? _existing = widget.id == null ? null : ref.read(tasksProvider.notifier).byId(widget.id!);
  late String _title = _existing?.title ?? '';
  late String _code = _existing?.courseCode ?? '';
  late DateTime _date = (_existing?.due ?? DateTime.now().add(const Duration(days: 3))).dateOnly;
  late int _time = _existing == null ? 23 * 60 + 59 : _existing.due.hour * 60 + _existing.due.minute;
  late String _notes = _existing?.notes ?? '';

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(courseProgressProvider);
    return FormPage(
      title: _existing == null ? 'Add task' : 'Edit task',
      eyebrow: 'Tasks',
      canSave: _title.trim().isNotEmpty,
      onSave: () => ref
          .read(tasksProvider.notifier)
          .save(
            Task(
              id: _existing?.id ?? newId(),
              title: _title.trim(),
              due: _date.add(Duration(minutes: _time)),
              courseCode: _code.isEmpty ? null : _code,
              notes: _notes.trim(),
              done: _existing?.done ?? false,
            ),
          ),
      deleteWhat: 'this task',
      onDelete: _existing == null ? null : () => ref.read(tasksProvider.notifier).remove(_existing.id),
      children: [
        AppTextField(
          label: 'Task',
          hint: 'Mini project report',
          initialValue: _title,
          autofocus: _existing == null,
          onChanged: (v) => setState(() => _title = v),
        ),
        PickerField<String>(
          label: 'Course',
          value: _code,
          options: ['', for (final c in courses) c.code],
          labelOf: (code) => code.isEmpty ? 'None' : courses.firstWhere((c) => c.code == code).name,
          onChanged: (code) => setState(() => _code = code),
        ),
        FormRow(
          children: [
            DateField(label: 'Due', value: _date, onChanged: (d) => setState(() => _date = d.dateOnly)),
            TimeField(label: 'At', minutes: _time, onChanged: (m) => setState(() => _time = m)),
          ],
        ),
        AppTextField(label: 'Notes', initialValue: _notes, maxLines: 3, onChanged: (v) => _notes = v),
      ],
    );
  }
}
