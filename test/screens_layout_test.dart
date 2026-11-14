import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/app/app.dart';
import 'package:nizam/core/theme/app_text_styles.dart';
import 'package:nizam/core/router/routes.dart';
import 'package:nizam/features/settings/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:nizam/app/router.dart';

/// Pumps every screen at several phone sizes and fails on any layout
/// exception (RenderFlex overflow etc.).
void main() {
  AppTextStyles.useGoogleFonts = false;

  const sizes = {
    'small 320x640': Size(320, 640),
    'figma 390x844': Size(390, 844),
    'large 430x932': Size(430, 932),
  };
  const routes = [
    Routes.today,
    Routes.plan,
    Routes.weekView,
    Routes.timetable,
    Routes.train,
    Routes.study,
    Routes.food,
    Routes.addEvent,
    Routes.workoutLog,
    Routes.gradeCalculator,
    Routes.addMeal,
    Routes.settings,
  ];

  for (final MapEntry(key: name, value: size) in sizes.entries) {
    testWidgets('all screens lay out without errors on $name', (tester) async {
      tester.view.physicalSize = size * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      SharedPreferences.setMockInitialValues({'onboarded': true});
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
