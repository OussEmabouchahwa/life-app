import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../../../shared/models/plan_item.dart';

/// Start/end times on the side, the block card on the right.
class TimeBlockRow extends StatelessWidget {
  const TimeBlockRow({super.key, required this.item, this.onTap});

  final PlanItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final muted = context.text.caption.tint(c.textSecondary);
    return Row(
      children: [
        SizedBox(
          width: context.dp(44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TimeFormat.hm(item.start), style: context.text.bodySmall.bold),
              Text(TimeFormat.hm(item.end), style: muted),
            ],
          ),
        ),
        const HGap(10),
        Expanded(
          child: AppCard(
            onTap: onTap,
            padding: 0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: context.dp(3), color: item.category.color(c)),
                  Expanded(
                    child: Padding(
                      padding: context.padSym(h: 12, v: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: context.text.bodyStrong),
                          Text(
                            item.subtitle,
                            style: context.text.bodySmall.tint(c.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
