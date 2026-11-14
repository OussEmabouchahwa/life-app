import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/class_session.dart';

/// Colours per session kind, shared by the grid, the legend and the sheet.
extension SessionKindStyle on SessionKind {
  Color background(AppColors c) => switch (this) {
    SessionKind.lecture => c.brandSoft,
    SessionKind.practical => c.catStudy.withValues(alpha: 0.18),
    SessionKind.transversal => c.accentSoft,
  };

  Color marker(AppColors c) => switch (this) {
    SessionKind.lecture => c.brand,
    SessionKind.practical => c.catStudy,
    SessionKind.transversal => c.accent,
  };
}

/// ■ Cours  ■ TP  ■ Langues & droit
class SessionLegend extends StatelessWidget {
  const SessionLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Wrap(
      spacing: context.dp(16),
      runSpacing: context.dp(6),
      children: [
        for (final k in SessionKind.values)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: context.dp(12),
                height: context.dp(12),
                decoration: BoxDecoration(
                  color: k.background(c),
                  border: Border.all(color: k.marker(c)),
                  borderRadius: BorderRadius.circular(context.dp(3)),
                ),
              ),
              const HGap(6),
              Text(k.label, style: context.text.caption.tint(c.textSecondary)),
            ],
          ),
      ],
    );
  }
}
