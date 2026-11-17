import '../../../core/storage/stored_list_controller.dart';
import '../domain/study_models.dart';

/// Exams the user entered. Starts empty: only real data.
class ExamsController extends StoredListController<Exam> {
  @override
  String get storageKey => 'exams_v1';

  @override
  Exam fromJson(Map<String, dynamic> json) => Exam.fromJson(json);
}

/// Coefficient, weights and marks per course.
class GradesController extends StoredListController<SubjectGrades> {
  @override
  String get storageKey => 'grades_v1';

  @override
  SubjectGrades fromJson(Map<String, dynamic> json) => SubjectGrades.fromJson(json);
}

/// Weekly revision hours per course.
class RevisionGoalsController extends StoredListController<RevisionGoal> {
  @override
  String get storageKey => 'revision_goals_v1';

  @override
  RevisionGoal fromJson(Map<String, dynamic> json) => RevisionGoal.fromJson(json);

  /// Replaces all goals at once (the goals form edits every course).
  void setAll(Map<String, double> hoursByCode) {
    for (final e in hoursByCode.entries) {
      if (e.value <= 0) {
        remove(e.key);
      } else {
        save(RevisionGoal(id: e.key, hoursPerWeek: e.value));
      }
    }
  }
}
