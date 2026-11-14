import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui.dart';
import '../application/settings_controller.dart';
import 'widgets/language_list.dart';
import 'widgets/settings_group.dart';

/// Figma 11 · Settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _themeLabels = {ThemeMode.system: 'System', ThemeMode.light: 'Light', ThemeMode.dark: 'Dark'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);

    return AppPage(
      children: [
        const ScreenHeader(title: 'Settings', showBack: true),
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
          title: 'Prayer times & units',
          child: AppCard(
            padding: 0,
            child: DividedColumn(
              children: [
                ValueTile(title: 'Calculation method', value: s.calculationMethod),
                ValueTile(title: 'City', value: s.city),
                ValueTile(title: 'Units', value: s.units),
              ],
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
