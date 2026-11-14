import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

class RestTimerCard extends StatelessWidget {
  const RestTimerCard({super.key, required this.left, required this.progress, required this.onAddTime});

  final Duration left;
  final double progress;
  final VoidCallback onAddTime;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 17,
      color: c.brand,
      borderColor: c.brand,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow('Rest timer', color: c.onBrand.withValues(alpha: 0.7)),
                    Text(TimeFormat.ms(left), style: context.text.hero.tint(c.onBrand)),
                  ],
                ),
              ),
              SizedBox(
                width: context.wp(0.17),
                child: AppButton(label: '+15 s', height: 38, onPressed: onAddTime),
              ),
            ],
          ),
          const VGap(12),
          AppProgressBar(value: progress, color: c.accent, height: 4),
        ],
      ),
    );
  }
}
