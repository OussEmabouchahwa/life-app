import 'package:flutter/foundation.dart';

enum Prayer {
  fajr('Fajr', 'الفجر'),
  dhuhr('Dhuhr', 'الظهر'),
  asr('Asr', 'العصر'),
  maghrib('Maghrib', 'المغرب'),
  isha('Isha', 'العشاء');

  const Prayer(this.label, this.arabic);

  final String label;
  final String arabic;
}

@immutable
class PrayerTime {
  const PrayerTime(this.prayer, this.time);

  final Prayer prayer;
  final DateTime time;

  /// Time kept free around a prayer when checking plan conflicts.
  static const window = Duration(minutes: 24);

  DateTime get windowEnd => time.add(window);
}

/// Next prayer and how long until it.
@immutable
class NextPrayer {
  const NextPrayer(this.time, this.remaining);

  final PrayerTime time;
  final Duration remaining;
}
