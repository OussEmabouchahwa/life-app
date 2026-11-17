import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui.dart';
import '../../application/food_diary_controller.dart';
import '../../domain/food_models.dart';

/// Lists what was eaten at one meal, with delete.
Future<void> showMealEntriesSheet(BuildContext context, MealType type) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  backgroundColor: context.colors.bgCard,
  builder: (_) => _MealEntries(type: type),
);

class _MealEntries extends ConsumerWidget {
  const _MealEntries({required this.type});

  final MealType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final entries = ref.watch(mealsByTypeProvider)[type]!;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: context.padSym(h: 22),
            child: Text(type.label, style: context.text.title),
          ),
          if (entries.isEmpty)
            Padding(
              padding: context.padAll(22),
              child: Text('Nothing left at this meal.', style: context.text.body.tint(c.textSecondary)),
            ),
          for (final e in entries)
            AppTile(
              title: e.description,
              subtitle: [
                if (e.grams != null) '${e.grams!.round()} g',
                '${e.macros.kcal.round()} kcal',
                TimeFormat.hm(e.time),
              ].join(' · '),
              trailing: IconButton(
                tooltip: 'Delete',
                icon: Icon(Icons.delete_outline_rounded, color: c.danger),
                onPressed: () => ref.read(foodDiaryProvider.notifier).remove(e.id),
              ),
            ),
        ],
      ),
    );
  }
}
