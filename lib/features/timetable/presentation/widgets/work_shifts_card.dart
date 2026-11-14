import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../../plan/data/work_shifts.dart';

class WorkShiftsCard extends StatelessWidget {
  const WorkShiftsCard({super.key, required this.shifts});

  final List<WorkShift> shifts;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 15,
      child: Column(
        children: [
          Row(
            children: [
              Icon(AppIcons.briefcase, size: context.dp(AppSizes.iconSmall), color: c.catWork),
              const HGap(8),
              Expanded(child: Text('Work shifts this week', style: context.text.bodyStrong)),
              Text('Edit', style: context.text.bodySmall.tint(c.textSecondary).bold),
            ],
          ),
          for (final s in shifts) ...[
            const VGap(10),
            Row(
              children: [
                CategoryBar(color: c.catWork, height: 18),
                const HGap(10),
                Expanded(child: Text(s.day, style: context.text.body)),
                Text(s.hours, style: context.text.body.bold),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
