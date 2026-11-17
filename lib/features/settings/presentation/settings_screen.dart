import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../../prayers/data/cities.dart';
import '../application/settings_controller.dart';
import 'widgets/language_list.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/settings_group.dart';

/// Figma 11 · Settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _themeLabels = {ThemeMode.system: 'System', ThemeMode.light: 'Light', ThemeMode.dark: 'Dark'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);

    Future<void> editName() async {
      final v = await showTextInputSheet(context: context, title: 'Your name', initialValue: s.userName);
      if (v != null) ctrl.setUserName(v);
    }

    Future<void> pickCity() async {
      final city = await showOptionsSheet<City>(
        context: context,
        title: 'City for prayer times',
        options: Cities.all,
        labelOf: (c) => c.name,
        selected: Cities.byName(s.city),
      );
      if (city != null) ctrl.setCity(city.name);
    }

    return AppPage(
      children: [
        const ScreenHeader(title: 'Settings', showBack: true),
        SettingsGroup(
          title: 'Profile',
          child: AppCard(
            padding: 0,
            child: DividedColumn(
              children: [
                AppTile(
                  title: 'Photo',
                  subtitle: 'Shown at the top of Today',
                  leading: const ProfileAvatar(size: 44),
                  onTap: () => showProfilePhotoSheet(context, ref),
                ),
                ValueTile(title: 'Name', value: s.userName.isEmpty ? 'Add' : s.userName, onTap: editName),
                ValueTile(title: 'City', value: s.city, onTap: pickCity),
              ],
            ),
          ),
        ),
        const SettingsGroup(title: 'Language', child: LanguageList()),
        SettingsGroup(
          title: 'Appearance',
          child: AppCard(
            padding: 10,
            child: SegmentedControl<ThemeMode>(
              values: ThemeMode.values,
              selected: s.themeMode,
              labelOf: (m) => _themeLabels[m]!,
              onChanged: ctrl.setTheme,
            ),
          ),
        ),
        SettingsGroup(
          title: 'Prayer times',
          child: AppCard(
            padding: 0,
            child: DividedColumn(
              children: [
                const AppTile(
                  title: 'Method',
                  subtitle: 'Tunisia · Fajr and Isha at 18°, calculated offline',
                ),
                ValueTile(title: 'City', value: s.city, onTap: pickCity),
              ],
            ),
          ),
        ),
        SettingsGroup(
          title: 'Commute',
          child: AppCard(
            padding: 0,
            child: ValueTile(
              title: 'Places, coach times',
              value: '${s.commuteMinutes} min',
              onTap: () => context.push(Routes.commuteSettings),
            ),
          ),
        ),
        SettingsGroup(
          title: 'Notifications',
          child: AppCard(
            padding: 0,
            child: DividedColumn(
              children: [
                SwitchTile(
                  title: 'Prayer reminders',
                  value: s.prayerReminders,
                  onChanged: ctrl.setPrayerReminders,
                ),
                SwitchTile(
                  title: 'Coach departure',
                  value: s.coachDeparture,
                  onChanged: ctrl.setCoachDeparture,
                ),
                SwitchTile(title: 'Exam countdown', value: s.examCountdown, onChanged: ctrl.setExamCountdown),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
