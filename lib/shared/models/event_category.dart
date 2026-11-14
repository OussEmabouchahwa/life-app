import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';

/// Kind of item in the daily plan. Drives the colour bar and the label.
enum EventCategory {
  classes('Class', AppIcons.study),
  gym('Gym', AppIcons.dumbbell),
  study('Study', AppIcons.study),
  work('Work', AppIcons.briefcase),
  commute('Commute', AppIcons.pin);

  const EventCategory(this.label, this.icon);

  final String label;
  final IconData icon;

  Color color(AppColors c) => switch (this) {
    EventCategory.classes => c.catClass,
    EventCategory.gym => c.catGym,
    EventCategory.study => c.catStudy,
    EventCategory.work => c.catWork,
    EventCategory.commute => c.catCommute,
  };
}
