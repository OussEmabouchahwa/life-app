import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui.dart';
import '../application/add_meal_controller.dart';
import '../data/food_repository.dart';
import '../domain/food_models.dart';
import 'widgets/food_search_field.dart';
import 'widgets/selected_food_card.dart';

/// Search text, kept here because only this screen uses it.
final _foodQueryProvider = NotifierProvider.autoDispose<_FoodQuery, String>(_FoodQuery.new);

class _FoodQuery extends Notifier<String> {
  @override
  String build() => '';

  void set(String q) => state = q.trim().toLowerCase();
}

final _foodResultsProvider = Provider.autoDispose<List<Food>>((ref) {
  final q = ref.watch(_foodQueryProvider);
  final all = ref.watch(foodRepositoryProvider).catalogue();
  return q.isEmpty ? all.skip(1).toList() : all.where((f) => f.name.toLowerCase().contains(q)).toList();
});

/// Figma 10 · Add meal.
class AddMealScreen extends ConsumerWidget {
  const AddMealScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final s = ref.watch(addMealProvider);
    final ctrl = ref.read(addMealProvider.notifier);
    final query = ref.watch(_foodQueryProvider);

    return AppPage(
      bottom: AppButton(
        label: 'Add ${s.macros.kcal.round()} kcal to ${s.type.label.toLowerCase()}',
        icon: AppIcons.check,
        onPressed: () {
          ctrl.confirm();
          Navigator.of(context).pop();
        },
      ),
      children: [
        ScreenHeader(eyebrow: '${s.type.label} · Today', title: 'Add meal', showBack: true),
        ChoicePillRow<MealType>(
          values: MealType.values,
          selected: s.type,
          labelOf: (t) => t.label,
          onChanged: ctrl.setType,
          spacing: 6,
        ),
        FoodSearchField(onChanged: ref.read(_foodQueryProvider.notifier).set),
        SelectedFoodCard(
          food: s.food,
          grams: s.grams,
          onMinus: () => ctrl.changeGrams(-1),
          onPlus: () => ctrl.changeGrams(1),
        ),
        SectionHeader(title: query.isEmpty ? 'Recent' : 'Results'),
        AppCard(
          padding: 0,
          child: DividedColumn(
            children: [
              for (final f in ref.watch(_foodResultsProvider))
                AppTile(
                  title: f.name,
                  subtitle: f.portionGrams == null
                      ? '100 g · ${f.per100g.kcal.round()} kcal'
                      : '${f.portionLabel} · ${f.forGrams(f.portionGrams!).kcal.round()} kcal',
                  onTap: () => ctrl.selectFood(f),
                  trailing: Icon(AppIcons.plus, color: c.brand, size: context.dp(AppSizes.icon)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
