import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/food_repository.dart';
import '../domain/food_models.dart';

/// Meals logged today.
final foodDiaryProvider = NotifierProvider<FoodDiaryController, List<MealEntry>>(FoodDiaryController.new);

class FoodDiaryController extends Notifier<List<MealEntry>> {
  @override
  List<MealEntry> build() => ref.read(foodRepositoryProvider).mealsOf(DateTime.now());

  void add(MealEntry entry) => state = [...state, entry];
}

final nutritionGoalProvider = Provider<NutritionGoal>((ref) => ref.watch(foodRepositoryProvider).goal());

/// Sum of everything eaten today.
final eatenTodayProvider = Provider<Macros>(
  (ref) => ref.watch(foodDiaryProvider).fold(const Macros(), (sum, m) => sum + m.macros),
);

/// Meals of one type (several snacks are merged into one row).
final mealsByTypeProvider = Provider<Map<MealType, List<MealEntry>>>((ref) {
  final meals = ref.watch(foodDiaryProvider);
  return {for (final t in MealType.values) t: meals.where((m) => m.type == t).toList()};
});
