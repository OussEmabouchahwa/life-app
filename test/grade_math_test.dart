import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/features/study/domain/grade_math.dart';
import 'package:nizam/features/study/domain/study_models.dart';

void main() {
  const db = SubjectGrades(
    id: 'DB',
    name: 'Databases',
    coef: 3,
    marks: {Assessment.ds: 14.5, Assessment.tp: 16},
  );
  const noTp = SubjectGrades(
    id: 'LAW',
    name: 'Droit',
    coef: 1,
    weights: {Assessment.ds: 0.3, Assessment.tp: 0, Assessment.exam: 0.7},
    marks: {Assessment.ds: 12},
  );

  test('subject average weights the known marks', () {
    // (14.5 × 0.3 + 16 × 0.1) / 0.4
    expect(db.average!.toStringAsFixed(3), '14.875');
    expect(noTp.average, 12);
    expect(const SubjectGrades(id: 'x', name: 'x').average, isNull);
  });

  test('weighted average uses coefficients and skips ungraded subjects', () {
    const empty = SubjectGrades(id: 'E', name: 'Empty', coef: 5);
    final avg = GradeMath.weightedAverage([db, noTp, empty])!;
    expect(avg, closeTo((14.875 * 3 + 12 * 1) / 4, 1e-9));
  });

  test('needed exam mark (design case: 13.4 for a 14.0 target)', () {
    expect(GradeMath.neededMark(db, 14)!.toStringAsFixed(1), '13.4');
  });

  test('needed mark ignores assessments with no weight', () {
    // 0.3 × 12 + 0.7 × x = 10  →  x = 9.14
    expect(GradeMath.neededMark(noTp, 10)!.toStringAsFixed(2), '9.14');
  });

  test('needed mark is null when all marks are in', () {
    const full = SubjectGrades(
      id: 'F',
      name: 'Full',
      marks: {Assessment.ds: 10, Assessment.tp: 10, Assessment.exam: 10},
    );
    expect(GradeMath.neededMark(full, 12), isNull);
  });

  test('grades survive a save / load round trip', () {
    final back = SubjectGrades.fromJson(noTp.toJson());
    expect(back.weights, noTp.weights);
    expect(back.marks, noTp.marks);
    expect(back.coef, 1);
  });

  test('reachability buckets', () {
    expect(Reachability.of(-1), Reachability.secured);
    expect(Reachability.of(13.4), Reachability.steady);
    expect(Reachability.of(18), Reachability.hard);
    expect(Reachability.of(25), Reachability.impossible);
  });
}
