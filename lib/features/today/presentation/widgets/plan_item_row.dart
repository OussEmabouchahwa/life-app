import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../../../shared/models/plan_item.dart';

/// 07:10 | Coach to faculty / Commute · Departs… | ✓ or NOW
class PlanItemRow extends StatelessWidget {
  const PlanItemRow({super.key, required this.item, required this.isNow, required this.onToggle});

  final PlanItem item;
  final bool isNow;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: context.padSym(h: 14, v: 9),
      child: Row(
        children: [
          SizedBox(
            width: context.dp(46),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(TimeFormat.hm(item.start), style: context.text.time, maxLines: 1),
            ),
          ),
          const HGap(12),
          CategoryBar(color: item.category.color(c)),
          const HGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.text.bodyStrong.copyWith(
                    decoration: item.done ? TextDecoration.lineThrough : null,
                    color: item.done ? c.textSecondary : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.subtitle,
                  style: context.text.bodySmall.tint(c.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const HGap(12),
          if (isNow && !item.done) const NowBadge() else CheckCircle(checked: item.done, onTap: onToggle),
        ],
      ),
    );
  }
}
