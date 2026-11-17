import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../application/fasting_providers.dart';

/// Figma 18 · Ramadan: countdown to iftar (or to the end of suhoor).
class FastingCard extends StatelessWidget {
  const FastingCard({super.key, required this.status});

  final FastingStatus status;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (label, sub) = switch (status.phase) {
      FastingPhase.suhoor => ('Suhoor time', 'Stop eating at ${TimeFormat.hm(status.imsak)} (imsak)'),
      FastingPhase.fasting => ('Fasting', 'Iftar at ${TimeFormat.hm(status.maghrib)}'),
      FastingPhase.iftar => ('Iftar time', 'Next fast starts at ${TimeFormat.hm(status.fajr)}'),
    };
    return AppCard(
      padding: 16,
      color: c.brand,
      borderColor: c.brand,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Eyebrow(label, color: c.onBrand.withValues(alpha: 0.75))),
              Icon(Icons.nightlight_round, color: c.accent, size: context.dp(AppSizes.icon)),
            ],
          ),
          const VGap(8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: TimeFormat.compact(status.remaining),
                  style: context.text.display.tint(c.onBrand),
                ),
                TextSpan(
                  text: status.phase == FastingPhase.fasting ? '  until iftar' : '  left',
                  style: context.text.body.tint(c.onBrand.withValues(alpha: 0.75)),
                ),
              ],
            ),
          ),
          const VGap(12),
          AppProgressBar(value: status.progress, color: c.accent),
          const VGap(10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Fajr ${TimeFormat.hm(status.fajr)}',
                  style: context.text.bodySmall.tint(c.onBrand.withValues(alpha: 0.75)),
                ),
              ),
              Text(sub, style: context.text.bodySmall.tint(c.onBrand).bold),
            ],
          ),
        ],
      ),
    );
  }
}
