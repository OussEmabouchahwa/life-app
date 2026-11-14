import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/clock_provider.dart';
import '../../../../core/ui.dart';
import '../../application/study_providers.dart';
import '../../data/study_repository.dart';
import '../widgets/exam_card.dart';
import '../widgets/revision_goals_card.dart';

/// Figma 06 · Study – Exams.
class ExamsTab extends ConsumerWidget {
  const ExamsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(nowProvider).dateOnly;
    return Column(
      children: [
        for (final e in ref.watch(examsProvider)) ...[ExamCard(exam: e, today: today), const VGap(12)],
        const VGap(4),
        SectionHeader(
          title: "This week's revision",
          action: 'Open →',
          onAction: () => ref.read(studyTabProvider.notifier).select(StudyTab.revision),
        ),
        const VGap(14),
        RevisionGoalsCard(goals: ref.watch(studyRepositoryProvider).revisionGoals()),
      ],
    );
  }
}
