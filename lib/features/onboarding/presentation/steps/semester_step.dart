import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';
import '../../../settings/application/settings_controller.dart';
import '../../../settings/domain/app_settings.dart';
import '../../../timetable/application/timetable_providers.dart';

/// What was imported from the timetable, and where the user usually sleeps.
class SemesterStep extends ConsumerWidget {
  const SemesterStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final sessions = ref.watch(allSessionsProvider);
    final courses = ref.watch(courseProgressProvider);
    final s = ref.watch(settingsProvider);
    final f = DateFormat('d MMM', locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: sessions.isEmpty
              ? Text('Loading your timetable…', style: context.text.body)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${courses.length} courses · ${sessions.length} classes', style: context.text.title),
                    Text(
                      '${f.format(sessions.first.start)} – ${f.format(sessions.last.start)}',
                      style: context.text.body.tint(c.textSecondary),
                    ),
                    const VGap(10),
                    Text(
                      courses.map((p) => p.name).join(' · '),
                      style: context.text.bodySmall.tint(c.textSecondary),
                    ),
                  ],
                ),
        ),
        const VGap(14),
        Text('Tonight I usually sleep at', style: context.text.bodyStrong),
        const VGap(8),
        SegmentedControl<SleepPlace>(
          values: SleepPlace.values,
          selected: s.sleepPlace,
          labelOf: s.placeLabel,
          onChanged: ref.read(settingsProvider.notifier).setSleepPlace,
        ),
        const VGap(6),
        Text(
          'From the far place, a coach is added on class days. Edit places and times in Settings › Commute.',
          style: context.text.bodySmall.tint(c.textSecondary),
        ),
      ],
    );
  }
}
