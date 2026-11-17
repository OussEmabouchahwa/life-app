import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';

/// Kind of item in the daily plan. Drives the colour bar and the label.
enum EventCategory {
  classes('Class', AppIcons.study),
  exam('Exam', AppIcons.alert),
  study('Study', AppIcons.study),
  gym('Gym', AppIcons.dumbbell),
  work('Work', AppIcons.briefcase),
  commute('Commute', AppIcons.pin),
  other('Other', AppIcons.calendar);

  const EventCategory(this.label, this.icon);

  final String label;
  final IconData icon;

  /// Categories the user can pick in "Add event". Exams have their own form,
  /// commutes come from the coach settings.
  static const userPickable = [classes, study, gym, work, other];

  Color color(AppColors c) => switch (this) {
    EventCategory.classes => c.catClass,
    EventCategory.exam => c.danger,
    EventCategory.study => c.catStudy,
    EventCategory.gym => c.catGym,
    EventCategory.work => c.catWork,
    EventCategory.commute => c.catCommute,
    EventCategory.other => c.textSecondary,
  };
}
