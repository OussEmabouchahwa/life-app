import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';
import '../../application/training_providers.dart';
import '../../domain/training_models.dart';

/// Weekly split (which workout each day), usual gym time, and the workouts.
class ProgrammeScreen extends ConsumerStatefulWidget {
  const ProgrammeScreen({super.key});

  @override
  ConsumerState<ProgrammeScreen> createState() => _ProgrammeScreenState();
}

class _ProgrammeScreenState extends ConsumerState<ProgrammeScreen> {
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  static const _rest = '';

  late final TrainingProgramme _initial = ref.read(programmeProvider);
  late final Map<int, String> _split = {..._initial.split};
  late int _gymMinutes = _initial.gymMinutes;

  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(workoutsProvider);
    final ids = [_rest, for (final w in workouts) w.id];
    String nameOf(String id) => id == _rest ? 'Rest' : workouts.firstWhere((w) => w.id == id).name;

    return FormPage(
      title: 'Programme',
      eyebrow: 'Training',
      onSave: () => ref
          .read(programmeProvider.notifier)
          .update(
            TrainingProgramme(
              split: {
                for (final e in _split.entries)
                  if (workouts.any((w) => w.id == e.value)) e.key: e.value,
              },
              gymMinutes: _gymMinutes,
            ),
          ),
      children: [
        FormSection(
          title: 'Week',
          children: [
            for (var d = 1; d <= 7; d++)
              PickerField<String>(
                label: _days[d - 1],
                value: _split[d] ?? _rest,
                options: ids,
                labelOf: nameOf,
                onChanged: (id) => setState(() => id == _rest ? _split.remove(d) : _split[d] = id),
              ),
          ],
        ),
        TimeField(
          label: 'Usual gym time',
          minutes: _gymMinutes,
          onChanged: (m) => setState(() => _gymMinutes = m),
        ),
        SectionHeader(title: 'Workouts', action: 'New', onAction: () => context.push(Routes.workoutForm)),
        AppCard(
          padding: 0,
          child: DividedColumn(
            children: [
              for (final w in workouts)
                ValueTile(
                  title: w.name,
                  value: '${w.exercises.length} exercises',
                  onTap: () => context.push(Routes.withId(Routes.workoutForm, w.id)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
