import 'dart:convert';

/// Sample data for the README screenshots: a realistic student week built
/// around the real faculty timetable. Dates are relative to [now].
Map<String, Object> screenshotSeed(
  DateTime now, {
  bool dark = false,
  bool ramadan = false,
  bool onboarded = true,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final monday = today.subtract(Duration(days: today.weekday - 1));
  DateTime day(int offset, [int h = 0, int m = 0]) => today.add(Duration(days: offset, hours: h, minutes: m));
  DateTime week(int weekday, [int h = 0, int m = 0]) =>
      monday.add(Duration(days: weekday - 1, hours: h, minutes: m));
  String iso(DateTime d) => d.toIso8601String();
  String list(List<Map<String, Object?>> items) => jsonEncode(items);
  Map<String, Object> macros(num kcal, num p, num c, num f) => {'kcal': kcal, 'p': p, 'c': c, 'f': f};

  return {
    'settings_v2': jsonEncode({
      'theme': dark ? 'dark' : 'light',
      'language': 'english',
      'userName': 'Oussema',
      'city': 'Tunis',
      'sleepPlace': 'far',
      'nearPlace': 'Tunis · Dar',
      'farPlace': 'Bir Ali',
      'commuteMinutes': 55,
      'coachTimes': ['07:10', '07:40', '08:15'],
      'onboarded': onboarded,
    }),
    'coach_choice': '07:10',
    'exams_v1': list([
      {
        'id': 'ex1',
        'subject': 'Patrons de conception',
        'courseCode': 'GINF.32-3',
        'start': iso(day(5, 9)),
        'minutes': 90,
        'type': 'written',
        'room': 'Salle TP 5-3',
      },
      {
        'id': 'ex2',
        'subject': 'Mobile Android & Flutter',
        'courseCode': 'GINF.33-2',
        'start': iso(day(13, 13, 15)),
        'minutes': 120,
        'type': 'practical',
        'room': 'Salle TP 7-3',
      },
      {
        'id': 'ex3',
        'subject': 'Administration Linux',
        'courseCode': 'GINF.34-1',
        'start': iso(day(22, 9)),
        'minutes': 90,
        'type': 'written',
        'room': '',
      },
    ]),
    'grades_v1': list([
      {
        'id': 'GINF.33-2',
        'name': '',
        'coef': 2,
        'weights': {'ds': 0.3, 'tp': 0.2, 'exam': 0.5},
        'marks': {'ds': 15.5, 'tp': 17},
      },
      {
        'id': 'GINF.33-3',
        'name': '',
        'coef': 2,
        'weights': {'ds': 0.3, 'tp': 0.2, 'exam': 0.5},
        'marks': {'ds': 13, 'tp': 16},
      },
      {
        'id': 'GINF.32-1',
        'name': '',
        'coef': 3,
        'weights': {'ds': 0.3, 'tp': 0.1, 'exam': 0.6},
        'marks': {'ds': 11.5},
      },
      {
        'id': 'GINF.35-3',
        'name': '',
        'coef': 1,
        'weights': {'ds': 0.3, 'tp': 0, 'exam': 0.7},
        'marks': {'ds': 14},
      },
      {
        'id': 'GINF.35-1',
        'name': '',
        'coef': 1,
        'weights': {'ds': 0.4, 'tp': 0, 'exam': 0.6},
        'marks': {'ds': 16.5},
      },
    ]),
    'revision_goals_v1': list([
      {'id': 'GINF.32-3', 'hours': 4},
      {'id': 'GINF.33-2', 'hours': 3},
      {'id': 'GINF.34-1', 'hours': 2},
    ]),
    'events_v1': list([
      for (final (id, d, code, title, minutes) in [
        ('r1', week(1, 19, 30), 'GINF.32-3', 'Revision · Patrons de conception', 90),
        ('r2', week(2, 19, 30), 'GINF.33-2', 'Revision · Flutter state management', 60),
        ('r3', day(0, 19, 30), 'GINF.34-1', 'Revision · Administration Linux', 90),
      ])
        {
          'id': id,
          'title': title,
          'detail': '',
          'start': iso(d),
          'minutes': minutes,
          'category': 'study',
          'courseCode': code,
        },
    ]),
    'completed_v1': ['r1', 'r2'],
    'tasks_v1': list([
      {
        'id': 't1',
        'title': 'Mini projet · rapport chapitre 3',
        'due': iso(day(0, 23, 59)),
        'courseCode': 'GINF.34-2',
        'done': false,
      },
      {
        'id': 't2',
        'title': 'TP Angular · formulaire réactif',
        'due': iso(day(2, 18)),
        'courseCode': 'GINF.33-3',
        'done': false,
      },
      {
        'id': 't3',
        'title': 'Exposé UX/UI · maquettes',
        'due': iso(day(14, 8, 30)),
        'courseCode': 'GINF.33-1',
        'done': false,
      },
      {
        'id': 't4',
        'title': 'Anglais · essay draft',
        'due': iso(day(-1, 20)),
        'courseCode': 'GINF.35-1',
        'done': true,
      },
    ]),
    'work_shifts_v1': list([
      {'id': 'w1', 'weekday': 6, 'start': 9 * 60, 'end': 15 * 60, 'place': 'Café'},
    ]),
    'food_diary_v1': list([
      {
        'id': 'm1',
        'type': ramadan ? 'suhoor' : 'breakfast',
        'description': 'Bsissa',
        'time': iso(day(0, 7)),
        'macros': macros(168, 5.6, 24, 5.2),
        'grams': 40,
      },
      {
        'id': 'm2',
        'type': ramadan ? 'suhoor' : 'breakfast',
        'description': 'Coffee with milk',
        'time': iso(day(0, 7, 5)),
        'macros': macros(53, 3, 5, 2),
        'grams': 150,
      },
      if (!ramadan)
        {
          'id': 'm3',
          'type': 'lunch',
          'description': 'Couscous with fish',
          'time': iso(day(0, 12, 40)),
          'macros': macros(520, 36, 68, 12),
          'grams': 400,
        },
      if (!ramadan)
        {
          'id': 'm4',
          'type': 'snack',
          'description': 'Yogurt (plain)',
          'time': iso(day(0, 16)),
          'macros': macros(76, 4.4, 5.9, 4.1),
          'grams': 125,
        },
    ]),
    'food_settings_v1': jsonEncode({
      'goal': macros(2200, 130, 250, 70),
      'mode': ramadan ? 'ramadan' : 'standard',
      'water': 8,
    }),
    'water_v1': jsonEncode({today.toIso8601String().substring(0, 10): 5}),
    'workout_history_v1': list([
      {
        'id': 'h1',
        'workout': 'Leg day',
        'date': iso(day(-7, 17, 15)),
        'sets': {
          'Squat': [
            for (var i = 0; i < 4; i++) {'kg': 47.5, 'reps': 8},
          ],
          'Romanian deadlift': [
            for (var i = 0; i < 3; i++) {'kg': 40, 'reps': 10},
          ],
          'Leg press': [
            for (var i = 0; i < 3; i++) {'kg': 80, 'reps': 12},
          ],
        },
      },
      {
        'id': 'h2',
        'workout': 'Push day',
        'date': iso(week(1, 17, 15)),
        'sets': {
          'Bench press': [
            for (var i = 0; i < 4; i++) {'kg': 42.5, 'reps': 8},
          ],
          'Overhead press': [
            for (var i = 0; i < 3; i++) {'kg': 25, 'reps': 8},
          ],
        },
      },
      {
        'id': 'h3',
        'workout': 'Pull day',
        'date': iso(week(2, 17, 15)),
        'sets': {
          'Lat pulldown': [
            for (var i = 0; i < 4; i++) {'kg': 42.5, 'reps': 10},
          ],
          'Seated cable row': [
            for (var i = 0; i < 3; i++) {'kg': 35, 'reps': 10},
          ],
        },
      },
    ]),
  };
}
