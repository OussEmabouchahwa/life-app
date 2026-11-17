import 'package:flutter/material.dart';

enum AppLanguage {
  english('English', 'Default', Locale('en')),
  french('Français', 'French', Locale('fr')),
  arabic('العربية', 'Arabic', Locale('ar')),
  tounsi('Tounsi', 'Tunisian', Locale('ar', 'TN'));

  const AppLanguage(this.nativeName, this.englishName, this.locale);

  final String nativeName;
  final String englishName;
  final Locale locale;
}

/// Where the user sleeps tonight. From the far place they take the coach.
enum SleepPlace { near, far }

/// Everything the user picks in Settings and Onboarding.
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = AppLanguage.english,
    this.userName = '',
    this.city = 'Tunis',
    this.sleepPlace = SleepPlace.near,
    this.nearPlace = 'Near faculty',
    this.farPlace = 'Family home',
    this.commuteMinutes = 55,
    this.coachTimes = const ['07:10', '07:40', '08:15'],
    this.prayerReminders = true,
    this.coachDeparture = true,
    this.examCountdown = true,
    this.onboarded = false,
  });

  final ThemeMode themeMode;
  final AppLanguage language;
  final String userName;

  /// Name of a city in `Cities.all` (prayer times and weather).
  final String city;
  final SleepPlace sleepPlace;
  final String nearPlace;
  final String farPlace;
  final int commuteMinutes;

  /// "07:10" departures from the far place.
  final List<String> coachTimes;
  final bool prayerReminders;
  final bool coachDeparture;
  final bool examCountdown;
  final bool onboarded;

  String placeLabel(SleepPlace p) => p == SleepPlace.near ? nearPlace : farPlace;

  AppSettings copyWith({
    ThemeMode? themeMode,
    AppLanguage? language,
    String? userName,
    String? city,
    SleepPlace? sleepPlace,
    String? nearPlace,
    String? farPlace,
    int? commuteMinutes,
    List<String>? coachTimes,
    bool? prayerReminders,
    bool? coachDeparture,
    bool? examCountdown,
    bool? onboarded,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    language: language ?? this.language,
    userName: userName ?? this.userName,
    city: city ?? this.city,
    sleepPlace: sleepPlace ?? this.sleepPlace,
    nearPlace: nearPlace ?? this.nearPlace,
    farPlace: farPlace ?? this.farPlace,
    commuteMinutes: commuteMinutes ?? this.commuteMinutes,
    coachTimes: coachTimes ?? this.coachTimes,
    prayerReminders: prayerReminders ?? this.prayerReminders,
    coachDeparture: coachDeparture ?? this.coachDeparture,
    examCountdown: examCountdown ?? this.examCountdown,
    onboarded: onboarded ?? this.onboarded,
  );

  Map<String, dynamic> toJson() => {
    'theme': themeMode.name,
    'language': language.name,
    'userName': userName,
    'city': city,
    'sleepPlace': sleepPlace.name,
    'nearPlace': nearPlace,
    'farPlace': farPlace,
    'commuteMinutes': commuteMinutes,
    'coachTimes': coachTimes,
    'prayerReminders': prayerReminders,
    'coachDeparture': coachDeparture,
    'examCountdown': examCountdown,
    'onboarded': onboarded,
  };

  factory AppSettings.fromJson(Map<String, dynamic> j) {
    const d = AppSettings();
    T pick<T extends Enum>(List<T> values, Object? name, T fallback) =>
        values.where((v) => v.name == name).firstOrNull ?? fallback;
    return AppSettings(
      themeMode: pick(ThemeMode.values, j['theme'], d.themeMode),
      language: pick(AppLanguage.values, j['language'], d.language),
      userName: j['userName'] as String? ?? d.userName,
      city: j['city'] as String? ?? d.city,
      sleepPlace: pick(SleepPlace.values, j['sleepPlace'], d.sleepPlace),
      nearPlace: j['nearPlace'] as String? ?? d.nearPlace,
      farPlace: j['farPlace'] as String? ?? d.farPlace,
      commuteMinutes: j['commuteMinutes'] as int? ?? d.commuteMinutes,
      coachTimes: (j['coachTimes'] as List?)?.cast<String>() ?? d.coachTimes,
      prayerReminders: j['prayerReminders'] as bool? ?? d.prayerReminders,
      coachDeparture: j['coachDeparture'] as bool? ?? d.coachDeparture,
      examCountdown: j['examCountdown'] as bool? ?? d.examCountdown,
      onboarded: j['onboarded'] as bool? ?? d.onboarded,
    );
  }
}
