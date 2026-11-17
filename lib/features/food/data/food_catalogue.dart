import '../domain/food_models.dart';

/// Common foods in Tunisia with approximate values per 100 g (typical
/// home recipes; real values vary). Users add their own or scan barcodes.
abstract final class FoodCatalogue {
  static Food _f(
    String id,
    String name,
    double kcal,
    double p,
    double c,
    double f, [
    String? portion,
    double? grams,
  ]) => Food(
    id: 'builtin-$id',
    name: name,
    per100g: Macros(kcal: kcal, protein: p, carbs: c, fat: f),
    portionLabel: portion,
    portionGrams: grams,
  );

  static final all = <Food>[
    _f('couscous-fish', 'Couscous with fish', 130, 9, 17, 3, '1 plate', 400),
    _f('couscous-lamb', 'Couscous with lamb', 165, 8, 18, 6.5, '1 plate', 400),
    _f('lablabi', 'Lablabi', 95, 5, 14, 2.5, '1 bowl', 400),
    _f('chorba', 'Chorba frik', 70, 4, 8, 2.5, '1 bowl', 300),
    _f('brik', 'Brik à l’œuf', 290, 9, 22, 18, '1 brik', 120),
    _f('ojja', 'Ojja merguez', 160, 9, 6, 11, '1 plate', 300),
    _f('kafteji', 'Kafteji', 170, 5, 12, 11, '1 plate', 300),
    _f('makloub', 'Makloub (chicken)', 245, 12, 28, 9, '1 piece', 300),
    _f('fricassee', 'Fricassé', 280, 8, 30, 14, '1 piece', 150),
    _f('mlawi', 'Mlawi', 310, 7, 45, 11, '1 piece', 150),
    _f('baguette', 'Baguette', 270, 9, 55, 1.5, '½ baguette', 125),
    _f('tabouna', 'Tabouna bread', 260, 8, 52, 2, '1 piece', 100),
    _f('chicken', 'Grilled chicken breast', 165, 31, 0, 3.6),
    _f('fish', 'Grilled fish (dorade)', 130, 21, 0, 5),
    _f('tuna', 'Tuna in oil (drained)', 200, 26, 0, 10, '1 can', 80),
    _f('eggs', 'Eggs', 145, 12.5, 1, 10, '2 eggs', 100),
    _f('rice', 'Rice (cooked)', 130, 2.7, 28, 0.3, '1 plate', 200),
    _f('pasta', 'Pasta (cooked)', 158, 5.8, 31, 0.9, '1 plate', 250),
    _f('lentils', 'Lentils (cooked)', 116, 9, 20, 0.4, '1 bowl', 250),
    _f('salad', 'Salade tunisienne', 60, 1.2, 5, 4, '1 bowl', 200),
    _f('mechouia', 'Salade mechouia', 85, 1.5, 6, 6, '1 bowl', 150),
    _f('yogurt', 'Yogurt (plain)', 61, 3.5, 4.7, 3.3, '1 pot', 125),
    _f('leben', 'Leben', 40, 3.3, 4.8, 1, '1 glass', 250),
    _f('milk', 'Milk (semi-skimmed)', 46, 3.4, 4.8, 1.6, '1 glass', 250),
    _f('dates', 'Dates (deglet nour)', 282, 2.5, 75, 0.4, '3 dates', 30),
    _f('banana', 'Banana', 89, 1.1, 23, 0.3, '1 medium', 118),
    _f('orange', 'Orange', 47, 0.9, 12, 0.1, '1 medium', 150),
    _f('apple', 'Apple', 52, 0.3, 14, 0.2, '1 medium', 180),
    _f('olive-oil', 'Olive oil', 884, 0, 0, 100, '1 tbsp', 13),
    _f('almonds', 'Almonds', 579, 21, 22, 50, '1 handful', 30),
    _f('bsissa', 'Bsissa', 420, 14, 60, 13, '3 tbsp', 40),
    _f('zrir', 'Zrir', 480, 9, 45, 30, '1 portion', 40),
    _f('makroudh', 'Makroudh', 400, 4, 60, 16, '1 piece', 50),
    _f('coffee', 'Coffee with milk', 35, 2, 3.5, 1.3, '1 cup', 150),
  ];
}
