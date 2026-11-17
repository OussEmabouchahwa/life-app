import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/clock_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../../plan/application/plan_controller.dart';
import '../application/timetable_providers.dart';
import 'widgets/session_details_sheet.dart';
import 'widgets/session_kind_style.dart';
import 'widgets/timetable_grid.dart';
import 'widgets/week_switcher.dart';
import 'widgets/work_shifts_card.dart';

/// Figma 03 · Timetable, filled from the faculty timetable.
class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monday = ref.watch(timetableWeekProvider);
    final week = ref.read(timetableWeekProvider.notifier);
    final sessions = ref.watch(sessionsOfWeekProvider(monday));
    final weekNo = ref.watch(semesterWeekProvider(monday));
    final loading = ref.watch(sessionsProvider).isLoading;
    final now = ref.watch(nowProvider);
    final dayCount = sessions.any((s) => s.start.weekday == DateTime.saturday) ? 6 : 5;

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: weekNo == null ? 'Outside the semester' : 'Week $weekNo · ${sessions.length} classes',
          title: 'Timetable',
          showBack: true,
          trailing: IconBoxButton(
            icon: AppIcons.plus,
            tooltip: 'Add event',
            onPressed: () => context.push(Routes.addEvent),
          ),
        ),
        WeekSwitcher(
          monday: monday,
          dayCount: dayCount,
          today: now,
          onPrevious: week.previous,
          onNext: week.next,
          onToday: week.thisWeek,
        ),
        if (loading)
          const Center(child: CircularProgressIndicator())
        else if (sessions.isEmpty)
          Text('No classes this week.', style: context.text.body.tint(context.colors.textSecondary))
        else
          TimetableGrid(
            sessions: sessions,
            dayCount: dayCount,
            now: now,
            onTap: (s) => showSessionDetails(context, s),
          ),
        const SessionLegend(),
        WorkShiftsCard(shifts: ref.watch(workShiftsProvider)),
      ],
    );
  }
}
