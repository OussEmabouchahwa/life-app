import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/storage/local_store.dart';
import '../../prayers/data/prayer_repository.dart';

/// Tomorrow's weather with a practical hint.
@immutable
class WeatherHint {
  const WeatherHint({
    required this.summary,
    required this.advice,
    required this.rain,
    required this.fetchedAt,
  });

  final String summary;
  final String advice;
  final bool rain;
  final DateTime fetchedAt;

  /// Builds the hint from an Open-Meteo daily forecast (index 1 = tomorrow).
  static WeatherHint? fromOpenMeteo(Map<String, dynamic> json, DateTime fetchedAt) {
    final d = json['daily'] as Map<String, dynamic>?;
    if (d == null || (d['time'] as List).length < 2) return null;
    T at<T>(String k) => (d[k] as List)[1] as T;
    final code = at<num>('weather_code').toInt();
    final max = at<num>('temperature_2m_max').round(), min = at<num>('temperature_2m_min').round();
    final rainChance = (d['precipitation_probability_max'] as List?)?[1] as num? ?? 0;
    final rain = rainChance >= 50 || _rainCodes.contains(code);

    final advice = switch (code) {
      _ when code >= 95 => 'Storms expected. Leave early and stay safe.',
      _ when rain => 'Bring an umbrella and leave 10 min early.',
      _ when max >= 32 => 'Hot day: carry water and avoid the midday sun.',
      _ when min <= 8 => 'Cold morning: dress warmly for the coach.',
      _ => 'Good weather for the day.',
    };
    return WeatherHint(
      summary: 'Tomorrow: ${_describe(code)}, $min–$max°',
      advice: advice,
      rain: rain,
      fetchedAt: fetchedAt,
    );
  }

  static const _rainCodes = {51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82, 95, 96, 99};

  /// WMO weather codes in plain words.
  static String _describe(int code) => switch (code) {
    0 => 'clear sky',
    1 || 2 => 'partly cloudy',
    3 => 'cloudy',
    45 || 48 => 'fog',
    >= 51 && <= 57 => 'drizzle',
    >= 61 && <= 67 => 'rain',
    >= 71 && <= 77 => 'snow',
    >= 80 && <= 82 => 'showers',
    >= 95 => 'thunderstorms',
    _ => 'mixed weather',
  };
}

/// Forecast for the chosen city from Open-Meteo (free, no account). Only
/// the city's public coordinates are sent. The last answer is kept so the
/// card still shows something offline.
final weatherHintProvider = FutureProvider<WeatherHint?>((ref) async {
  final city = ref.watch(selectedCityProvider);
  final store = ref.watch(localStoreProvider);
  final cacheKey = 'weather_${city.name}';

  WeatherHint? fromCache() {
    final cached = store.readMap(cacheKey);
    if (cached == null) return null;
    return WeatherHint.fromOpenMeteo(
      cached['body'] as Map<String, dynamic>,
      DateTime.parse(cached['at'] as String),
    );
  }

  final cached = fromCache();
  if (cached != null && DateTime.now().difference(cached.fetchedAt) < const Duration(hours: 3)) return cached;

  try {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${city.lat}',
      'longitude': '${city.lng}',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'Africa/Tunis',
      'forecast_days': '2',
    });
    final res = await http.get(uri).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) return cached;
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final now = DateTime.now();
    await store.writeMap(cacheKey, {'at': now.toIso8601String(), 'body': body});
    return WeatherHint.fromOpenMeteo(body, now);
  } on Exception {
    return cached;
  }
});
