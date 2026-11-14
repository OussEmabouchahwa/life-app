import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../application/plan_controller.dart';
import 'widgets/sleep_location_card.dart';
import 'widgets/time_block_row.dart';
import 'widgets/week_strip.dart';

/// Figma 02 · Plan.
class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final selected = ref.watch(selectedDayProvider);
    final items = ref.watch(itemsForDayProvider(selected));
    final week = ref.watch(currentWeekProvider);

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: DateFormat.yMMMM(locale).format(selected),
          title: 'Plan',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconBoxButton(
                icon: AppIcons.calendar,
                tooltip: 'Timetable',
                onPressed: () => context.go(Routes.timetable),
              ),
              const HGap(8),
              IconBoxButton(
                icon: AppIcons.plus,
                tooltip: 'Add event',
                onPressed: () => context.push(Routes.addEvent),
              ),
            ],
          ),
        ),
        WeekStrip(
          days: week,
          selected: selected,
          onSelect: ref.read(selectedDayProvider.notifier).select,
          hasItems: (d) => ref.watch(itemsForDayProvider(d)).isNotEmpty,
        ),
        const SleepLocationCard(),
        SectionHeader(
          title: DateFormat('EEEE d', locale).format(selected),
          action: 'Week view →',
          onAction: () => context.go(Routes.weekView),
        ),
        if (items.isEmpty)
          Text('Nothing planned.', style: context.text.body.tint(context.colors.textSecondary))
        else
          Column(
            children: [
              for (final item in items) ...[TimeBlockRow(item: item), const VGap(8)],
            ],
          ),
      ],
    );
  }
}
