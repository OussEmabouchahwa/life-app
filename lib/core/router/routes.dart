/// Route paths. Features navigate with `context.push(Routes.addMeal)`
/// and never hard-code strings.
abstract final class Routes {
  /// Adds `?id=` to open a form on an existing record.
  /// Add meal with a food already chosen.
  static String withFood(String foodId) => '$addMeal?food=${Uri.encodeQueryComponent(foodId)}';

  static String withId(String route, String? id) =>
      id == null ? route : '$route?id=${Uri.encodeQueryComponent(id)}';

  // Tabs (inside the shell, tab bar visible).
  static const today = '/today';
  static const plan = '/plan';
  static const weekView = '/plan/week';
  static const tasks = '/plan/tasks';
  static const timetable = '/plan/timetable';
  static const train = '/train';
  static const study = '/study';
  static const food = '/food';

  // Full-screen flows (no tab bar).
  static const addEvent = '/add-event';
  static const addStudySession = '/add-event?category=study';
  static const workoutLog = '/workout-log';
  static const gradeCalculator = '/grade-calculator';
  static const addMeal = '/add-meal';
  static const settings = '/settings';
  static const programme = '/programme';
  static const workoutForm = '/workout';
  static const shiftForm = '/work-shift';
  static const taskForm = '/task';
  static const foodForm = '/food-item';
  static const nutritionGoals = '/nutrition-goals';
  static const barcodeScanner = '/scan';
  static const examForm = '/exam';
  static const gradeForm = '/grade';
  static const revisionGoals = '/revision-goals';
  static const commuteSettings = '/settings/commute';
  static const onboarding = '/onboarding';
}
