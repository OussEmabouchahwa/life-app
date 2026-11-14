import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/features/study/data/study_repository.dart';
import 'package:nizam/features/study/domain/grade_math.dart';
import 'package:nizam/features/study/domain/study_models.dart';

void main() {
  const repo = StudyRepository();

  test('weighted average matches the design (13.6 / 20)', () {
    final avg = GradeMath.weightedAverage(repo.grades())!;
    expect(avg.toStringAsFixed(1), '13.6');
  });

  test('subject averages match the grades table', () {
    final byName = {for (final s in repo.grades()) s.name: s.average!.toStringAsFixed(1)};
    expect(byName, {'Databases': '15.3', 'Networks': '13.5', 'Algorithms': '11.0', 'English': '17.0'});
  });

  test('needed exam mark matches the calculator design (13.4 for 14.0)', () {
    final db = repo.grades().first;
    expect(GradeMath.neededMark(db, 14)!.toStringAsFixed(1), '13.4');
  });

  test('needed mark is null when all marks are in', () {
    const full = SubjectGrades(
      name: 'X',
      prof: 'Y',
      coef: 1,
      marks: {Assessment.ds: 10, Assessment.tp: 10, Assessment.exam: 10},
    );
    expect(GradeMath.neededMark(full, 12), isNull);
  });

  test('reachability buckets', () {
    expect(Reachability.of(-1), Reachability.secured);
    expect(Reachability.of(13.4), Reachability.steady);
    expect(Reachability.of(18), Reachability.hard);
    expect(Reachability.of(25), Reachability.impossible);
  });
}
