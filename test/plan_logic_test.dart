import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/features/food/domain/food_models.dart';
import 'package:nizam/features/food/data/food_repository.dart';
import 'package:nizam/features/plan/application/add_event_controller.dart';
import 'package:nizam/features/prayers/domain/prayer.dart';
import 'package:nizam/features/training/application/workout_session_controller.dart';

void main() {
  test('Add event at 15:00 for 90 min clashes with Asr, moving clears it', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final sub = container.listen(addEventConflictProvider, (_, _) {});

    final conflict = container.read(addEventConflictProvider);
    expect(conflict?.prayer, Prayer.asr);

    container.read(addEventProvider.notifier).moveAfter(conflict!);
    expect(container.read(addEventProvider).startMinutes, 15 * 60 + 45);
    expect(container.read(addEventConflictProvider), isNull);
    sub.close();
  });

  test('Keep anyway hides the conflict until the time changes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final sub = container.listen(addEventConflictProvider, (_, _) {});

    final ctrl = container.read(addEventProvider.notifier)..keepAnyway();
    expect(container.read(addEventConflictProvider), isNull);
    ctrl.setStart(15 * 60 + 10);
    expect(container.read(addEventConflictProvider), isNotNull);
    sub.close();
  });

  test('150 g chicken is 248 kcal (Add meal design)', () {
    final chicken = const FoodRepository().catalogue().first;
    expect(chicken.forGrams(150).kcal.round(), 248);
  });

  test('Macros add up', () {
    const a = Macros(kcal: 1, protein: 2, carbs: 3, fat: 4);
    final sum = a + a;
    expect([sum.kcal, sum.protein, sum.carbs, sum.fat], [2, 4, 6, 8]);
  });

  test('Logging all sets moves on to the next exercise', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final sub = container.listen(workoutSessionProvider, (_, _) {});
    final ctrl = container.read(workoutSessionProvider.notifier);

    final sets = container.read(workoutSessionProvider).exercise.sets;
    for (var i = 0; i < sets; i++) {
      ctrl.logSet();
    }
    final s = container.read(workoutSessionProvider);
    expect(s.exerciseIndex, 1);
    expect(s.logged, isEmpty);
    expect(s.restLeft, WorkoutSessionController.defaultRest);
    sub.close();
  });
}
