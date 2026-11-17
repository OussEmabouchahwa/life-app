import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui.dart';
import '../../application/study_providers.dart';

/// Weekly revision hours for every course (0 = no goal).
class RevisionGoalsScreen extends ConsumerStatefulWidget {
  const RevisionGoalsScreen({super.key});

  @override
  ConsumerState<RevisionGoalsScreen> createState() => _RevisionGoalsScreenState();
}

class _RevisionGoalsScreenState extends ConsumerState<RevisionGoalsScreen> {
  late final Map<String, int> _hours = {
    for (final s in ref.read(subjectsProvider)) s.id: 0,
    for (final g in ref.read(revisionGoalsProvider)) g.id: g.hoursPerWeek.round(),
  };

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectsProvider);
    final total = _hours.values.fold(0, (s, h) => s + h);
    return FormPage(
      title: 'Weekly goals',
      eyebrow: 'Study · Revision · $total h per week',
      onSave: () => ref.read(revisionGoalsProvider.notifier).setAll({
        for (final e in _hours.entries) e.key: e.value.toDouble(),
      }),
      children: [
        Text(
          'Hours of revision per week. Tick your study sessions in the plan and they count here.',
          style: context.text.body.tint(context.colors.textSecondary),
        ),
        for (final s in subjects)
          StepperField(
            label: s.name,
            value: _hours[s.id] ?? 0,
            max: 30,
            unit: 'h',
            onChanged: (v) => setState(() => _hours[s.id] = v),
          ),
      ],
    );
  }
}
