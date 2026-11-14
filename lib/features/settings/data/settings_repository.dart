import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';

/// Provided in `main.dart` once SharedPreferences is loaded.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override sharedPreferencesProvider in main()'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);

/// Persists [AppSettings] on the device (the design works fully offline).
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _theme = 'theme';
  static const _language = 'language';
  static const _city = 'city';
  static const _sleep = 'sleep';
  static const _prayer = 'n_prayer';
  static const _coach = 'n_coach';
  static const _exam = 'n_exam';
  static const _onboarded = 'onboarded';

  AppSettings load() {
    const d = AppSettings();
    T pick<T extends Enum>(List<T> values, String key, T fallback) {
      final i = _prefs.getInt(key);
      return i != null && i < values.length ? values[i] : fallback;
    }

    return AppSettings(
      themeMode: pick(ThemeMode.values, _theme, d.themeMode),
      language: pick(AppLanguage.values, _language, d.language),
      sleepPlace: pick(SleepPlace.values, _sleep, d.sleepPlace),
      city: _prefs.getString(_city) ?? d.city,
      prayerReminders: _prefs.getBool(_prayer) ?? d.prayerReminders,
      coachDeparture: _prefs.getBool(_coach) ?? d.coachDeparture,
      examCountdown: _prefs.getBool(_exam) ?? d.examCountdown,
      onboarded: _prefs.getBool(_onboarded) ?? d.onboarded,
    );
  }

  Future<void> save(AppSettings s) => Future.wait([
    _prefs.setInt(_theme, s.themeMode.index),
    _prefs.setInt(_language, s.language.index),
    _prefs.setInt(_sleep, s.sleepPlace.index),
    _prefs.setString(_city, s.city),
    _prefs.setBool(_prayer, s.prayerReminders),
    _prefs.setBool(_coach, s.coachDeparture),
    _prefs.setBool(_exam, s.examCountdown),
    _prefs.setBool(_onboarded, s.onboarded),
  ]);
}
