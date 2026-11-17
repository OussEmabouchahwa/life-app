import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/time_format.dart';
import '../data/food_catalogue.dart';
import '../data/food_repository.dart';
import '../domain/food_models.dart';

final foodDiaryProvider = NotifierProvider<FoodDiaryController, List<MealEntry>>(FoodDiaryController.new);

final customFoodsProvider = NotifierProvider<CustomFoodsController, List<Food>>(CustomFoodsController.new);

final foodSettingsProvider = NotifierProvider<FoodSettingsController, FoodSettings>(
  FoodSettingsController.new,
);

final waterProvider = NotifierProvider<WaterController, Map<String, int>>(WaterController.new);

/// Custom foods first (most likely to be eaten again), then the built-in list.
final allFoodsProvider = Provider<List<Food>>(
  (ref) => [...ref.watch(customFoodsProvider).reversed, ...FoodCatalogue.all],
);

/// Today's entries.
final todayMealsProvider = Provider<List<MealEntry>>((ref) {
  final today = ref.watch(nowProvider);
  return [
    for (final m in ref.watch(foodDiaryProvider))
      if (m.time.isSameDay(today)) m,
  ];
});

/// Sum of everything eaten today.
final eatenTodayProvider = Provider<Macros>(
  (ref) => ref.watch(todayMealsProvider).fold(const Macros(), (sum, m) => sum + m.macros),
);

/// Today's entries grouped by meal.
final mealsByTypeProvider = Provider<Map<MealType, List<MealEntry>>>((ref) {
  final meals = ref.watch(todayMealsProvider);
  return {for (final t in MealType.values) t: meals.where((m) => m.type == t).toList()};
});

/// Foods eaten recently, most recent first, without duplicates.
final recentFoodNamesProvider = Provider<List<String>>((ref) {
  final entries = [...ref.watch(foodDiaryProvider)]..sort((a, b) => b.time.compareTo(a.time));
  return {for (final e in entries) e.description}.take(8).toList();
});

final waterTodayProvider = Provider<int>((ref) {
  final key = WaterController.keyOf(ref.watch(nowProvider));
  return ref.watch(waterProvider)[key] ?? 0;
});
