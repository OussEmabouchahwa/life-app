import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../../../shared/models/plan_item.dart';

/// Two horizontal lanes from 06:00 to 22:00: the fixed plan on top and the
/// new event underneath, so clashes are visible at a glance.
class DayGlanceLanes extends StatelessWidget {
  const DayGlanceLanes({super.key, required this.items, required this.newStart, required this.newEnd});

  final List<PlanItem> items;
  final DateTime newStart;
  final DateTime newEnd;

  static const _from = 6, _to = 22;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final laneH = context.dp(16);
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        double x(DateTime t) => ((t.hour + t.minute / 60 - _from) / (_to - _from)).clamp(0.0, 1.0) * w;

        Widget bar(DateTime s, DateTime e, Color color, double top) => Positioned(
          left: x(s),
          width: (x(e) - x(s)).clamp(2.0, w),
          top: top,
          height: laneH,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(context.dp(4))),
          ),
        );

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var h = _from; h <= _to; h += 4)
                  Text(h.toString().padLeft(2, '0'), style: context.text.caption.tint(c.textSecondary)),
              ],
            ),
            const VGap(6),
            SizedBox(
              height: laneH * 2 + context.dp(6),
              child: Stack(
                children: [
                  Positioned.fill(child: ColoredBox(color: c.bgSunken.withValues(alpha: 0.5))),
                  for (final i in items) bar(i.start, i.end, i.category.color(c), 0),
                  bar(newStart, newEnd, c.accent, laneH + context.dp(6)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
