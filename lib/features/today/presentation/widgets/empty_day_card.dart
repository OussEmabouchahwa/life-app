import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';

/// "Nothing left today" state (Figma 17 · Today – Empty).
class EmptyDayCard extends StatelessWidget {
  const EmptyDayCard({super.key, this.hasPastItems = false});

  /// True when today had items that are all over or done.
  final bool hasPastItems;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 21,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(hasPastItems ? 'Nothing left today' : 'Nothing planned today', style: context.text.headline),
          const VGap(6),
          Text(
            hasPastItems
                ? 'Everything is done or over. Plan tomorrow or add a study session.'
                : 'No class today. Add a study session, a workout or anything else.',
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
