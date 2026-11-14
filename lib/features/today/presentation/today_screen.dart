import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../../plan/application/plan_controller.dart';
import '../../prayers/application/prayer_providers.dart';
import '../../settings/application/settings_controller.dart';
import '../data/weather_repository.dart';
import 'widgets/empty_day_card.dart';
import 'widgets/next_prayer_card.dart';
import 'widgets/plan_item_row.dart';
import 'widgets/today_header.dart';
import 'widgets/weather_card.dart';

/// Figma 01 · Today. Composes the blocks; all logic lives in providers.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(nowProvider);
    final items = ref.watch(todayItemsProvider);
    final remaining = items.where((i) => i.end.isAfter(now) || !i.done).toList();

    return AppPage(
      children: [
        TodayHeader(now: now, name: ref.watch(settingsProvider.select((s) => s.userName))),
        NextPrayerCard(next: ref.watch(nextPrayerProvider), today: ref.watch(todayPrayersProvider)),
        WeatherCard(hint: ref.watch(weatherHintProvider)),
        SectionHeader(title: "Today's plan", action: 'Full plan →', onAction: () => context.go(Routes.plan)),
        if (remaining.isEmpty)
          const EmptyDayCard()
        else
          AppCard(
            padding: 0,
            child: DividedColumn(
              children: [
                for (final item in items)
                  PlanItemRow(
                    item: item,
                    isNow: item.isNow(now),
                    onToggle: () => ref.read(completedItemsProvider.notifier).toggle(item.id),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
