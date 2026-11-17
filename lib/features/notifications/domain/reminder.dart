import 'package:flutter/foundation.dart';

enum ReminderKind { prayer, coach, exam }

/// One notification to show at [at].
@immutable
class Reminder {
  const Reminder({required this.kind, required this.at, required this.title, required this.body});

  final ReminderKind kind;
  final DateTime at;
  final String title;
  final String body;

  /// Stable id from the time and kind, so rescheduling replaces, not duplicates.
  int get id => (at.millisecondsSinceEpoch ~/ 60000 * 4 + kind.index) & 0x7fffffff;
}
