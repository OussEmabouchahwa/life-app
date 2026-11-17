import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../../prayers/domain/prayer.dart';

/// "Clashes with Asr prayer" with Move / Keep actions.
class PrayerConflictCard extends StatelessWidget {
  const PrayerConflictCard({
    super.key,
    required this.prayer,
    required this.eventStart,
    required this.eventEnd,
    required this.onMove,
    required this.onKeep,
  });

  final PrayerTime prayer;
  final DateTime eventStart;
  final DateTime eventEnd;
  final VoidCallback onMove;
  final VoidCallback onKeep;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final moveTo = TimeFormat.hm(prayer.windowEnd);
    return AppCard(
      padding: 15,
      color: c.accentSoft,
      borderColor: c.accent.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(AppIcons.alert, size: context.dp(AppSizes.icon), color: c.danger),
              const HGap(8),
              Expanded(child: Text('Clashes with ${prayer.label} prayer', style: context.text.bodyStrong)),
            ],
          ),
          const VGap(8),
          Text(
            '${prayer.label} is ${TimeFormat.hm(prayer.time)}–$moveTo and your event runs '
            '${TimeFormat.hm(eventStart)}–${TimeFormat.hm(eventEnd)}.',
            style: context.text.bodySmall.tint(c.textSecondary),
          ),
          const VGap(12),
          Row(
            children: [
              Expanded(
                child: AppButton(label: 'Move to $moveTo', height: 40, onPressed: onMove),
              ),
              const HGap(8),
              Expanded(
                child: AppButton(
                  label: 'Keep anyway',
                  height: 40,
                  variant: AppButtonVariant.outlined,
                  onPressed: onKeep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
