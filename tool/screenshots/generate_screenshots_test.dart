// Renders the README screenshots from the real app.
//
//   flutter test tool/screenshots/generate_screenshots_test.dart
//
// Output: docs/screenshots/*.png (390 × 844 phone frame at 2×).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/app/app.dart';
import 'package:nizam/app/router.dart';
import 'package:nizam/core/providers/clock_provider.dart';
import 'package:nizam/core/providers/connectivity_provider.dart';
import 'package:nizam/core/router/routes.dart';
import 'package:nizam/core/storage/local_store.dart';
import 'package:nizam/features/study/application/study_providers.dart';
import 'package:nizam/features/timetable/application/timetable_providers.dart';
import 'package:nizam/features/timetable/data/timetable_parser.dart';
import 'package:nizam/features/timetable/data/timetable_repository.dart';
import 'package:nizam/features/timetable/domain/class_session.dart';
import 'package:nizam/features/today/data/weather_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'seed_data.dart';

const _frame = Size(390, 844);
const _pixelRatio = 2.0;
final _out = Directory('docs/screenshots');

class _FileTimetable implements TimetableRepository {
  @override
  Future<List<ClassSession>> sessions() async =>
      TimetableParser.parse(File('assets/data/timetable.json').readAsStringSync());
}

Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final p in paths) {
    loader.addFont(Future.value(ByteData.sublistView(File(p).readAsBytesSync())));
  }
  await loader.load();
}

Future<void> _loadFonts() async {
  await _loadFont('Fraunces', ['assets/fonts/Fraunces-SemiBold.ttf']);
  await _loadFont('Manrope', ['assets/fonts/Manrope-Medium.ttf', 'assets/fonts/Manrope-Bold.ttf']);
  await _loadFont('NotoNaskhArabic', ['assets/fonts/NotoNaskhArabic-Regular.ttf']);
  final flutterRoot = Platform.environment['FLUTTER_ROOT']!;
  await _loadFont('MaterialIcons', [
    '$flutterRoot/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
  ]);
}

void main() {
  // 10:40 today: the morning class shows the NOW marker.
  final real = DateTime.now();
  final now = DateTime(real.year, real.month, real.day, 10, 40);
  final boundaryKey = GlobalKey();

  setUpAll(() async {
    await _loadFonts();
    _out.createSync(recursive: true);
  });

  Future<void> shoot(
    WidgetTester tester,
    String name,
    String route, {
    bool dark = false,
    bool ramadan = false,
    bool onboarded = true,
    Future<void> Function(WidgetTester, ProviderContainer)? before,
  }) async {
    tester.view.physicalSize = _frame * _pixelRatio;
    tester.view.devicePixelRatio = _pixelRatio;
    addTearDown(tester.view.reset);

    // A test-only API, used on purpose: this generator runs with `flutter test`.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues(
      screenshotSeed(now, dark: dark, ramadan: ramadan, onboarded: onboarded),
    );
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        nowProvider.overrideWithValue(now),
        timetableRepositoryProvider.overrideWithValue(_FileTimetable()),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        weatherHintProvider.overrideWith(
          (ref) async => WeatherHint(
            summary: 'Tomorrow: showers, 14–21°',
            advice: 'Bring an umbrella and leave 10 min early.',
            rain: true,
            fetchedAt: now,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.runAsync(() => container.read(sessionsProvider.future));
    await tester.pumpWidget(
      RepaintBoundary(
        key: boundaryKey,
        child: UncontrolledProviderScope(container: container, child: const NizamApp()),
      ),
    );
    if (route != Routes.today) container.read(routerProvider).go(route);
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
    if (before != null) await before(tester, container);

    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(boundaryKey));
    final bytes = await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: _pixelRatio);
      return (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    });
    File('${_out.path}/$name.png').writeAsBytesSync(bytes!);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  final shots = <String, Future<void> Function(WidgetTester)>{
    'today': (t) => shoot(t, 'today', Routes.today),
    'today_dark': (t) => shoot(t, 'today_dark', Routes.today, dark: true),
    'plan': (t) => shoot(t, 'plan', Routes.plan),
    'timetable': (t) => shoot(t, 'timetable', Routes.timetable),
    'tasks': (t) => shoot(t, 'tasks', Routes.tasks),
    'study_exams': (t) => shoot(t, 'study_exams', Routes.study),
    'study_revision': (t) => shoot(
      t,
      'study_revision',
      Routes.study,
      dark: true,
      before: (t, c) async {
        c.read(studyTabProvider.notifier).select(StudyTab.revision);
        await settle(t);
      },
    ),
    'study_grades': (t) => shoot(
      t,
      'study_grades',
      Routes.study,
      before: (t, c) async {
        c.read(studyTabProvider.notifier).select(StudyTab.grades);
        await settle(t);
      },
    ),
    'grade_form': (t) => shoot(t, 'grade_form', Routes.withId(Routes.gradeForm, 'GINF.33-2')),
    'training': (t) => shoot(t, 'training', Routes.train),
    'workout_log': (t) => shoot(t, 'workout_log', Routes.withId(Routes.workoutLog, 'legs'), dark: true),
    'food': (t) => shoot(t, 'food', Routes.food),
    'food_ramadan': (t) => shoot(t, 'food_ramadan', Routes.food, dark: true, ramadan: true),
    'add_event': (t) => shoot(t, 'add_event', Routes.addStudySession),
    'exam_form': (t) => shoot(t, 'exam_form', Routes.withId(Routes.examForm, 'ex1')),
    'settings': (t) => shoot(t, 'settings', Routes.settings, dark: true),
    'onboarding': (t) => shoot(
      t,
      'onboarding',
      Routes.onboarding,
      onboarded: false,
      before: (t, c) async {
        await t.tap(find.text('Continue'));
        await settle(t);
      },
    ),
  };

  for (final MapEntry(key: name, value: run) in shots.entries) {
    testWidgets('screenshot $name', run);
  }
}
