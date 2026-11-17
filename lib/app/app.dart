import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/responsive/responsive.dart';
import '../core/theme/app_theme.dart';
import '../features/notifications/application/reminders_provider.dart';
import '../features/settings/application/settings_controller.dart';
import '../features/settings/domain/app_settings.dart';
import 'router.dart';

class NizamApp extends ConsumerWidget {
  const NizamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    final language = ref.watch(settingsProvider.select((s) => s.language));

    // Keeps phone notifications in sync (prayers, coach, exams) for as long as the app runs.
    ref.listen(reminderSyncProvider, (_, _) {});

    return MaterialApp.router(
      title: 'Nizam',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      // Arabic / Tounsi switch the whole layout to RTL automatically.
      locale: language.locale,
      supportedLocales: [for (final l in AppLanguage.values) l.locale],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Scale typography to the screen once, here, instead of in every widget.
      builder: (context, child) =>
          Theme(data: AppTheme.scaled(Theme.of(context), context.scaleFactor), child: child!),
    );
  }
}
