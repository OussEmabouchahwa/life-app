import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../application/study_providers.dart';

/// GOAL 8 h | DONE 5 h | STREAK 6 days
class WeekStatsCard extends StatelessWidget {
  const WeekStatsCard({super.key, required this.week});

  final RevisionWeek week;

  static String _h(double v) =>
      v == v.roundToDouble() ? '${v.toStringAsFixed(0)} h' : '${v.toStringAsFixed(1)} h';

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Goal', _h(week.planned)),
      ('Done', _h(week.done)),
      ('Streak', week.streakDays == 1 ? '1 day' : '${week.streakDays} days'),
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(stats[i].$2, style: context.text.headline),
                    ),
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
