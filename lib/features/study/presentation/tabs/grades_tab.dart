import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';
import '../../application/study_providers.dart';
import '../widgets/average_card.dart';
import '../widgets/grades_table.dart';

/// Figma 08 · Study – Grades. Tap a subject to enter marks, coefficient and weights.
class GradesTab extends ConsumerWidget {
  const GradesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final subjects = ref.watch(subjectsProvider);
    final average = ref.watch(weightedAverageProvider);
    final graded = subjects.where((s) => s.hasMarks).length;

    return Column(
      children: [
        if (average != null)
          AverageCard(average: average, graded: graded, total: subjects.length)
        else
          const EmptyCard(
            title: 'No marks yet',
            message: 'Tap a subject below to enter a DS, TP or exam mark. Your average updates right away.',
          ),
        const VGap(16),
        SectionHeader(
          title: 'By subject',
          action: 'Calculator →',
          onAction: () => context.push(Routes.gradeCalculator),
        ),
        const VGap(14),
        GradesTable(subjects: subjects, onTap: (s) => context.push(Routes.withId(Routes.gradeForm, s.id))),
        const VGap(14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, size: context.dp(16), color: c.textSecondary),
            const HGap(8),
            Expanded(
              child: Text(
                'Averages use the weights of each subject (default DS 30 %, TP 10 %, exam 60 %). '
                '"·" means the assessment does not count for that subject.',
                style: context.text.bodySmall.tint(c.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
