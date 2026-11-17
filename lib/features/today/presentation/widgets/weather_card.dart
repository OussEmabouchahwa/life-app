import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../data/weather_repository.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.hint});

  final WeatherHint hint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      color: c.bgSunken,
      borderColor: c.bgSunken,
      padding: 12,
      child: Row(
        children: [
          Icon(
            hint.rain ? AppIcons.rain : Icons.wb_sunny_outlined,
            size: context.dp(24),
            color: c.textPrimary,
          ),
          const HGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hint.summary, style: context.text.bodyStrong),
                Text(hint.advice, style: context.text.bodySmall.tint(c.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
