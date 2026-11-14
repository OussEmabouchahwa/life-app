import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/prayer.dart';

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) => const FixedPrayerRepository());

/// Source of prayer times. The design calculates them on the phone (offline);
/// swap [FixedPrayerRepository] for a calculator (e.g. the `adhan` package)
/// without touching the UI.
abstract interface class PrayerRepository {
  List<PrayerTime> timesFor(DateTime day);
}

/// Times from the design (Tunis, late October).
class FixedPrayerRepository implements PrayerRepository {
  const FixedPrayerRepository();

  static const _times = {
    Prayer.fajr: (5, 12),
    Prayer.dhuhr: (12, 8),
    Prayer.asr: (15, 21),
    Prayer.maghrib: (17, 48),
    Prayer.isha: (19, 12),
  };

  @override
  List<PrayerTime> timesFor(DateTime day) => [
    for (final MapEntry(key: p, value: (h, m)) in _times.entries)
      PrayerTime(p, DateTime(day.year, day.month, day.day, h, m)),
  ];
}
