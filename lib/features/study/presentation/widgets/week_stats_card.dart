import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/study_models.dart';

/// PLANNED 8 h | DONE 5 h | STREAK 6 days
class WeekStatsCard extends StatelessWidget {
  const WeekStatsCard({super.key, required this.week});

  final RevisionWeek week;

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Planned', '${week.plannedHours} h'),
      ('Done', '${week.doneHours} h'),
      ('Streak', '${week.streakDays} days'),
    ];
    return AppCard(
      padding: 13,
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0) const VerticalDivider(width: 1),
              Expanded(
                child: Column(
                  children: [
                    Eyebrow(stats[i].$1),
                    const VGap(2),
                    Text(stats[i].$2, style: context.text.headline),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
