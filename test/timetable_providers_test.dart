import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/core/providers/clock_provider.dart';
import 'package:nizam/core/storage/local_store.dart';
import 'package:nizam/features/plan/application/plan_controller.dart';
import 'package:nizam/features/timetable/application/timetable_providers.dart';
import 'package:nizam/features/timetable/data/timetable_parser.dart';
import 'package:nizam/features/timetable/data/timetable_repository.dart';
import 'package:nizam/features/timetable/domain/class_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FileRepo implements TimetableRepository {
  @override
  Future<List<ClassSession>> sessions() async =>
      TimetableParser.parse(File('assets/data/timetable.json').readAsStringSync());
}

/// Container with the real timetable and a fixed "now": Tue 10 Nov 2026, 12:00.
Future<ProviderContainer> _container() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final c = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      timetableRepositoryProvider.overrideWithValue(_FileRepo()),
      nowProvider.overrideWithValue(DateTime(2026, 11, 10, 12)),
    ],
  );
  addTearDown(c.dispose);
  await c.read(sessionsProvider.future);
  return c;
}

void main() {
  test('week numbers follow the semester start (14 Sep = week 1)', () async {
    final c = await _container();
    expect(c.read(semesterWeekProvider(DateTime(2026, 9, 14))), 1);
    expect(c.read(semesterWeekProvider(DateTime(2026, 11, 9))), 9);
    expect(c.read(semesterWeekProvider(DateTime(2027, 1, 4))), isNull);
  });

  test('a week contains its classes only', () async {
    final c = await _container();
    final week = c.read(sessionsOfWeekProvider(DateTime(2026, 11, 9)));
    expect(week, hasLength(8), reason: 'Mon 2 · Tue 2 · Wed 1 · Thu 2 · Fri 1');
    expect(week.first.title, 'Patrons de conception');
  });

  test('course progress counts past sessions and finds the next one', () async {
    final c = await _container();
    final flutter = c.read(courseProgressProvider).firstWhere((p) => p.code == 'GINF.33-2');
    expect(flutter.total, 10, reason: 'every Tuesday afternoon, 20 Oct → 22 Dec');
    expect(flutter.done, 3, reason: '20/10, 27/10, 03/11 are over at noon on 10/11');
    expect(flutter.next!.start, DateTime(2026, 11, 10, 13, 15));
  });

  test('classes appear in the day plan and can be ticked', () async {
    final c = await _container();
    final day = DateTime(2026, 11, 10);
    final classes = c.read(itemsForDayProvider(day)).where((i) => i.id.startsWith('class-')).toList();
    expect(classes.map((i) => i.title), ['Programmation avancée', 'Mobile Android & Flutter']);

    c.read(completedItemsProvider.notifier).toggle(classes.first.id);
    expect(c.read(itemsForDayProvider(day)).firstWhere((i) => i.id == classes.first.id).done, isTrue);
  });
}
