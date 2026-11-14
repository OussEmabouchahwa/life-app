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

enum SleepPlace {
  dar('Tunis · Dar'),
  birAli('Bir Ali · 60 km');

  const SleepPlace(this.label);
  final String label;
}

/// Everything the user picks in Settings and Onboarding.
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = AppLanguage.english,
    this.userName = 'Oussema',
    this.city = 'Tunis',
    this.calculationMethod = 'Tunisia',
    this.units = 'kg · cm',
    this.sleepPlace = SleepPlace.dar,
    this.prayerReminders = true,
    this.coachDeparture = true,
    this.examCountdown = false,
    this.onboarded = false,
  });

  final ThemeMode themeMode;
  final AppLanguage language;
  final String userName;
  final String city;
  final String calculationMethod;
  final String units;
  final SleepPlace sleepPlace;
  final bool prayerReminders;
  final bool coachDeparture;
  final bool examCountdown;
  final bool onboarded;

  AppSettings copyWith({
    ThemeMode? themeMode,
    AppLanguage? language,
    String? city,
    SleepPlace? sleepPlace,
    bool? prayerReminders,
    bool? coachDeparture,
    bool? examCountdown,
    bool? onboarded,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    language: language ?? this.language,
    userName: userName,
    city: city ?? this.city,
    calculationMethod: calculationMethod,
    units: units,
    sleepPlace: sleepPlace ?? this.sleepPlace,
    prayerReminders: prayerReminders ?? this.prayerReminders,
    coachDeparture: coachDeparture ?? this.coachDeparture,
    examCountdown: examCountdown ?? this.examCountdown,
    onboarded: onboarded ?? this.onboarded,
  );
}
