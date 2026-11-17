import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// Figma 19 · Today – Offline. Everything important still works offline.
class OfflineNotice extends StatelessWidget {
  const OfflineNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 12,
      color: c.accentSoft,
      borderColor: c.accentSoft,
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: context.dp(AppSizes.icon), color: c.textPrimary),
          const HGap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You're offline", style: context.text.bodyStrong),
                Text(
                  'Prayer times, your plan and everything you saved still work. Weather and barcode lookup wait for a connection.',
                  style: context.text.bodySmall.tint(c.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
