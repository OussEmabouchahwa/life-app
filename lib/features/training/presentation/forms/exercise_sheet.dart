import 'package:flutter/material.dart';

import '../../../../core/storage/stored_list_controller.dart';
import '../../../../core/ui.dart';
import '../../domain/training_models.dart';

/// Add or edit one exercise in a sheet. Returns null when dismissed.
Future<Exercise?> showExerciseSheet(BuildContext context, {Exercise? initial}) =>
    showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: context.colors.bgCard,
      builder: (_) => _ExerciseSheet(initial: initial),
    );

class _ExerciseSheet extends StatefulWidget {
  const _ExerciseSheet({this.initial});

  final Exercise? initial;

  @override
  State<_ExerciseSheet> createState() => _ExerciseSheetState();
}

class _ExerciseSheetState extends State<_ExerciseSheet> {
  late String _name = widget.initial?.name ?? '';
  late int _sets = widget.initial?.sets ?? 3;
  late int _reps = widget.initial?.reps ?? 10;
  late double? _kg = widget.initial?.weightKg ?? 0;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsDirectional.fromSTEB(
      context.dp(22),
      0,
      context.dp(22),
      MediaQuery.viewInsetsOf(context).bottom + context.dp(22),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.initial == null ? 'Add exercise' : 'Edit exercise', style: context.text.title),
        const VGap(12),
        AppTextField(
          label: 'Name',
          hint: 'Bench press',
          initialValue: _name,
          autofocus: widget.initial == null,
          onChanged: (v) => setState(() => _name = v),
        ),
        const VGap(8),
        StepperField(
          label: 'Sets',
          value: _sets,
          min: 1,
          max: 10,
          onChanged: (v) => setState(() => _sets = v),
        ),
        const VGap(8),
        StepperField(
          label: 'Reps',
          value: _reps,
          min: 1,
          max: 50,
          onChanged: (v) => setState(() => _reps = v),
        ),
        const VGap(8),
        NumberField(
          label: 'Weight (0 for body weight)',
          suffix: 'kg',
          value: _kg,
          onChanged: (v) => setState(() => _kg = v),
        ),
        const VGap(14),
        AppButton(
          label: 'Save exercise',
          onPressed: _name.trim().isEmpty || _kg == null
              ? null
              : () => Navigator.pop(
                  context,
                  Exercise(
                    id: widget.initial?.id ?? newId(),
                    name: _name.trim(),
                    sets: _sets,
                    reps: _reps,
                    weightKg: _kg!,
                  ),
                ),
        ),
      ],
    ),
  );
}
