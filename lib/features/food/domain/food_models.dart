import 'package:flutter/foundation.dart';

enum MealType {
  breakfast('Breakfast'),
  lunch('Lunch'),
  snack('Snack'),
  dinner('Dinner');

  const MealType(this.label);
  final String label;
}

@immutable
class Macros {
  const Macros({this.kcal = 0, this.protein = 0, this.carbs = 0, this.fat = 0});

  final double kcal;
  final double protein;
  final double carbs;
  final double fat;

  Macros operator +(Macros o) =>
      Macros(kcal: kcal + o.kcal, protein: protein + o.protein, carbs: carbs + o.carbs, fat: fat + o.fat);

  Macros operator *(double f) => Macros(kcal: kcal * f, protein: protein * f, carbs: carbs * f, fat: fat * f);
}

/// A food with nutrition per 100 g (or per portion when [portionGrams] is set).
@immutable
class Food {
  const Food({required this.name, required this.per100g, this.portionLabel, this.portionGrams});

  final String name;
  final Macros per100g;

  /// "1 plate", "1 medium"
  final String? portionLabel;
  final double? portionGrams;

  Macros forGrams(double grams) => per100g * (grams / 100);
}

@immutable
class MealEntry {
  const MealEntry({required this.type, required this.description, required this.time, required this.macros});

  final MealType type;

  /// "Eggs, bread, olive oil"
  final String description;
  final DateTime time;
  final Macros macros;
}

@immutable
class NutritionGoal {
  const NutritionGoal(this.target);

  final Macros target;
}
