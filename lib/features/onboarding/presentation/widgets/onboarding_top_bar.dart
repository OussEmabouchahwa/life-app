import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../../../core/widgets/brand/logo_mark.dart';

/// Logo and the step dots.
class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({super.key, required this.step, required this.steps});

  final int step;
  final int steps;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        LogoMark(size: context.dp(56)),
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
