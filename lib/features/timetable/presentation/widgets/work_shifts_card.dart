import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';
import '../../../plan/data/work_shifts.dart';

/// Weekly work shifts with add / edit.
class WorkShiftsCard extends StatelessWidget {
  const WorkShiftsCard({super.key, required this.shifts});

  final List<WorkShift> shifts;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sorted = [...shifts]
      ..sort((a, b) => (a.weekday * 1440 + a.startMinutes) - (b.weekday * 1440 + b.startMinutes));
    return AppCard(
      padding: 15,
      child: Column(
        children: [
          Row(
            children: [
              Icon(AppIcons.briefcase, size: context.dp(AppSizes.iconSmall), color: c.catWork),
              const HGap(8),
              Expanded(child: Text('Work shifts', style: context.text.bodyStrong)),
              GestureDetector(
                onTap: () => context.push(Routes.shiftForm),
                child: Text('Add', style: context.text.bodySmall.tint(c.accent).bold),
              ),
            ],
          ),
          if (sorted.isEmpty) ...[
            const VGap(8),
            Text(
              'No shifts. Add them and they appear in your plan every week.',
              style: context.text.bodySmall.tint(c.textSecondary),
            ),
          ],
          for (final s in sorted) ...[
            const VGap(10),
            InkWell(
              onTap: () => context.push(Routes.withId(Routes.shiftForm, s.id)),
              child: Row(
                children: [
                  CategoryBar(color: c.catWork, height: 18),
                  const HGap(10),
                  Expanded(
                    child: Text(
                      s.place.isEmpty ? s.dayName : '${s.dayName} · ${s.place}',
                      style: context.text.body,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(s.hours, style: context.text.body.bold),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
