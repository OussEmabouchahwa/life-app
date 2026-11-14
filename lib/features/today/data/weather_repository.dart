import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class WeatherHint {
  const WeatherHint({required this.summary, required this.advice});

  final String summary;
  final String advice;
}

/// Tomorrow's weather with a practical hint. Demo value until a weather API
/// is connected.
final weatherHintProvider = Provider<WeatherHint>(
  (ref) => const WeatherHint(
    summary: 'Tomorrow: rain, 15–19°',
    advice: 'Bring an umbrella and leave 10 min early.',
  ),
);
