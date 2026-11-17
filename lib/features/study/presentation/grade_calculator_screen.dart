import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../application/grade_calculator_controller.dart';
import '../application/study_providers.dart';
import '../domain/grade_math.dart';
import '../domain/study_models.dart';
import 'widgets/grades_table.dart';
import 'widgets/needed_result_card.dart';
import 'widgets/target_card.dart';

/// Figma 13 · Grade calculator: "What do I need in the exam?"
class GradeCalculatorScreen extends ConsumerWidget {
  const GradeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(gradeCalculatorProvider);
    final ctrl = ref.read(gradeCalculatorProvider.notifier);
    final subjects = ref.watch(subjectsProvider);
    final subject = subjects.where((s) => s.id == state.subjectId).firstOrNull;

    if (subject == null) {
      return const AppPage(
        children: [
          ScreenHeader(eyebrow: 'Study · Grades', title: 'Calculator', showBack: true),
          EmptyCard(title: 'No subjects', message: 'Your courses come from the timetable.'),
        ],
      );
    }

    Future<void> pickSubject() async {
      final picked = await showOptionsSheet<SubjectGrades>(
        context: context,
        title: 'Subject',
        options: subjects,
        labelOf: (s) => s.name,
        subtitleOf: (s) => s.average == null ? 'No marks yet' : 'Average ${s.average!.toStringAsFixed(1)}',
        selected: subject,
      );
      if (picked != null) ctrl.selectSubject(picked.id);
    }

    return AppPage(
      children: [
        const ScreenHeader(eyebrow: 'Study · Grades', title: 'Calculator', showBack: true),
        AppCard(
          padding: 0,
          child: ValueTile(
            title: subject.name,
            value: 'coef ${GradesTable.mark(subject.coef)}',
            onTap: pickSubject,
          ),
        ),
        AppCard(
          padding: 0,
          child: DividedColumn(
            children: [
              for (final a in subject.assessments)
                AppTile(
                  title: a.label,
                  subtitle: 'weight ${(subject.weightOf(a) * 100).round()} %',
                  inlineSubtitle: true,
                  onTap: () => context.push(Routes.withId(Routes.gradeForm, subject.id)),
                  trailing: Text(
                    subject.marks[a] == null ? '?' : GradesTable.mark(subject.marks[a]),
                    style: context.text.timeLarge.tint(subject.marks[a] == null ? c.accent : c.textPrimary),
                  ),
                ),
            ],
          ),
        ),
        TargetCard(target: state.target, onChanged: ctrl.setTarget),
        NeededResultCard(needed: GradeMath.neededMark(subject, state.target)),
      ],
    );
  }
}
