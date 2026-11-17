import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';
import '../../../timetable/application/timetable_providers.dart';
import '../../application/study_providers.dart';
import '../widgets/course_card.dart';
import '../widgets/revision_goals_card.dart';
import '../widgets/week_stats_card.dart';

/// Figma 07 · Study – Revision. Done hours come from study sessions you tick
/// in your plan; goals are set per course.
class RevisionTab extends ConsumerWidget {
  const RevisionTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(revisionProgressProvider);
    void planSession() => context.push(Routes.addStudySession);
    void editGoals() => context.push(Routes.revisionGoals);

    return Column(
      children: [
        WeekStatsCard(week: ref.watch(revisionWeekProvider)),
        const VGap(16),
        SectionHeader(title: 'Weekly goals', action: 'Edit', onAction: editGoals),
        const VGap(14),
        if (progress.isEmpty)
          EmptyCard(
            title: 'No goals yet',
            message: 'Choose how many hours you want to revise each course per week.',
            actionLabel: 'Set goals',
            onAction: editGoals,
          )
        else
          RevisionGoalsCard(items: progress),
        const VGap(12),
        AppButton(
          label: 'Plan a study session',
          icon: AppIcons.plus,
          variant: AppButtonVariant.outlined,
          onPressed: planSession,
        ),
        const VGap(16),
        const SectionHeader(title: 'Courses'),
        const VGap(14),
        for (final c in ref.watch(courseProgressProvider)) ...[CourseCard(course: c), const VGap(12)],
      ],
    );
  }
}
