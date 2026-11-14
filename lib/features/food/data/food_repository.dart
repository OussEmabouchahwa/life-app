import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/time_format.dart';
import '../domain/food_models.dart';

final foodRepositoryProvider = Provider<FoodRepository>((ref) => const FoodRepository());

/// Food catalogue and today's meals from the design.
class FoodRepository {
  const FoodRepository();

  NutritionGoal goal() => const NutritionGoal(Macros(kcal: 2300, protein: 150, carbs: 260, fat: 70));

  List<MealEntry> mealsOf(DateTime day) => [
    MealEntry(
      type: MealType.breakfast,
      description: 'Eggs, bread, olive oil',
      time: day.at(7, 10),
      macros: const Macros(kcal: 420, protein: 22, carbs: 38, fat: 19),
    ),
    MealEntry(
      type: MealType.lunch,
      description: 'Couscous with fish',
      time: day.at(12, 40),
      macros: const Macros(kcal: 780, protein: 52, carbs: 105, fat: 18),
    ),
    MealEntry(
      type: MealType.snack,
      description: 'Yogurt and banana',
      time: day.at(16),
      macros: const Macros(kcal: 190, protein: 8, carbs: 34, fat: 3),
    ),
  ];

  List<Food> catalogue() => const [
    Food(name: 'Grilled chicken breast', per100g: Macros(kcal: 165, protein: 31, carbs: 0, fat: 3.6)),
    Food(
      name: 'Couscous with fish',
      per100g: Macros(kcal: 130, protein: 9, carbs: 17, fat: 3),
      portionLabel: '1 plate',
      portionGrams: 400,
    ),
    Food(
      name: 'Lablabi',
      per100g: Macros(kcal: 95, protein: 5, carbs: 14, fat: 2.5),
      portionLabel: '1 bowl',
      portionGrams: 400,
    ),
    Food(
      name: 'Banana',
      per100g: Macros(kcal: 89, protein: 1.1, carbs: 23, fat: 0.3),
      portionLabel: '1 medium',
      portionGrams: 118,
    ),
  ];
}
