import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../data/prayer_repository.dart';
import '../domain/prayer.dart';

/// Today's five prayers.
final todayPrayersProvider = Provider<List<PrayerTime>>((ref) {
  final now = ref.watch(nowProvider);
  return ref.watch(prayerRepositoryProvider).timesFor(now);
});

/// The next prayer from now (tomorrow's Fajr after Isha).
final nextPrayerProvider = Provider<NextPrayer>((ref) {
  final now = ref.watch(nowProvider);
  final repo = ref.watch(prayerRepositoryProvider);
  final upcoming = ref.watch(todayPrayersProvider).where((p) => p.time.isAfter(now));
  final next = upcoming.isNotEmpty ? upcoming.first : repo.timesFor(now.add(const Duration(days: 1))).first;
  return NextPrayer(next, next.time.difference(now));
});
