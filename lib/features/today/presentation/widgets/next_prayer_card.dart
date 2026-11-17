import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../../prayers/domain/prayer.dart';
import 'prayer_strip.dart';

/// Bottle-green card: next prayer, countdown and the five times of the day.
class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({super.key, required this.next, required this.today});

  final NextPrayer next;
  final List<PrayerTime> today;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final muted = c.onBrand.withValues(alpha: 0.7);
    return AppCard(
      color: c.brand,
      borderColor: c.brand,
      padding: 17,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow('Next prayer', color: muted),
                    Text(next.time.label, style: context.text.display.tint(c.onBrand)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(TimeFormat.hm(next.time.time), style: context.text.timeLarge.tint(c.onBrand)),
                  Text(
                    'in ${TimeFormat.compact(next.remaining)}',
                    style: context.text.bodySmall.tint(c.accent).bold,
                  ),
                ],
              ),
            ],
          ),
          const VGap(12),
          Divider(color: c.onBrand.withValues(alpha: 0.15)),
          const VGap(12),
          PrayerStrip(times: today, highlighted: next.time.prayer),
        ],
      ),
    );
  }
}
