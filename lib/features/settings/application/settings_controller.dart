import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

/// Single source of truth for user preferences. Every change is saved.
class SettingsController extends Notifier<AppSettings> {
  late final SettingsRepository _repo;

  @override
  AppSettings build() {
    _repo = ref.watch(settingsRepositoryProvider);
    return _repo.load();
  }

  void _update(AppSettings next) {
    state = next;
    _repo.save(next);
  }

  void setTheme(ThemeMode mode) => _update(state.copyWith(themeMode: mode));
  void setLanguage(AppLanguage l) => _update(state.copyWith(language: l));
  void setSleepPlace(SleepPlace p) => _update(state.copyWith(sleepPlace: p));
  void setPrayerReminders(bool v) => _update(state.copyWith(prayerReminders: v));
  void setCoachDeparture(bool v) => _update(state.copyWith(coachDeparture: v));
  void setExamCountdown(bool v) => _update(state.copyWith(examCountdown: v));
  void completeOnboarding() => _update(state.copyWith(onboarded: true));
}
