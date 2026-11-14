import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../application/study_providers.dart';
import '../../timetable/application/timetable_providers.dart';
import 'tabs/exams_tab.dart';
import 'tabs/grades_tab.dart';
import 'tabs/revision_tab.dart';

/// Figma 06 / 07 / 08 · Study. Header and tabs here; each tab in its own file.
class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  static const _labels = {StudyTab.exams: 'Exams', StudyTab.revision: 'Revision', StudyTab.grades: 'Grades'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(studyTabProvider);

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: '${ref.watch(courseProgressProvider).length} courses this semester',
          title: 'Study',
          trailing: IconBoxButton(
            icon: AppIcons.plus,
            tooltip: 'Add',
            onPressed: () => context.push(Routes.addEvent),
          ),
        ),
        UnderlineTabs<StudyTab>(
          values: StudyTab.values,
          selected: tab,
          labelOf: (t) => _labels[t]!,
          onChanged: ref.read(studyTabProvider.notifier).select,
        ),
        AnimatedSwitcher(
          duration: AppDurations.normal,
          child: switch (tab) {
            StudyTab.exams => const ExamsTab(key: ValueKey(StudyTab.exams)),
            StudyTab.revision => const RevisionTab(key: ValueKey(StudyTab.revision)),
            StudyTab.grades => const GradesTab(key: ValueKey(StudyTab.grades)),
          },
        ),
      ],
    );
  }
}
