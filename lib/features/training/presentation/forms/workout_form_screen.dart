import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/stored_list_controller.dart';
import '../../../../core/ui.dart';
import '../../application/training_providers.dart';
import '../../domain/training_models.dart';
import 'exercise_sheet.dart';

/// Create or edit a workout and its exercises.
class WorkoutFormScreen extends ConsumerStatefulWidget {
  const WorkoutFormScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends ConsumerState<WorkoutFormScreen> {
  late final Workout? _existing = widget.id == null
      ? null
      : ref.read(workoutsProvider.notifier).byId(widget.id!);
  late String _name = _existing?.name ?? '';
  late int _minutes = _existing?.minutes ?? 60;
  late final List<Exercise> _exercises = [...?_existing?.exercises];

  Future<void> _edit([int? index]) async {
    final result = await showExerciseSheet(context, initial: index == null ? null : _exercises[index]);
    if (result == null) return;
    setState(() => index == null ? _exercises.add(result) : _exercises[index] = result);
  }

  void _delete() {
    ref.read(programmeProvider.notifier).forgetWorkout(_existing!.id);
    ref.read(workoutsProvider.notifier).remove(_existing.id);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return FormPage(
      title: _existing == null ? 'New workout' : 'Edit workout',
      eyebrow: 'Training',
      canSave: _name.trim().isNotEmpty && _exercises.isNotEmpty,
      onSave: () => ref
          .read(workoutsProvider.notifier)
          .save(
            Workout(
              id: _existing?.id ?? newId(),
              name: _name.trim(),
              minutes: _minutes,
              exercises: _exercises,
            ),
          ),
      deleteWhat: 'this workout',
      onDelete: _existing == null ? null : _delete,
      children: [
        AppTextField(
          label: 'Name',
          hint: 'Push day',
          initialValue: _name,
          onChanged: (v) => setState(() => _name = v),
        ),
        StepperField(
          label: 'About',
          value: _minutes,
          min: 10,
          max: 180,
          step: 5,
          unit: 'min',
          onChanged: (v) => setState(() => _minutes = v),
        ),
        SectionHeader(title: 'Exercises', action: 'Add', onAction: _edit),
        if (_exercises.isEmpty)
          Text('Add at least one exercise.', style: context.text.body.tint(c.textSecondary))
        else
          AppCard(
            padding: 0,
            child: ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              onReorderItem: (from, to) => setState(() => _exercises.insert(to, _exercises.removeAt(from))),
              children: [
                for (var i = 0; i < _exercises.length; i++)
                  AppTile(
                    key: ValueKey(_exercises[i].id),
                    title: _exercises[i].name,
                    subtitle:
                        '${_exercises[i].sets} × ${_exercises[i].reps}'
                        '${_exercises[i].weightKg > 0 ? ' · ${formatKg(_exercises[i].weightKg)} kg' : ''}',
                    onTap: () => _edit(i),
                    leading: ReorderableDragStartListener(
                      index: i,
                      child: Icon(Icons.drag_indicator_rounded, color: c.textSecondary),
                    ),
                    trailing: IconButton(
                      tooltip: 'Remove',
                      icon: Icon(Icons.close_rounded, color: c.textSecondary),
                      onPressed: () => setState(() => _exercises.removeAt(i)),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
