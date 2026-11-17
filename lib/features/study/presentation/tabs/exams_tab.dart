import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/clock_provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';
import '../../application/study_providers.dart';
import '../widgets/exam_card.dart';
import '../widgets/revision_goals_card.dart';

/// Figma 06 · Study – Exams.
class ExamsTab extends ConsumerStatefulWidget {
  const ExamsTab({super.key});

  @override
  ConsumerState<ExamsTab> createState() => _ExamsTabState();
}

class _ExamsTabState extends ConsumerState<ExamsTab> {
  bool _showPast = false;

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(nowProvider).dateOnly;
    final upcoming = ref.watch(upcomingExamsProvider);
    final past = ref.watch(pastExamsProvider);
    final progress = ref.watch(revisionProgressProvider);
    void open(String? id) => context.push(Routes.withId(Routes.examForm, id));

    return Column(
      children: [
        if (upcoming.isEmpty)
          EmptyCard(
            title: 'No exams yet',
            message: 'Add your exam dates to get a countdown, see them in your plan and get a reminder the day before.',
            actionLabel: 'Add exam',
            onAction: () => open(null),
          )
        else
          for (final e in upcoming) ...[
            ExamCard(exam: e, today: today, onTap: () => open(e.id)),
            const VGap(12),
          ],
        if (past.isNotEmpty) ...[
          const VGap(8),
          AppCard(
            padding: 12,
            onTap: () => setState(() => _showPast = !_showPast),
            child: Row(
              children: [
                Expanded(child: Text('Past exams (${past.length})', style: context.text.body)),
                Icon(_showPast ? Icons.expand_less_rounded : Icons.expand_more_rounded),
              ],
            ),
          ),
          if (_showPast)
            for (final e in past) ...[
              const VGap(12),
              ExamCard(exam: e, today: today, onTap: () => open(e.id)),
            ],
        ],
        const VGap(16),
        SectionHeader(
          title: "This week's revision",
          action: 'Open →',
          onAction: () => ref.read(studyTabProvider.notifier).select(StudyTab.revision),
        ),
        const VGap(14),
        if (progress.isEmpty)
          Text(
            'Set weekly revision goals in the Revision tab.',
            style: context.text.body.tint(context.colors.textSecondary),
          )
        else
          RevisionGoalsCard(items: progress),
      ],
    );
  }
}
