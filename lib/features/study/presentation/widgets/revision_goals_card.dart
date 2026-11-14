import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/study_models.dart';

/// Hours done vs planned per subject this week.
class RevisionGoalsCard extends StatelessWidget {
  const RevisionGoalsCard({super.key, required this.goals});

  final List<RevisionGoal> goals;

  String _h(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 15,
      child: Column(
        children: [
          for (var i = 0; i < goals.length; i++) ...[
            if (i > 0) const VGap(14),
            Row(
              children: [
                Flexible(
                  child: Text(
                    goals[i].subject,
                    style: context.text.body.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (goals[i].behind) ...[const HGap(8), const SoftTag(label: 'BEHIND', warning: true)],
                const Spacer(),
                const HGap(8),
                Text(
                  '${_h(goals[i].doneHours)} / ${_h(goals[i].plannedHours)} h',
                  style: context.text.body.tint(c.textSecondary),
                ),
              ],
            ),
            const VGap(6),
            AppProgressBar(value: goals[i].progress, color: goals[i].behind ? c.danger : c.brand),
          ],
        ],
      ),
    );
  }
}
