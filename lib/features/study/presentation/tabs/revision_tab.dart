import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';
import '../../../timetable/application/timetable_providers.dart';
import '../../data/study_repository.dart';
import '../widgets/course_card.dart';
import '../widgets/week_stats_card.dart';

/// Figma 07 · Study – Revision.
class RevisionTab extends ConsumerWidget {
  const RevisionTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(studyRepositoryProvider);
    void addSession() => context.push(Routes.addEvent);

    return Column(
      children: [
        WeekStatsCard(week: repo.revisionWeek()),
        const VGap(16),
        SectionHeader(title: 'Courses', action: 'Add session', onAction: addSession),
        const VGap(14),
        for (final c in ref.watch(courseProgressProvider)) ...[CourseCard(course: c), const VGap(12)],
        AppButton(
          label: 'Plan a session',
          icon: AppIcons.plus,
          variant: AppButtonVariant.outlined,
          onPressed: addSession,
        ),
      ],
    );
  }
}
