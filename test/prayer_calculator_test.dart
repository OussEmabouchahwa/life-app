import 'package:flutter_test/flutter_test.dart';
import 'package:nizam/core/utils/time_format.dart';
import 'package:nizam/features/prayers/data/cities.dart';
import 'package:nizam/features/prayers/domain/prayer_calculator.dart';

/// Reference values from api.aladhan.com, method 18 (Tunisia), timezone
/// Africa/Tunis (UTC+1, no daylight saving). Times are compared in UTC+1.
void main() {
  const references = {
    ('Tunis', '2026-11-17'): ['05:29', '12:04', '14:49', '17:09', '18:39'],
    ('Tunis', '2026-06-21'): ['03:08', '12:21', '16:13', '19:42', '21:34'],
    ('Sfax', '2026-11-17'): ['05:25', '12:02', '14:51', '17:11', '18:38'],
    ('Sfax', '2026-06-21'): ['03:18', '12:19', '16:06', '19:33', '21:20'],
  };

  int minutesOf(String hm) => int.parse(hm.substring(0, 2)) * 60 + int.parse(hm.substring(3));

  for (final MapEntry(key: (cityName, date), value: expected) in references.entries) {
    test('$cityName $date matches the Tunisian method within 1 minute', () {
      final city = Cities.byName(cityName);
      final calc = PrayerCalculator(latitude: city.lat, longitude: city.lng);
      final times = calc.timesFor(DateTime.parse(date));

      for (var i = 0; i < 5; i++) {
        final tunisTime = times[i].time.toUtc().add(const Duration(hours: 1));
        final got = TimeFormat.hm(tunisTime);
        expect(
          (minutesOf(got) - minutesOf(expected[i])).abs(),
          lessThanOrEqualTo(1),
          reason: '${times[i].prayer.label}: got $got, expected ${expected[i]}',
        );
      }
    });
  }
}
