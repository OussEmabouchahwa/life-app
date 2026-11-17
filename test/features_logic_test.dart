import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/core/providers/clock_provider.dart';
import 'package:nizam/core/storage/local_store.dart';
import 'package:nizam/features/food/application/fasting_providers.dart';
import 'package:nizam/features/food/data/open_food_facts.dart';
import 'package:nizam/features/notifications/application/reminders_provider.dart';
import 'package:nizam/features/notifications/domain/reminder.dart';
import 'package:nizam/features/plan/application/plan_controller.dart';
import 'package:nizam/features/plan/application/task_providers.dart';
import 'package:nizam/features/plan/data/tasks.dart';
import 'package:nizam/features/study/application/study_providers.dart';
import 'package:nizam/features/study/domain/study_models.dart';
import 'package:nizam/features/today/data/weather_repository.dart';
import 'package:nizam/shared/models/event_category.dart';
import 'package:nizam/shared/models/plan_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tuesday 17 Nov 2026 in Tunis.
Future<ProviderContainer> _at(DateTime now) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final c = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs), nowProvider.overrideWithValue(now)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('weather', () {
    Map<String, dynamic> forecast(int code, num min, num max, num rain) => {
      'daily': {
        'time': ['2026-11-17', '2026-11-18'],
        'weather_code': [0, code],
        'temperature_2m_max': [20, max],
        'temperature_2m_min': [10, min],
        'precipitation_probability_max': [0, rain],
      },
    };

    test('rain tomorrow suggests an umbrella', () {
      final h = WeatherHint.fromOpenMeteo(forecast(63, 15, 19, 80), DateTime(2026))!;
      expect(h.summary, 'Tomorrow: rain, 15–19°');
      expect(h.rain, isTrue);
      expect(h.advice, contains('umbrella'));
    });

    test('hot and clear days get their own advice', () {
      expect(WeatherHint.fromOpenMeteo(forecast(0, 24, 35, 0), DateTime(2026))!.advice, contains('Hot'));
      expect(WeatherHint.fromOpenMeteo(forecast(1, 12, 22, 5), DateTime(2026))!.rain, isFalse);
    });
  });

  test('Open Food Facts product is read per 100 g', () {
    final food = OpenFoodFacts.parse('6191234567890', {
      'status': 1,
      'product': {
        'product_name': 'Yaourt nature',
        'brands': 'Délice, Danone',
        'serving_quantity': 110,
        'serving_size': '1 pot (110 g)',
        'nutriments': {
          'energy-kcal_100g': 62,
          'proteins_100g': 3.6,
          'carbohydrates_100g': 4.5,
          'fat_100g': 3.2,
        },
      },
    })!;
    expect(food.name, 'Yaourt nature · Délice');
    expect(food.forGrams(110).kcal.round(), 68);
    expect(food.barcode, '6191234567890');
    expect(OpenFoodFacts.parse('1', {'status': 0}), isNull);
  });

  test('Ramadan phases follow Fajr and Maghrib', () async {
    expect((await _at(DateTime(2026, 11, 17, 4))).read(fastingStatusProvider).phase, FastingPhase.suhoor);
    final noon = (await _at(DateTime(2026, 11, 17, 12))).read(fastingStatusProvider);
    expect(noon.phase, FastingPhase.fasting);
    expect(noon.progress, inExclusiveRange(0, 1));
    final night = (await _at(DateTime(2026, 11, 17, 21))).read(fastingStatusProvider);
    expect(night.phase, FastingPhase.iftar);
    expect(night.fajr.day, 18, reason: 'next fast starts tomorrow');
  });

  test('reminders cover prayers and exams, only in the future', () async {
    final c = await _at(DateTime(2026, 11, 17, 13));
    c
        .read(examsProvider.notifier)
        .save(
          Exam(
            id: 'e',
            subject: 'Droit',
            start: DateTime(2026, 11, 18, 9),
            minutes: 90,
            type: ExamType.written,
          ),
        );
    final reminders = c.read(remindersProvider);
    expect(reminders.every((r) => r.at.isAfter(DateTime(2026, 11, 17, 13))), isTrue);
    expect(
      reminders.where((r) => r.kind == ReminderKind.prayer),
      hasLength(8),
      reason: '3 left today + 5 tomorrow',
    );
    expect(reminders.where((r) => r.kind == ReminderKind.exam).map((r) => r.at), [
      DateTime(2026, 11, 17, 20),
      DateTime(2026, 11, 18, 8),
    ]);
  });

  test('ticked study sessions count towards the revision goal', () async {
    final c = await _at(DateTime(2026, 11, 17, 21));
    c.read(revisionGoalsProvider.notifier).setAll({'GINF.32-3': 4});
    final session = PlanItem(
      id: 's1',
      title: 'Revision',
      detail: '',
      start: DateTime(2026, 11, 17, 18),
      duration: const Duration(minutes: 90),
      category: EventCategory.study,
      courseCode: 'GINF.32-3',
    );
    c.read(personalEventsProvider.notifier).save(session);
    expect(c.read(revisionProgressProvider).single.doneHours, 0, reason: 'not ticked yet');

    c.read(completedItemsProvider.notifier).toggle('s1');
    final p = c.read(revisionProgressProvider).single;
    expect(p.doneHours, 1.5);
    expect(c.read(revisionWeekProvider).streakDays, 1);
  });

  test('tasks are grouped into overdue, this week and later', () async {
    final c = await _at(DateTime(2026, 11, 17, 12));
    final tasks = c.read(tasksProvider.notifier);
    for (final (id, due) in [
      ('late', DateTime(2026, 11, 16)),
      ('week', DateTime(2026, 11, 20)),
      ('later', DateTime(2026, 12, 1)),
    ]) {
      tasks.save(Task(id: id, title: id, due: due));
    }
    final g = c.read(taskGroupsProvider);
    expect([g.overdue.single.id, g.thisWeek.single.id, g.later.single.id], ['late', 'week', 'later']);
    expect(c.read(dueNowTasksProvider).single.id, 'late');
  });
}
