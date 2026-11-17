import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/app/app.dart';
import 'package:nizam/core/router/routes.dart';
import 'package:nizam/core/storage/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:nizam/app/router.dart';

/// Pumps every screen at several phone sizes and fails on any layout
/// exception (RenderFlex overflow etc.).
void main() {
  const sizes = {
    'small 320x640': Size(320, 640),
    'figma 390x844': Size(390, 844),
    'large 430x932': Size(430, 932),
  };
  final routes = [
    Routes.today,
    Routes.plan,
    Routes.weekView,
    Routes.tasks,
    Routes.timetable,
    Routes.train,
    Routes.study,
    Routes.food,
    Routes.addEvent,
    Routes.withId(Routes.addEvent, 'ev1'),
    Routes.addStudySession,
    Routes.withId(Routes.workoutLog, 'push'),
    Routes.programme,
    Routes.workoutForm,
    Routes.withId(Routes.workoutForm, 'legs'),
    Routes.examForm,
    Routes.withId(Routes.examForm, 'ex1'),
    Routes.withId(Routes.gradeForm, 'GINF.33-2'),
    Routes.revisionGoals,
    Routes.gradeCalculator,
    Routes.addMeal,
    Routes.withFood('builtin-lablabi'),
    Routes.foodForm,
    Routes.nutritionGoals,
    Routes.barcodeScanner,
    Routes.shiftForm,
    Routes.withId(Routes.shiftForm, 'sh1'),
    Routes.taskForm,
    Routes.withId(Routes.taskForm, 'tk1'),
    Routes.settings,
    Routes.commuteSettings,
  ];

  for (final MapEntry(key: name, value: size) in sizes.entries) {
    testWidgets('all screens lay out without errors on $name', (tester) async {
      tester.view.physicalSize = size * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      SharedPreferences.setMockInitialValues(_seed(DateTime.now()));
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
      addTearDown(container.dispose);

      await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const NizamApp()));
      await tester.pump(const Duration(milliseconds: 300));

      final GoRouter router = container.read(routerProvider);
      final errors = <String>[];
      for (final r in routes) {
        router.go(r);
        await tester.pump(const Duration(milliseconds: 400));
        final e = tester.takeException();
        if (e != null) errors.add('$r: $e');
      }
      expect(errors, isEmpty, reason: 'Layout errors on $name');
      // Let the clock stream and timers settle before teardown.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  }
}

/// Saved data so lists and edit forms render with content.
Map<String, Object> _seed(DateTime now) {
  final soon = DateTime(now.year, now.month, now.day).add(const Duration(days: 2));
  String list(List<Map<String, Object?>> items) => jsonEncode(items);
  return {
    'settings_v2': jsonEncode({
      'onboarded': true,
      'userName': 'Oussema',
      'city': 'Sfax',
      'sleepPlace': 'far',
    }),
    'exams_v1': list([
      {
        'id': 'ex1',
        'subject': 'Mobile Android & Flutter',
        'courseCode': 'GINF.33-2',
        'start': soon.add(const Duration(hours: 9)).toIso8601String(),
        'minutes': 90,
        'type': 'written',
        'room': 'Salle TP 7-3',
      },
    ]),
    'tasks_v1': list([
      {
        'id': 'tk1',
        'title': 'Mini project report, chapter 3 and screenshots',
        'due': now.toIso8601String(),
        'courseCode': 'GINF.34-2',
        'done': false,
      },
      {'id': 'tk2', 'title': 'Angular TP', 'due': soon.toIso8601String(), 'done': true},
    ]),
    'work_shifts_v1': list([
      {'id': 'sh1', 'weekday': now.weekday, 'start': 17 * 60, 'end': 21 * 60, 'place': 'Café'},
    ]),
    'events_v1': list([
      {
        'id': 'ev1',
        'title': 'Revision · Patrons de conception',
        'detail': 'Chapter 4',
        'start': DateTime(now.year, now.month, now.day, 19).toIso8601String(),
        'minutes': 90,
        'category': 'study',
        'courseCode': 'GINF.32-3',
      },
    ]),
    'food_diary_v1': list([
      {
        'id': 'm1',
        'type': 'breakfast',
        'description': 'Bsissa',
        'time': now.toIso8601String(),
        'macros': {'kcal': 420, 'p': 14, 'c': 60, 'f': 13},
        'grams': 100,
      },
    ]),
    'grades_v1': list([
      {
        'id': 'GINF.33-2',
        'name': 'Mobile',
        'coef': 2,
        'weights': {'ds': 0.3, 'tp': 0.1, 'exam': 0.6},
        'marks': {'ds': 14.5},
      },
    ]),
  };
}
