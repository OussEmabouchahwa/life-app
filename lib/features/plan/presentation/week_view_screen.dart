import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/ui.dart';
import '../application/week_summary.dart';
import 'widgets/week_day_row.dart';

/// Figma 16 · Week view.
class WeekViewScreen extends ConsumerWidget {
  const WeekViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final days = ref.watch(weekSummaryProvider);
    final heaviest = ref.watch(heaviestDayProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final range =
        '${DateFormat.MMMd(locale).format(days.first.day)} – '
        '${DateFormat.MMMd(locale).format(days.last.day)}';

    return AppPage(
      children: [
        ScreenHeader(title: 'Week', eyebrow: range, showBack: true),
        AppCard(
          padding: 0,
          child: DividedColumn(children: [for (final d in days) WeekDayRow(summary: d)]),
        ),
        if (heaviest != null)
          AppCard(
            color: c.accentSoft,
            borderColor: c.accentSoft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DateFormat.EEEE(locale).format(heaviest.day)} is your heaviest day',
                  style: context.text.bodyStrong,
                ),
                const VGap(4),
                Text(
                  '${TimeFormat.length(heaviest.planned)} planned. '
                  'Move a revision session to a lighter day?',
                  style: context.text.bodySmall.tint(c.textSecondary),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
