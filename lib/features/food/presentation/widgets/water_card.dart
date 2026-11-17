import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// Glasses of water today. Tap a segment to set the count (tap the last
/// filled one again to remove it).
class WaterCard extends StatelessWidget {
  const WaterCard({super.key, required this.glasses, required this.goal, required this.onChanged, this.hint});

  final int glasses;
  final int goal;
  final ValueChanged<int> onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop_outlined, size: context.dp(18), color: c.catStudy),
              const HGap(6),
              Expanded(child: Text('Water', style: context.text.bodyStrong)),
              Text('$glasses / $goal glasses', style: context.text.bodySmall.tint(c.textSecondary)),
            ],
          ),
          const VGap(10),
          Row(
            children: [
              for (var i = 0; i < goal; i++) ...[
                if (i > 0) const HGap(4),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(i + 1 == glasses ? i : i + 1),
                    child: Padding(
                      padding: context.padSym(v: 6),
                      child: AnimatedContainer(
                        duration: AppDurations.fast,
                        height: context.dp(8),
                        decoration: BoxDecoration(
                          color: i < glasses ? c.catStudy : c.bgSunken,
                          borderRadius: BorderRadius.circular(context.dp(4)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (hint != null) Text(hint!, style: context.text.caption.tint(c.textSecondary)),
        ],
      ),
    );
  }
}
