/// Route paths. Features navigate with `context.push(Routes.addMeal)`
/// and never hard-code strings.
abstract final class Routes {
  // Tabs (inside the shell, tab bar visible).
  static const today = '/today';
  static const plan = '/plan';
  static const weekView = '/plan/week';
  static const timetable = '/plan/timetable';
  static const train = '/train';
  static const study = '/study';
  static const food = '/food';

  // Full-screen flows (no tab bar).
  static const addEvent = '/add-event';
  static const workoutLog = '/workout-log';
  static const gradeCalculator = '/grade-calculator';
  static const addMeal = '/add-meal';
  static const settings = '/settings';
  static const onboarding = '/onboarding';
}
