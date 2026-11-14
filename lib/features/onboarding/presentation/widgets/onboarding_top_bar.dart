import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// "N" logo and the step dots.
class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({super.key, required this.step, required this.steps});

  final int step;
  final int steps;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Container(
          width: context.dp(52),
          height: context.dp(52),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.brand,
            borderRadius: BorderRadius.circular(context.dp(AppRadius.lg)),
          ),
          child: Text('N', style: context.text.display.tint(c.onBrand)),
        ),
        const Spacer(),
        for (var i = 0; i < steps; i++) ...[
          if (i > 0) const HGap(6),
          Container(
            width: context.dp(28),
            height: context.dp(4),
            decoration: BoxDecoration(
              color: i < step ? c.accent : c.line,
              borderRadius: BorderRadius.circular(context.dp(2)),
            ),
          ),
        ],
      ],
    );
  }
}
