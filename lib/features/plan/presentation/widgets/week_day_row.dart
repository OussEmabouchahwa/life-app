import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';
import '../../application/week_summary.dart';

/// Mon | ▌ 4 items · 6 h 10 / Light day, gym at 14:00 | 26
class WeekDayRow extends StatelessWidget {
  const WeekDayRow({super.key, required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final loadColor = switch (summary.load) {
      DayLoad.heavy => c.danger,
      DayLoad.normal => c.accent,
      DayLoad.light => c.brand,
    };
    return Padding(
      padding: context.padSym(h: 15, v: 10),
      child: Row(
        children: [
          SizedBox(
            width: context.dp(36),
            child: Text(DateFormat.E(locale).format(summary.day), style: context.text.bodySmall.bold),
          ),
          const HGap(12),
          CategoryBar(color: loadColor, height: 36),
          const HGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summary.headline, style: context.text.bodyStrong),
                Text(summary.hint, style: context.text.bodySmall.tint(c.textSecondary)),
              ],
            ),
          ),
          Text('${summary.day.day}', style: context.text.time.tint(c.textSecondary)),
        ],
      ),
    );
  }
}
