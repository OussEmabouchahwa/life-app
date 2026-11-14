import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/time_format.dart';
import '../data/study_repository.dart';
import '../domain/grade_math.dart';
import '../domain/study_models.dart';

enum StudyTab { exams, revision, grades }

final studyTabProvider = NotifierProvider<StudyTabController, StudyTab>(StudyTabController.new);

class StudyTabController extends Notifier<StudyTab> {
  @override
  StudyTab build() => StudyTab.exams;

  void select(StudyTab tab) => state = tab;
}

final examsProvider = Provider<List<Exam>>((ref) {
  final today = ref.watch(nowProvider).dateOnly;
  return ref.watch(studyRepositoryProvider).upcomingExams(today);
});

final gradesProvider = Provider<List<SubjectGrades>>((ref) => ref.watch(studyRepositoryProvider).grades());

final weightedAverageProvider = Provider<double?>(
  (ref) => GradeMath.weightedAverage(ref.watch(gradesProvider)),
);
