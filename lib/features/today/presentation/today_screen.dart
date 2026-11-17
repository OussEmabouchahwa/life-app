import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../../plan/application/plan_controller.dart';
import '../../plan/application/task_providers.dart';
import '../../prayers/application/prayer_providers.dart';
import '../../settings/application/settings_controller.dart';
import '../data/weather_repository.dart';
import 'widgets/due_tasks_card.dart';
import 'widgets/empty_day_card.dart';
import 'widgets/next_prayer_card.dart';
import 'widgets/offline_notice.dart';
import 'widgets/plan_item_row.dart';
import 'widgets/today_header.dart';
import 'widgets/weather_card.dart';

/// Figma 01 · Today (and 17 · Empty, 19 · Offline). Composes the blocks;
/// all logic lives in providers.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(nowProvider);
    final items = ref.watch(todayItemsProvider);
    final remaining = items.where((i) => i.end.isAfter(now) && !i.done).toList();
    final online = ref.watch(isOnlineProvider).value ?? true;
    final weather = ref.watch(weatherHintProvider).value;
    final dueTasks = ref.watch(dueNowTasksProvider);

    return AppPage(
      children: [
        TodayHeader(now: now, name: ref.watch(settingsProvider.select((s) => s.userName))),
        if (!online) const OfflineNotice(),
        NextPrayerCard(next: ref.watch(nextPrayerProvider), today: ref.watch(todayPrayersProvider)),
        if (weather != null) WeatherCard(hint: weather),
        if (dueTasks.isNotEmpty) DueTasksCard(tasks: dueTasks, now: now),
        SectionHeader(title: "Today's plan", action: 'Full plan →', onAction: () => context.go(Routes.plan)),
        if (items.isEmpty || remaining.isEmpty) EmptyDayCard(hasPastItems: items.isNotEmpty),
        if (items.isNotEmpty)
          AppCard(
            padding: 0,
            child: DividedColumn(
              children: [
                for (final item in items)
                  PlanItemRow(
                    item: item,
                    isNow: item.isNow(now),
                    onToggle: () => ref.read(completedItemsProvider.notifier).toggle(item.id),
                    onTap: item.route == null ? null : () => context.push(item.route!),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
