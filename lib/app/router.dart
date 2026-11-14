import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/router/routes.dart';
import '../features/food/presentation/add_meal_screen.dart';
import '../features/food/presentation/food_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/plan/presentation/add_event_screen.dart';
import '../features/plan/presentation/plan_screen.dart';
import '../features/timetable/presentation/timetable_screen.dart';
import '../features/plan/presentation/week_view_screen.dart';
import '../features/settings/application/settings_controller.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/shell/presentation/main_shell.dart';
import '../features/study/presentation/grade_calculator_screen.dart';
import '../features/study/presentation/study_screen.dart';
import '../features/today/presentation/today_screen.dart';
import '../features/training/presentation/training_screen.dart';
import '../features/training/presentation/workout_log_screen.dart';

/// App navigation.
///  * Five tab branches inside [MainShell] (tab bar visible).
///  * Full-screen flows on the root navigator (no tab bar).
///  * Redirects to onboarding until it is completed.
final routerProvider = Provider<GoRouter>((ref) {
  final onboarded = ValueNotifier(ref.read(settingsProvider).onboarded);
  ref.listen(settingsProvider.select((s) => s.onboarded), (_, v) => onboarded.value = v);

  GoRoute page(String path, Widget screen, [List<RouteBase> children = const []]) =>
      GoRoute(path: path, builder: (_, _) => screen, routes: children);

  StatefulShellBranch branch(GoRoute route) => StatefulShellBranch(routes: [route]);

  final router = GoRouter(
    initialLocation: Routes.today,
    refreshListenable: onboarded,
    redirect: (_, state) {
      final atOnboarding = state.matchedLocation == Routes.onboarding;
      if (!onboarded.value && !atOnboarding) return Routes.onboarding;
      if (onboarded.value && atOnboarding) return Routes.today;
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(shell: shell),
        branches: [
          branch(page(Routes.today, const TodayScreen())),
          branch(
            page(Routes.plan, const PlanScreen(), [
              page('week', const WeekViewScreen()),
              page('timetable', const TimetableScreen()),
            ]),
          ),
          branch(page(Routes.train, const TrainingScreen())),
          branch(page(Routes.study, const StudyScreen())),
          branch(page(Routes.food, const FoodScreen())),
        ],
      ),
      page(Routes.addEvent, const AddEventScreen()),
      page(Routes.workoutLog, const WorkoutLogScreen()),
      page(Routes.gradeCalculator, const GradeCalculatorScreen()),
      page(Routes.addMeal, const AddMealScreen()),
      page(Routes.settings, const SettingsScreen()),
      page(Routes.onboarding, const OnboardingScreen()),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    onboarded.dispose();
  });
  return router;
});
