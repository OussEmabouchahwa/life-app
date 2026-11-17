import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui.dart';
import '../../application/food_diary_controller.dart';
import '../../domain/food_models.dart';

/// Daily calorie and macro targets, and the water goal.
class NutritionGoalsScreen extends ConsumerStatefulWidget {
  const NutritionGoalsScreen({super.key});

  @override
  ConsumerState<NutritionGoalsScreen> createState() => _NutritionGoalsScreenState();
}

class _NutritionGoalsScreenState extends ConsumerState<NutritionGoalsScreen> {
  late final _initial = ref.read(foodSettingsProvider);
  late double? _kcal = _initial.goal.kcal;
  late double? _protein = _initial.goal.protein;
  late double? _carbs = _initial.goal.carbs;
  late double? _fat = _initial.goal.fat;
  late int _water = _initial.waterGlasses;

  /// kcal coming from the macros (4 / 4 / 9 per gram).
  double get _fromMacros => (_protein ?? 0) * 4 + (_carbs ?? 0) * 4 + (_fat ?? 0) * 9;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final valid = [_kcal, _protein, _carbs, _fat].every((v) => v != null && v >= 0) && (_kcal ?? 0) > 0;
    final gap = (_kcal ?? 0) - _fromMacros;

    return FormPage(
      title: 'Daily goals',
      eyebrow: 'Food',
      canSave: valid,
      onSave: () => ref
          .read(foodSettingsProvider.notifier)
          .update(
            _initial.copyWith(
              goal: Macros(kcal: _kcal!, protein: _protein!, carbs: _carbs!, fat: _fat!),
              waterGlasses: _water,
            ),
          ),
      children: [
        NumberField(
          label: 'Calories',
          suffix: 'kcal',
          value: _kcal,
          onChanged: (v) => setState(() => _kcal = v),
        ),
        FormRow(
          children: [
            NumberField(
              label: 'Protein',
              suffix: 'g',
              value: _protein,
              onChanged: (v) => setState(() => _protein = v),
            ),
            NumberField(
              label: 'Carbs',
              suffix: 'g',
              value: _carbs,
              onChanged: (v) => setState(() => _carbs = v),
            ),
            NumberField(label: 'Fat', suffix: 'g', value: _fat, onChanged: (v) => setState(() => _fat = v)),
          ],
        ),
        Text(
          gap.abs() < 50
              ? 'Macros match the calorie goal.'
              : 'Macros give ${_fromMacros.round()} kcal, ${gap.abs().round()} ${gap > 0 ? 'under' : 'over'} the goal.',
          style: context.text.bodySmall.tint(gap.abs() < 50 ? c.textSecondary : c.accent),
        ),
        StepperField(
          label: 'Water',
          value: _water,
          min: 4,
          max: 16,
          unit: 'glasses',
          onChanged: (v) => setState(() => _water = v),
        ),
      ],
    );
  }
}
