import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../../prayers/domain/prayer.dart';

/// FAJR · DHUHR · ASR · MAGHRIB · ISHA with times; the next one is underlined in brass.
class PrayerStrip extends StatelessWidget {
  const PrayerStrip({super.key, required this.times, required this.highlighted});

  final List<PrayerTime> times;
  final Prayer highlighted;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        for (final t in times)
          Expanded(
            child: Column(
              children: [
                // Scale down instead of wrapping on narrow phones ("MAGHRIB").
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Eyebrow(t.prayer.label, color: c.onBrand.withValues(alpha: 0.7)),
                ),
                const VGap(2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(TimeFormat.hm(t.time), style: context.text.time.tint(c.onBrand)),
                ),
                const VGap(4),
                AnimatedContainer(
                  duration: AppDurations.normal,
                  width: context.dp(16),
                  height: context.dp(2),
                  color: t.prayer == highlighted ? c.accent : Colors.transparent,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
