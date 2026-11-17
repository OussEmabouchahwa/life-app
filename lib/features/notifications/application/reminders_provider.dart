import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/time_format.dart';
import '../../../shared/models/event_category.dart';
import '../../plan/application/plan_controller.dart';
import '../../prayers/data/prayer_repository.dart';
import '../../settings/application/settings_controller.dart';
import '../../study/application/study_providers.dart';
import '../data/notification_service.dart';
import '../domain/reminder.dart';

/// Reminders for the next two days, following the Settings toggles.
final remindersProvider = Provider<List<Reminder>>((ref) {
  final s = ref.watch(settingsProvider);
  final now = ref.watch(nowProvider);
  final days = [now.dateOnly, now.dateOnly.add(const Duration(days: 1))];

  return [
    if (s.prayerReminders)
      for (final day in days)
        for (final p in ref.watch(prayerRepositoryProvider).timesFor(day))
          Reminder(
            kind: ReminderKind.prayer,
            at: p.time,
            title: '${p.label} · ${TimeFormat.hm(p.time)}',
            body: 'Time for ${p.label}.',
          ),
    if (s.coachDeparture)
      for (final day in days)
        for (final i in ref.watch(itemsForDayProvider(day)))
          if (i.category == EventCategory.commute)
            Reminder(
              kind: ReminderKind.coach,
              at: i.start.subtract(const Duration(minutes: 20)),
              title: 'Coach at ${TimeFormat.hm(i.start)}',
              body: 'Leave in a few minutes to catch it.',
            ),
    if (s.examCountdown)
      for (final e in ref.watch(upcomingExamsProvider)) ...[
        // The evening before, then one hour before.
        Reminder(
          kind: ReminderKind.exam,
          at: e.start.dateOnly.subtract(const Duration(hours: 4)),
          title: 'Exam tomorrow · ${e.subject}',
          body:
              '${e.type.label} at ${TimeFormat.hm(e.start)}${e.room.isEmpty ? '' : ' · ${e.room}'}. Sleep well.',
        ),
        Reminder(
          kind: ReminderKind.exam,
          at: e.start.subtract(const Duration(hours: 1)),
          title: 'Exam in 1 hour · ${e.subject}',
          body: e.room.isEmpty ? 'Good luck.' : 'Room ${e.room}. Good luck.',
        ),
      ],
  ].where((r) => r.at.isAfter(now)).toList();
});

/// Schedules [remindersProvider] on the phone, only when the set of
/// reminders changes (the clock ticks every 30 s; the reminders rarely change).
final reminderSyncProvider = NotifierProvider<ReminderSync, int>(ReminderSync.new);

class ReminderSync extends Notifier<int> {
  String? _lastKey;

  @override
  int build() {
    final reminders = ref.watch(remindersProvider);
    final key = reminders.map((r) => '${r.id}|${r.title}').join(',');
    if (key != _lastKey) {
      _lastKey = key;
      ref.read(notificationServiceProvider).schedule(reminders);
    }
    return reminders.length;
  }
}
