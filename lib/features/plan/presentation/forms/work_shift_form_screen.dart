import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/stored_list_controller.dart';
import '../../../../core/ui.dart';
import '../../application/plan_controller.dart';
import '../../data/work_shifts.dart';

/// Add or edit a weekly work shift.
class WorkShiftFormScreen extends ConsumerStatefulWidget {
  const WorkShiftFormScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<WorkShiftFormScreen> createState() => _WorkShiftFormScreenState();
}

class _WorkShiftFormScreenState extends ConsumerState<WorkShiftFormScreen> {
  late final WorkShift? _existing = widget.id == null
      ? null
      : ref.read(workShiftsProvider.notifier).byId(widget.id!);
  late int _weekday = _existing?.weekday ?? DateTime.saturday;
  late int _start = _existing?.startMinutes ?? 9 * 60;
  late int _end = _existing?.endMinutes ?? 15 * 60;
  late String _place = _existing?.place ?? '';

  @override
  Widget build(BuildContext context) {
    final length = (_end - _start) % (24 * 60);
    return FormPage(
      title: _existing == null ? 'Add work shift' : 'Edit work shift',
      eyebrow: 'Repeats every week',
      canSave: length > 0,
      onSave: () => ref
          .read(workShiftsProvider.notifier)
          .save(
            WorkShift(
              id: _existing?.id ?? newId(),
              weekday: _weekday,
              startMinutes: _start,
              endMinutes: _end,
              place: _place.trim(),
            ),
          ),
      deleteWhat: 'this shift',
      onDelete: _existing == null ? null : () => ref.read(workShiftsProvider.notifier).remove(_existing.id),
      children: [
        PickerField<int>(
          label: 'Day',
          value: _weekday,
          options: const [1, 2, 3, 4, 5, 6, 7],
          labelOf: (d) => WorkShift.dayNames[d - 1],
          onChanged: (d) => setState(() => _weekday = d),
        ),
        FormRow(
          children: [
            TimeField(label: 'Starts', minutes: _start, onChanged: (m) => setState(() => _start = m)),
            TimeField(label: 'Ends', minutes: _end, onChanged: (m) => setState(() => _end = m)),
          ],
        ),
        Text(
          length > 0
              ? 'Length ${TimeFormat.length(Duration(minutes: length))}'
              : 'The shift must last some time.',
          style: context.text.bodySmall.tint(
            length > 0 ? context.colors.textSecondary : context.colors.danger,
          ),
        ),
        AppTextField(label: 'Place', hint: 'Café, shop…', initialValue: _place, onChanged: (v) => _place = v),
      ],
    );
  }
}
