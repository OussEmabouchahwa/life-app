import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui.dart';
import '../../application/settings_controller.dart';
import '../../domain/app_settings.dart';

/// English · Français · العربية · Tounsi with a tick on the current one.
/// Shared by Settings and Onboarding. Picking Arabic switches the app to RTL.
class LanguageList extends ConsumerWidget {
  const LanguageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(settingsProvider.select((s) => s.language));
    return AppCard(
      padding: 0,
      child: DividedColumn(
        children: [
          for (final l in AppLanguage.values)
            AppTile(
              title: l.nativeName,
              subtitle: l.englishName,
              inlineSubtitle: true,
              onTap: () => ref.read(settingsProvider.notifier).setLanguage(l),
              trailing: CheckCircle(checked: l == current),
            ),
        ],
      ),
    );
  }
}
