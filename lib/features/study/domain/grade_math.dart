import 'study_models.dart';

/// Pure grade calculations. No Flutter imports, so they are trivial to test.
abstract final class GradeMath {
  /// Average of subject averages weighted by coefficient (13.6 / 20).
  static double? weightedAverage(List<SubjectGrades> subjects) {
    var sum = 0.0, coefs = 0.0;
    for (final s in subjects) {
      final avg = s.average;
      if (avg == null) continue;
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
    var known = 0.0, missingWeight = 0.0;
    for (final a in Assessment.values) {
      final mark = s.marks[a];
      if (mark == null) {
        missingWeight += a.weight;
      } else {
        known += a.weight * mark;
      }
    }
    if (missingWeight == 0) return null;
    return (target - known) / missingWeight;
  }
}

enum Reachability {
  secured('Already secured, keep it up.'),
  steady('Reachable with steady revision.'),
  hard('Hard but possible. Plan extra sessions.'),
  impossible('Out of reach this term. Aim a bit lower.');

  const Reachability(this.message);
  final String message;

  static Reachability of(double needed) => switch (needed) {
    <= 0 => secured,
    <= 14 => steady,
    <= 20 => hard,
    _ => impossible,
  };
}
