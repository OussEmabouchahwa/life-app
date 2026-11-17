import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/stored_list_controller.dart';
import '../domain/food_models.dart';

/// Every meal entry, all days.
class FoodDiaryController extends StoredListController<MealEntry> {
  @override
  String get storageKey => 'food_diary_v1';

  @override
  MealEntry fromJson(Map<String, dynamic> json) => MealEntry.fromJson(json);
}

/// Foods the user created or scanned.
class CustomFoodsController extends StoredListController<Food> {
  @override
  String get storageKey => 'custom_foods_v1';

  @override
  Food fromJson(Map<String, dynamic> json) => Food.fromJson(json);
}

/// Food preferences: daily targets, mode, water goal. One document.
class FoodSettings {
  const FoodSettings({
    this.goal = const Macros(kcal: 2200, protein: 130, carbs: 250, fat: 70),
    this.mode = FoodMode.standard,
    this.waterGlasses = 8,
  });

  final Macros goal;
  final FoodMode mode;
  final int waterGlasses;

  FoodSettings copyWith({Macros? goal, FoodMode? mode, int? waterGlasses}) => FoodSettings(
    goal: goal ?? this.goal,
    mode: mode ?? this.mode,
    waterGlasses: waterGlasses ?? this.waterGlasses,
  );

  Map<String, dynamic> toJson() => {'goal': goal.toJson(), 'mode': mode.name, 'water': waterGlasses};

  factory FoodSettings.fromJson(Map<String, dynamic> j) => FoodSettings(
    goal: Macros.fromJson(j['goal'] as Map<String, dynamic>),
    mode: FoodMode.values.byName(j['mode'] as String? ?? 'standard'),
    waterGlasses: j['water'] as int? ?? 8,
  );
}

class FoodSettingsController extends Notifier<FoodSettings> {
  static const _key = 'food_settings_v1';

  @override
  FoodSettings build() {
    final json = ref.watch(localStoreProvider).readMap(_key);
    return json == null ? const FoodSettings() : FoodSettings.fromJson(json);
  }

  void update(FoodSettings s) {
    state = s;
    ref.read(localStoreProvider).writeMap(_key, s.toJson());
  }

  void setMode(FoodMode m) => update(state.copyWith(mode: m));
}

/// Glasses of water per day ("2026-11-17" → 5).
class WaterController extends Notifier<Map<String, int>> {
  static const _key = 'water_v1';

  @override
  Map<String, int> build() => {
    for (final e in (ref.watch(localStoreProvider).readMap(_key) ?? const {}).entries) e.key: e.value as int,
  };

  static String keyOf(DateTime d) => d.toIso8601String().substring(0, 10);

  void set(DateTime day, int glasses) {
    state = {...state, keyOf(day): glasses};
    ref.read(localStoreProvider).writeMap(_key, state);
  }
}
