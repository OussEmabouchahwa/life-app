import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';
import '../../application/study_providers.dart';
import '../../data/study_repository.dart';
import '../widgets/average_card.dart';
import '../widgets/grades_table.dart';

/// Figma 08 · Study – Grades.
class GradesTab extends ConsumerWidget {
  const GradesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final average = ref.watch(weightedAverageProvider);
    final nextExam = ref.watch(examsProvider).firstOrNull;

    return Column(
      children: [
        if (average != null)
          AverageCard(average: average, lastTerm: ref.watch(studyRepositoryProvider).lastTermAverage()),
        const VGap(16),
        SectionHeader(
          title: 'By subject',
          action: 'Calculator →',
          onAction: () => context.push(Routes.gradeCalculator),
        ),
        const VGap(14),
        GradesTable(subjects: ref.watch(gradesProvider)),
        const VGap(14),
        if (nextExam != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(AppIcons.clock, size: context.dp(16), color: c.textSecondary),
              const HGap(8),
              Expanded(
                child: Text(
                  'Exam grades are added after each contrôle. Next: ${nextExam.subject}.',
                  style: context.text.bodySmall.tint(c.textSecondary),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
