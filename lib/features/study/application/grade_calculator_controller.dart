import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/grade_math.dart';
import '../domain/study_models.dart';
import 'study_providers.dart';

@immutable
class GradeCalculatorState {
  const GradeCalculatorState({required this.subject, required this.target});

  final SubjectGrades subject;
  final double target;

  double? get needed => GradeMath.neededMark(subject, target);

  GradeCalculatorState copyWith({SubjectGrades? subject, double? target}) =>
      GradeCalculatorState(subject: subject ?? this.subject, target: target ?? this.target);
}

final gradeCalculatorProvider = NotifierProvider.autoDispose<GradeCalculatorController, GradeCalculatorState>(
  GradeCalculatorController.new,
);

class GradeCalculatorController extends Notifier<GradeCalculatorState> {
  static const minTarget = 8.0, maxTarget = 18.0;
  static const presets = [10.0, 12.0, 14.0, 16.0];

  @override
  GradeCalculatorState build() => GradeCalculatorState(subject: ref.read(gradesProvider).first, target: 14);

  void selectSubject(SubjectGrades s) => state = state.copyWith(subject: s);

  /// Snaps to half points like the slider.
  void setTarget(double v) => state = state.copyWith(target: (v * 2).round() / 2);
}
