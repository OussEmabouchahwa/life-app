import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// M Push · T Pull · W Legs … Tap a day to see its workout; today has a brass dot.
class SplitWeekStrip extends StatelessWidget {
  const SplitWeekStrip({
    super.key,
    required this.labels,
    required this.today,
    required this.selected,
    required this.onSelect,
  });

  /// Seven labels, Monday first ("Push", "Rest"…).
  final List<String> labels;

  /// Weekdays (DateTime.monday = 1).
  final int today;
  final int selected;
  final ValueChanged<int> onSelect;

  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        for (var i = 0; i < 7; i++) ...[
          if (i > 0) const HGap(6),
          Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i + 1),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                height: context.dp(58),
                decoration: BoxDecoration(
                  color: i + 1 == selected ? c.brand : (labels[i] == 'Rest' ? c.bgSunken : c.bgCard),
                  borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
                  border: Border.all(color: i + 1 == selected ? c.brand : c.line),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _letters[i],
                      style: context.text.caption.tint(i + 1 == selected ? c.onBrand : c.textSecondary),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        labels[i],
                        style: context.text.caption.bold.tint(i + 1 == selected ? c.onBrand : c.textPrimary),
                      ),
                    ),
                    const VGap(3),
                    Container(
                      width: context.dp(4),
                      height: context.dp(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i + 1 == today ? c.accent : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
