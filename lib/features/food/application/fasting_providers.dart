import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/clock_provider.dart';
import '../../prayers/data/prayer_repository.dart';
import '../../prayers/domain/prayer.dart';

enum FastingPhase { suhoor, fasting, iftar }

/// Where today's fast stands, from the real Fajr and Maghrib times.
@immutable
class FastingStatus {
  const FastingStatus({required this.phase, required this.fajr, required this.maghrib, required this.now});

  final FastingPhase phase;

  /// Fajr ends suhoor and starts the fast; Maghrib is iftar.
  final DateTime fajr;
  final DateTime maghrib;
  final DateTime now;

  /// Imsak, the usual "stop eating" time, 10 minutes before Fajr.
  DateTime get imsak => fajr.subtract(const Duration(minutes: 10));

  Duration get fastLength => maghrib.difference(fajr);

  /// What the countdown is counting to.
  DateTime get target => phase == FastingPhase.fasting ? maghrib : fajr;

  Duration get remaining => target.difference(now);

  double get progress => switch (phase) {
    FastingPhase.suhoor => 0,
    FastingPhase.iftar => 1,
    FastingPhase.fasting => now.difference(fajr).inSeconds / fastLength.inSeconds,
  };
}

final fastingStatusProvider = Provider<FastingStatus>((ref) {
  final now = ref.watch(nowProvider);
  final repo = ref.watch(prayerRepositoryProvider);
  DateTime at(DateTime day, Prayer p) => repo.timesFor(day).firstWhere((t) => t.prayer == p).time;

  final fajr = at(now, Prayer.fajr);
  final maghrib = at(now, Prayer.maghrib);
  if (now.isBefore(fajr)) {
    return FastingStatus(phase: FastingPhase.suhoor, fajr: fajr, maghrib: maghrib, now: now);
  }
  if (now.isBefore(maghrib)) {
    return FastingStatus(phase: FastingPhase.fasting, fajr: fajr, maghrib: maghrib, now: now);
  }
  // After iftar the next fast starts at tomorrow's Fajr.
  final tomorrow = now.add(const Duration(days: 1));
  return FastingStatus(
    phase: FastingPhase.iftar,
    fajr: at(tomorrow, Prayer.fajr),
    maghrib: at(tomorrow, Prayer.maghrib),
    now: now,
  );
});
