import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';

/// "Nothing left today" state (Figma 17 · Today – Empty).
class EmptyDayCard extends StatelessWidget {
  const EmptyDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 21,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Nothing left today', style: context.text.headline),
          const VGap(6),
          Text(
            'Your day is clear. Add a session or import your timetable.',
            style: context.text.body.tint(c.textSecondary),
          ),
          const VGap(20),
          AppButton(
            label: 'Add a session',
            icon: AppIcons.plus,
            onPressed: () => context.push(Routes.addEvent),
          ),
          const VGap(10),
          AppButton(
            label: 'Import my timetable',
            variant: AppButtonVariant.outlined,
            onPressed: () => context.go(Routes.timetable),
          ),
        ],
      ),
    );
  }
}
