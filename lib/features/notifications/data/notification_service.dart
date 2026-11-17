import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/reminder.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

/// Schedules local notifications on Android and iOS. Does nothing elsewhere
/// (web preview, tests), so callers never need to check the platform.
class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<bool>? _ready;

  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  /// Android limits pending alarms; two days of reminders stay well below it.
  static const _maxPending = 60;

  Future<bool> _init() => _ready ??= () async {
    tzdata.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } on Object {
      tz.setLocalLocation(tz.getLocation('Africa/Tunis'));
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? true;
  }();

  /// Replaces every pending reminder with [reminders]. Never throws: a
  /// missing permission or plugin must not break the app.
  Future<void> schedule(List<Reminder> reminders) async {
    try {
      await _schedule(reminders);
    } on Object catch (e) {
      debugPrint('Reminders not scheduled: $e');
    }
  }

  Future<void> _schedule(List<Reminder> reminders) async {
    if (!supported || !await _init()) return;
    await _plugin.cancelAllPendingNotifications();
    final sorted = [...reminders]..sort((a, b) => a.at.compareTo(b.at));
    for (final r in sorted.take(_maxPending)) {
      await _plugin.zonedSchedule(
        id: r.id,
        title: r.title,
        body: r.body,
        scheduledDate: tz.TZDateTime.from(r.at, tz.local),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            r.kind.name,
            switch (r.kind) {
              ReminderKind.prayer => 'Prayer times',
              ReminderKind.coach => 'Coach departure',
              ReminderKind.exam => 'Exams',
            },
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        // Inexact: no special alarm permission needed, a few seconds late at most.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }
}
