import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/application/settings_controller.dart';
import '../domain/prayer.dart';
import '../domain/prayer_calculator.dart';
import 'cities.dart';

/// The city chosen in Settings / Onboarding, with its coordinates.
final selectedCityProvider = Provider<City>(
  (ref) => Cities.byName(ref.watch(settingsProvider.select((s) => s.city))),
);

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  final city = ref.watch(selectedCityProvider);
  return CalculatedPrayerRepository(PrayerCalculator(latitude: city.lat, longitude: city.lng));
});

/// Source of prayer times.
abstract interface class PrayerRepository {
  List<PrayerTime> timesFor(DateTime day);
}

/// Calculated on the phone for the chosen city (works offline). Results are
/// cached per day because several screens ask for the same dates.
class CalculatedPrayerRepository implements PrayerRepository {
  CalculatedPrayerRepository(this._calculator);

  final PrayerCalculator _calculator;
  final _cache = <DateTime, List<PrayerTime>>{};

  @override
  List<PrayerTime> timesFor(DateTime day) =>
      _cache.putIfAbsent(DateTime(day.year, day.month, day.day), () => _calculator.timesFor(day));
}
