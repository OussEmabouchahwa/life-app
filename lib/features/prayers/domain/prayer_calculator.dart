import 'dart:math' as math;

import 'prayer.dart';

/// Calculation parameters. Tunisia (Ministry of Religious Affairs):
/// Fajr and Isha at 18° below the horizon, Asr when a shadow equals its
/// object's length (Maliki / Shafi'i, factor 1).
class CalculationParams {
  const CalculationParams({this.fajrAngle = 18, this.ishaAngle = 18, this.asrFactor = 1});

  static const tunisia = CalculationParams();

  final double fajrAngle;
  final double ishaAngle;
  final double asrFactor;
}

/// Offline prayer-time calculator (solar position, as in PrayTimes.org).
/// Works on the phone with no network: only coordinates and the date.
class PrayerCalculator {
  const PrayerCalculator({
    required this.latitude,
    required this.longitude,
    this.params = CalculationParams.tunisia,
  });

  final double latitude;
  final double longitude;
  final CalculationParams params;

  static const _sunriseAngle = 0.833;

  /// Five prayers of [day], in local time.
  List<PrayerTime> timesFor(DateTime day) {
    final jd = _julian(day.year, day.month, day.day) - longitude / (15 * 24);

    // Hours of the day (UTC + longitude correction applied at the end).
    double sunAngle(double angle, double guess, {required bool beforeNoon}) {
      final (decl, _) = _sun(jd + guess / 24);
      final noon = _midDay(jd, guess);
      final cosT = (-_sin(angle) - _sin(decl) * _sin(latitude)) / (_cos(decl) * _cos(latitude));
      final t = _acos(cosT.clamp(-1.0, 1.0)) / 15;
      return beforeNoon ? noon - t : noon + t;
    }

    double asr(double guess) {
      final (decl, _) = _sun(jd + guess / 24);
      final angle = -_acot(params.asrFactor + _tan((latitude - decl).abs()));
      return sunAngle(angle, guess, beforeNoon: false);
    }

    final hours = {
      Prayer.fajr: sunAngle(params.fajrAngle, 5, beforeNoon: true),
      Prayer.dhuhr: _midDay(jd, 12),
      Prayer.asr: asr(13),
      Prayer.maghrib: sunAngle(_sunriseAngle, 18, beforeNoon: false),
      Prayer.isha: sunAngle(params.ishaAngle, 18, beforeNoon: false),
    };

    return [
      for (final MapEntry(key: p, value: h) in hours.entries)
        PrayerTime(p, _toLocal(day, h - longitude / 15)),
    ];
  }

  /// Sunrise, used for Ramadan and the morning window.
  DateTime sunrise(DateTime day) {
    final jd = _julian(day.year, day.month, day.day) - longitude / (15 * 24);
    final (decl, _) = _sun(jd + 6 / 24);
    final noon = _midDay(jd, 6);
    final cosT = (-_sin(_sunriseAngle) - _sin(decl) * _sin(latitude)) / (_cos(decl) * _cos(latitude));
    return _toLocal(day, noon - _acos(cosT.clamp(-1.0, 1.0)) / 15 - longitude / 15);
  }

  /// UTC hour of [day] → local DateTime, rounded to the nearest minute.
  static DateTime _toLocal(DateTime day, double utcHours) {
    final minutes = (utcHours * 60).round();
    return DateTime.utc(day.year, day.month, day.day).add(Duration(minutes: minutes)).toLocal();
  }

  double _midDay(double jd, double guess) {
    final (_, eqt) = _sun(jd + guess / 24);
    return _fixHour(12 - eqt);
  }

  /// (declination, equation of time) for a Julian date.
  static (double, double) _sun(double jd) {
    final d = jd - 2451545.0;
    final g = _fixAngle(357.529 + 0.98560028 * d);
    final q = _fixAngle(280.459 + 0.98564736 * d);
    final l = _fixAngle(q + 1.915 * _sin(g) + 0.020 * _sin(2 * g));
    final e = 23.439 - 0.00000036 * d;
    final ra = _fixHour(_atan2(_cos(e) * _sin(l), _cos(l)) / 15);
    return (_asin(_sin(e) * _sin(l)), q / 15 - ra);
  }

  static double _julian(int y, int m, int d) {
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floorToDouble() + (30.6001 * (m + 1)).floorToDouble() + d + b - 1524.5;
  }

  static const _rad = math.pi / 180;
  static double _sin(double d) => math.sin(d * _rad);
  static double _cos(double d) => math.cos(d * _rad);
  static double _tan(double d) => math.tan(d * _rad);
  static double _asin(double x) => math.asin(x) / _rad;
  static double _acos(double x) => math.acos(x) / _rad;
  static double _atan2(double y, double x) => math.atan2(y, x) / _rad;
  static double _acot(double x) => math.atan(1 / x) / _rad;
  static double _fixAngle(double a) => a - 360 * (a / 360).floorToDouble();
  static double _fixHour(double h) => h - 24 * (h / 24).floorToDouble();
}
