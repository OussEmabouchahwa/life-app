import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../application/food_diary_controller.dart';
import '../domain/food_models.dart';
import 'widgets/calories_card.dart';
import 'widgets/meal_row.dart';

/// Figma 09 · Food.
class FoodScreen extends ConsumerWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final goal = ref.watch(nutritionGoalProvider).target;
    final byType = ref.watch(mealsByTypeProvider);
    void addMeal() => context.push(Routes.addMeal);

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: DateFormat('EEEE · d MMM', locale).format(DateTime.now()),
          title: 'Food',
          trailing: SoftTag(label: 'Goal ${NumberFormat.decimalPattern(locale).format(goal.kcal)} kcal'),
        ),
        CaloriesCard(eaten: ref.watch(eatenTodayProvider), goal: goal),
        const SectionHeader(title: 'Meals', action: 'Today'),
        AppCard(
          padding: 0,
          child: DividedColumn(
            children: [
              for (final t in MealType.values) MealRow(type: t, entries: byType[t]!, onAdd: addMeal),
            ],
          ),
        ),
        AppButton(label: 'Add meal', icon: AppIcons.plus, onPressed: addMeal),
      ],
    );
  }
}
