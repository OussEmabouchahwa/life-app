import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../settings/application/settings_controller.dart';

/// Departures from the far sleeping place (edited in Settings › Commute).
final coachTimesProvider = Provider<List<String>>(
  (ref) => ref.watch(settingsProvider.select((s) => s.coachTimes)),
);

/// Coach the user plans to take. Remembered on the device.
final coachChoiceProvider = NotifierProvider<CoachChoice, String?>(CoachChoice.new);

class CoachChoice extends Notifier<String?> {
  static const _key = 'coach_choice';

  @override
  String? build() {
    final times = ref.watch(coachTimesProvider);
    final saved = ref.read(sharedPreferencesProvider).getString(_key);
    return times.contains(saved) ? saved : times.firstOrNull;
  }

  void select(String time) {
    state = time;
    ref.read(sharedPreferencesProvider).setString(_key, time);
  }
}
