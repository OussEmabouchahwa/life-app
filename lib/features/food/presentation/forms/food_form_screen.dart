import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/stored_list_controller.dart';
import '../../../../core/ui.dart';
import '../../application/food_diary_controller.dart';
import '../../domain/food_models.dart';

/// Create (or edit) a food with its values per 100 g, from the package label.
class FoodFormScreen extends ConsumerStatefulWidget {
  const FoodFormScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<FoodFormScreen> createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends ConsumerState<FoodFormScreen> {
  late final Food? _existing = widget.id == null
      ? null
      : ref.read(customFoodsProvider.notifier).byId(widget.id!);
  late String _name = _existing?.name ?? '';
  late double? _kcal = _existing?.per100g.kcal;
  late double? _protein = _existing?.per100g.protein ?? 0;
  late double? _carbs = _existing?.per100g.carbs ?? 0;
  late double? _fat = _existing?.per100g.fat ?? 0;
  late String _portionLabel = _existing?.portionLabel ?? '';
  late double? _portionGrams = _existing?.portionGrams;

  bool get _valid =>
      _name.trim().isNotEmpty && _kcal != null && _protein != null && _carbs != null && _fat != null;

  @override
  Widget build(BuildContext context) => FormPage(
    title: _existing == null ? 'New food' : 'Edit food',
    eyebrow: 'Values per 100 g',
    canSave: _valid,
    onSave: () => ref
        .read(customFoodsProvider.notifier)
        .save(
          Food(
            id: _existing?.id ?? newId(),
            name: _name.trim(),
            per100g: Macros(kcal: _kcal!, protein: _protein!, carbs: _carbs!, fat: _fat!),
            portionLabel: _portionGrams == null
                ? null
                : (_portionLabel.trim().isEmpty ? '1 portion' : _portionLabel),
            portionGrams: _portionGrams,
            barcode: _existing?.barcode,
            custom: true,
          ),
        ),
    deleteWhat: 'this food',
    onDelete: _existing == null ? null : () => ref.read(customFoodsProvider.notifier).remove(_existing.id),
    children: [
      AppTextField(
        label: 'Name',
        hint: 'Mloukhia',
        initialValue: _name,
        autofocus: _existing == null,
        onChanged: (v) => setState(() => _name = v),
      ),
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
      FormSection(
        title: 'Usual portion (optional)',
        children: [
          FormRow(
            children: [
              AppTextField(
                label: 'Name',
                hint: '1 bowl',
                initialValue: _portionLabel,
                onChanged: (v) => _portionLabel = v,
              ),
              NumberField(
                label: 'Weight',
                suffix: 'g',
                value: _portionGrams,
                onChanged: (v) => setState(() => _portionGrams = v),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
