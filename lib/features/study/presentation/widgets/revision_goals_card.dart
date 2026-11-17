import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/study_models.dart';

/// Hours done vs goal per course this week.
class RevisionGoalsCard extends StatelessWidget {
  const RevisionGoalsCard({super.key, required this.items});

  final List<RevisionProgress> items;

  static String _h(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 15,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const VGap(14),
            Row(
              children: [
                Flexible(
                  child: Text(items[i].name, style: context.text.body.bold, overflow: TextOverflow.ellipsis),
                ),
                if (items[i].behind) ...[const HGap(8), const SoftTag(label: 'BEHIND', warning: true)],
                const Spacer(),
                const HGap(8),
                Text(
                  '${_h(items[i].doneHours)} / ${_h(items[i].goalHours)} h',
                  style: context.text.body.tint(c.textSecondary),
                ),
              ],
            ),
            const VGap(6),
            AppProgressBar(value: items[i].progress, color: items[i].behind ? c.danger : c.brand),
          ],
        ],
      ),
    );
  }
}
