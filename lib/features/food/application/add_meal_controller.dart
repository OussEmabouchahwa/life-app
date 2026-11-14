import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/food_repository.dart';
import '../domain/food_models.dart';
import 'food_diary_controller.dart';

@immutable
class AddMealState {
  const AddMealState({required this.type, required this.food, required this.grams});

  final MealType type;
  final Food food;
  final double grams;

  Macros get macros => food.forGrams(grams);

  AddMealState copyWith({MealType? type, Food? food, double? grams}) =>
      AddMealState(type: type ?? this.type, food: food ?? this.food, grams: grams ?? this.grams);
}

final addMealProvider = NotifierProvider.autoDispose<AddMealController, AddMealState>(AddMealController.new);

class AddMealController extends Notifier<AddMealState> {
  static const gramStep = 10.0;

  @override
  AddMealState build() {
    // Preselect the first meal type that is not logged yet (dinner in the design).
    final byType = ref.read(mealsByTypeProvider);
    final type = MealType.values.firstWhere((t) => byType[t]!.isEmpty, orElse: () => MealType.snack);
    return AddMealState(type: type, food: ref.read(foodRepositoryProvider).catalogue().first, grams: 150);
  }

  void setType(MealType t) => state = state.copyWith(type: t);

  void changeGrams(int direction) =>
      state = state.copyWith(grams: (state.grams + direction * gramStep).clamp(gramStep, 2000).toDouble());

  void selectFood(Food f) => state = state.copyWith(food: f, grams: f.portionGrams ?? 100);

  void confirm() => ref
      .read(foodDiaryProvider.notifier)
      .add(
        MealEntry(type: state.type, description: state.food.name, time: DateTime.now(), macros: state.macros),
      );
}
