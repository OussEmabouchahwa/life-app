import 'study_models.dart';

/// Pure grade calculations. No Flutter imports, so they are trivial to test.
abstract final class GradeMath {
  /// Average of subject averages weighted by coefficient. Subjects without
  /// any mark are left out.
  static double? weightedAverage(List<SubjectGrades> subjects) {
    var sum = 0.0, coefs = 0.0;
    for (final s in subjects) {
      final avg = s.average;
      if (avg == null || s.coef <= 0) continue;
      sum += avg * s.coef;
      coefs += s.coef;
    }
    return coefs == 0 ? null : sum / coefs;
  }

  /// Mark needed on every assessment still missing to reach [target].
  ///
  /// final = Σ weight × mark. Known marks are fixed; the remaining weight is
  /// shared by the missing ones. Returns null when nothing is left to sit.
  static double? neededMark(SubjectGrades s, double target) {
    var known = 0.0, missingWeight = 0.0, total = 0.0;
    for (final a in s.assessments) {
      final w = s.weightOf(a);
      total += w;
      final mark = s.marks[a];
      if (mark == null) {
        missingWeight += w;
      } else {
        known += w * mark;
      }
    }
    if (missingWeight == 0 || total == 0) return null;
    return (target * total - known) / missingWeight;
  }
}

enum Reachability {
  secured('Already secured, keep it up.'),
  steady('Reachable with steady revision.'),
  hard('Hard but possible. Plan extra sessions.'),
  impossible('Out of reach. Aim a bit lower.');

  const Reachability(this.message);
  final String message;

  static Reachability of(double needed) => switch (needed) {
    <= 0 => secured,
    <= 14 => steady,
    <= 20 => hard,
    _ => impossible,
  };
}
