import 'package:flutter/foundation.dart';

import '../../../core/storage/stored_list_controller.dart';

enum MealType {
  breakfast('Breakfast'),
  lunch('Lunch'),
  snack('Snack'),
  dinner('Dinner'),
  suhoor('Suhoor'),
  iftar('Iftar');

  const MealType(this.label);
  final String label;

  static const standard = [breakfast, lunch, snack, dinner];
  static const ramadan = [suhoor, iftar, snack];
}

enum FoodMode { standard, ramadan }

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

  Map<String, dynamic> toJson() => {'kcal': kcal, 'p': protein, 'c': carbs, 'f': fat};

  factory Macros.fromJson(Map<String, dynamic> j) => Macros(
    kcal: Json.toDouble(j['kcal']),
    protein: Json.toDouble(j['p']),
    carbs: Json.toDouble(j['c']),
    fat: Json.toDouble(j['f']),
  );
}

/// A food with nutrition per 100 g, and optionally a usual portion.
@immutable
class Food implements Stored {
  const Food({
    required this.id,
    required this.name,
    required this.per100g,
    this.portionLabel,
    this.portionGrams,
    this.barcode,
    this.custom = false,
  });

  @override
  final String id;
  final String name;
  final Macros per100g;

  /// "1 plate", "1 medium"
  final String? portionLabel;
  final double? portionGrams;
  final String? barcode;

  /// Created by the user (or scanned) rather than built in.
  final bool custom;

  Macros forGrams(double grams) => per100g * (grams / 100);
  double get defaultGrams => portionGrams ?? 100;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'per100g': per100g.toJson(),
    'portionLabel': portionLabel,
    'portionGrams': portionGrams,
    'barcode': barcode,
  };

  factory Food.fromJson(Map<String, dynamic> j) => Food(
    id: j['id'] as String,
    name: j['name'] as String,
    per100g: Macros.fromJson(j['per100g'] as Map<String, dynamic>),
    portionLabel: j['portionLabel'] as String?,
    portionGrams: Json.toDoubleOrNull(j['portionGrams']),
    barcode: j['barcode'] as String?,
    custom: true,
  );
}

/// One food eaten at a meal.
@immutable
class MealEntry implements Stored {
  const MealEntry({
    required this.id,
    required this.type,
    required this.description,
    required this.time,
    required this.macros,
    this.grams,
  });

  @override
  final String id;
  final MealType type;

  /// Food name ("Couscous with fish").
  final String description;
  final DateTime time;
  final Macros macros;
  final double? grams;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'description': description,
    'time': Json.date(time),
    'macros': macros.toJson(),
    'grams': grams,
  };

  factory MealEntry.fromJson(Map<String, dynamic> j) => MealEntry(
    id: j['id'] as String,
    type: MealType.values.byName(j['type'] as String),
    description: j['description'] as String,
    time: Json.toDate(j['time']),
    macros: Macros.fromJson(j['macros'] as Map<String, dynamic>),
    grams: Json.toDoubleOrNull(j['grams']),
  );
}
