import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui.dart';
import '../../application/workout_session_controller.dart';
import '../../domain/training_models.dart';
import 'value_stepper.dart';

/// SET 3 OF 4 with the weight / reps steppers and "Log set".
class CurrentSetCard extends ConsumerWidget {
  const CurrentSetCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(workoutSessionProvider);
    final ctrl = ref.read(workoutSessionProvider.notifier);
    final e = s.exercise;
    final finished = s.currentSet >= e.sets;

    return AppCard(
      padding: 17,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Eyebrow(finished ? 'All sets done' : 'Set ${s.currentSet + 1} of ${e.sets}')),
              Text(
                'Last week: ${formatKg(e.lastWeekKg)} kg × ${e.reps}',
                style: context.text.caption.tint(context.colors.textSecondary),
              ),
            ],
          ),
          const VGap(12),
          Row(
            children: [
              Expanded(
                child: ValueStepper(
                  label: 'Weight',
                  value: formatKg(s.weightKg),
                  unit: 'kg',
                  onMinus: () => ctrl.changeWeight(-1),
                  onPlus: () => ctrl.changeWeight(1),
                ),
              ),
              const HGap(12),
              Expanded(
                child: ValueStepper(
                  label: 'Reps',
                  value: '${s.reps}',
                  unit: 'reps',
                  onMinus: () => ctrl.changeReps(-1),
                  onPlus: () => ctrl.changeReps(1),
                ),
              ),
            ],
          ),
          const VGap(14),
          AppButton(
            label: finished ? 'Workout complete' : 'Log set ${s.currentSet + 1}',
            icon: AppIcons.check,
            variant: AppButtonVariant.brand,
            onPressed: finished ? null : ctrl.logSet,
          ),
        ],
      ),
    );
  }
}
