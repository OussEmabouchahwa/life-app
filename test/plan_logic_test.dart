import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/core/storage/local_store.dart';
import 'package:nizam/features/plan/application/add_event_controller.dart';
import 'package:nizam/features/plan/application/plan_controller.dart';
import 'package:nizam/features/prayers/domain/prayer.dart';
import 'package:nizam/features/training/application/training_providers.dart';
import 'package:nizam/features/training/application/workout_session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Container with empty on-device storage.
Future<ProviderContainer> _container() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
  addTearDown(c.dispose);
  return c;
}

void main() {
  const args = (id: null, category: null);

  test('an event at 15:00 for 90 min clashes with Asr; moving clears it', () async {
    final c = await _container();
    final sub = c.listen(addEventConflictProvider(args), (_, _) {});
    // Asr in Tunis is between 14:30 and 16:15 all year, so 15:00 + 90 min always overlaps.
    final conflict = c.read(addEventConflictProvider(args));
    expect(conflict?.prayer, Prayer.asr);

    c.read(addEventProvider(args).notifier).moveAfter(conflict!);
    expect(c.read(addEventConflictProvider(args)), isNull);
    sub.close();
  });

  test('"Keep anyway" hides the conflict until the time changes', () async {
    final c = await _container();
    final sub = c.listen(addEventConflictProvider(args), (_, _) {});
    final ctrl = c.read(addEventProvider(args).notifier)..keepAnyway();
    expect(c.read(addEventConflictProvider(args)), isNull);
    ctrl.setStart(15 * 60 + 10);
    expect(c.read(addEventConflictProvider(args)), isNotNull);
    sub.close();
  });

  test('a weekly event creates one saved copy per week', () async {
    final c = await _container();
    final sub = c.listen(addEventProvider(args), (_, _) {});
    c.read(addEventProvider(args).notifier)
      ..setTitle('Revision')
      ..setRepeat(3)
      ..save();
    final events = c.read(personalEventsProvider);
    expect(events, hasLength(4));
    expect(events.last.start.difference(events.first.start).inDays, 21);
    sub.close();
  });

  test('logging all sets moves on, and Finish saves the session', () async {
    final c = await _container();
    final provider = workoutSessionProvider('push');
    final sub = c.listen(provider, (_, _) {});
    final ctrl = c.read(provider.notifier);

    final sets = c.read(provider).exercise.sets;
    for (var i = 0; i < sets; i++) {
      ctrl.logSet();
    }
    final s = c.read(provider);
    expect(s.exerciseIndex, 1);
    expect(s.isComplete(0), isTrue);

    expect(ctrl.finish(), isTrue);
    final history = c.read(workoutHistoryProvider);
    expect(history.single.setCount, sets);
    expect(c.read(lastBestSetProvider)['Bench press'], isNotNull);
    sub.close();
  });
}
