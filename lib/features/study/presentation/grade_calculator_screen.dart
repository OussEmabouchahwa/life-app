import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui.dart';
import '../application/grade_calculator_controller.dart';
import '../application/study_providers.dart';
import '../domain/study_models.dart';
import 'widgets/needed_result_card.dart';
import 'widgets/target_card.dart';

/// Figma 13 · Grade calculator: "What do I need in the exam?"
class GradeCalculatorScreen extends ConsumerWidget {
  const GradeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final s = ref.watch(gradeCalculatorProvider);
    final ctrl = ref.read(gradeCalculatorProvider.notifier);

    Future<void> pickSubject() async {
      final picked = await showModalBottomSheet<SubjectGrades>(
        context: context,
        backgroundColor: c.bgCard,
        builder: (sheet) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final g in ref.read(gradesProvider))
                AppTile(title: g.name, subtitle: g.prof, onTap: () => Navigator.pop(sheet, g)),
            ],
          ),
        ),
      );
      if (picked != null) ctrl.selectSubject(picked);
    }

    return AppPage(
      children: [
        const ScreenHeader(eyebrow: 'Study · Grades', title: 'Calculator', showBack: true),
        AppCard(
          padding: 0,
          child: ValueTile(title: s.subject.name, value: 'coef ${s.subject.coef}', onTap: pickSubject),
        ),
        AppCard(
          padding: 0,
          child: DividedColumn(
            children: [
              for (final a in Assessment.values)
                AppTile(
                  title: a.label,
                  subtitle: 'weight ${(a.weight * 100).round()}%',
                  inlineSubtitle: true,
                  trailing: Text(
                    s.subject.marks[a]?.toString() ?? '?',
                    style: context.text.timeLarge.tint(s.subject.marks[a] == null ? c.accent : c.textPrimary),
                  ),
                ),
            ],
          ),
        ),
        TargetCard(target: s.target, onChanged: ctrl.setTarget),
        NeededResultCard(needed: s.needed),
      ],
    );
  }
}
