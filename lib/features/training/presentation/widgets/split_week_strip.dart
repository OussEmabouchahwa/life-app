import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// M Push · T Pull · W Legs … with today highlighted.
class SplitWeekStrip extends StatelessWidget {
  const SplitWeekStrip({super.key, required this.split, required this.todayIndex});

  final List<String> split;
  final int todayIndex;

  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        for (var i = 0; i < split.length; i++) ...[
          if (i > 0) const HGap(6),
          Expanded(
            child: Container(
              height: context.dp(55),
              decoration: BoxDecoration(
                color: i == todayIndex ? c.brand : (split[i] == 'Rest' ? c.bgSunken : c.bgCard),
                borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
                border: Border.all(color: i == todayIndex ? c.brand : c.line),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _letters[i],
                    style: context.text.caption.tint(i == todayIndex ? c.onBrand : c.textSecondary),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      split[i],
                      style: context.text.caption.bold.tint(i == todayIndex ? c.onBrand : c.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
