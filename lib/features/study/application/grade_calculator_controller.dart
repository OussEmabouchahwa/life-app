import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/grade_math.dart';
import 'study_providers.dart';

@immutable
class GradeCalculatorState {
  const GradeCalculatorState({required this.subjectId, required this.target});

  final String? subjectId;
  final double target;

  GradeCalculatorState copyWith({String? subjectId, double? target}) =>
      GradeCalculatorState(subjectId: subjectId ?? this.subjectId, target: target ?? this.target);
}

final gradeCalculatorProvider = NotifierProvider.autoDispose<GradeCalculatorController, GradeCalculatorState>(
  GradeCalculatorController.new,
);

class GradeCalculatorController extends Notifier<GradeCalculatorState> {
  static const minTarget = 8.0, maxTarget = 18.0;
  static const presets = [10.0, 12.0, 14.0, 16.0];

  @override
  GradeCalculatorState build() {
    // Start on a subject that has marks but still an assessment to sit.
    final subjects = ref.read(subjectsProvider);
    final pick =
        subjects.where((s) => s.hasMarks && GradeMath.neededMark(s, 10) != null).firstOrNull ??
        subjects.firstOrNull;
    return GradeCalculatorState(subjectId: pick?.id, target: 12);
  }

  void selectSubject(String id) => state = state.copyWith(subjectId: id);

  /// Snaps to half points like the slider.
  void setTarget(double v) => state = state.copyWith(target: (v * 2).round() / 2);
}
