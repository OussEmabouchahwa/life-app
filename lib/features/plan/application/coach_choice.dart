import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/plan_repository.dart';

final coachTimesProvider = Provider<List<String>>((ref) => ref.watch(planRepositoryProvider).coachTimes());

/// Coach the user plans to take tomorrow morning.
final coachChoiceProvider = NotifierProvider<CoachChoice, String>(CoachChoice.new);

class CoachChoice extends Notifier<String> {
  @override
  String build() => ref.watch(coachTimesProvider).first;

  void select(String time) => state = time;
}
