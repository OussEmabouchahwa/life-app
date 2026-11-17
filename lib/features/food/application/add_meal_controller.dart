import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/stored_list_controller.dart';
import '../domain/food_models.dart';
import 'food_diary_controller.dart';

@immutable
class AddMealState {
  const AddMealState({required this.type, required this.food, required this.grams, this.query = ''});

  final MealType type;
  final Food? food;
  final double grams;
  final String query;

  Macros get macros => food?.forGrams(grams) ?? const Macros();

  AddMealState copyWith({MealType? type, Food? food, double? grams, String? query}) => AddMealState(
    type: type ?? this.type,
    food: food ?? this.food,
    grams: grams ?? this.grams,
    query: query ?? this.query,
  );
}

/// The form of "Add meal". `foodId` preselects a food (after a scan).
final addMealProvider = NotifierProvider.autoDispose.family<AddMealController, AddMealState, String?>(
  AddMealController.new,
);

class AddMealController extends Notifier<AddMealState> {
  AddMealController(this.foodId);

  final String? foodId;
  static const gramStep = 10.0;

  @override
  AddMealState build() {
    final mode = ref.read(foodSettingsProvider).mode;
    final types = mode == FoodMode.ramadan ? MealType.ramadan : MealType.standard;
    final byType = ref.read(mealsByTypeProvider);
    final type = types.firstWhere((t) => byType[t]!.isEmpty, orElse: () => MealType.snack);
    final food = foodId == null ? null : ref.read(allFoodsProvider).where((f) => f.id == foodId).firstOrNull;
    return AddMealState(type: type, food: food, grams: food?.defaultGrams ?? 100);
  }

  void setType(MealType t) => state = state.copyWith(type: t);
  void setQuery(String q) => state = state.copyWith(query: q);

  void changeGrams(int direction) =>
      state = state.copyWith(grams: (state.grams + direction * gramStep).clamp(gramStep, 2000).toDouble());

  void selectFood(Food f) => state = state.copyWith(food: f, grams: f.defaultGrams);

  void confirm() {
    final food = state.food;
    if (food == null) return;
    ref
        .read(foodDiaryProvider.notifier)
        .save(
          MealEntry(
            id: newId(),
            type: state.type,
            description: food.name,
            time: DateTime.now(),
            macros: state.macros,
            grams: state.grams,
          ),
        );
  }
}
