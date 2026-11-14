import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui.dart';
import '../../../settings/application/settings_controller.dart';
import '../../../settings/domain/app_settings.dart';
import '../../application/coach_choice.dart';

/// "Tonight I sleep at" + place switch + coach departures.
class SleepLocationCard extends ConsumerWidget {
  const SleepLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final place = ref.watch(settingsProvider.select((s) => s.sleepPlace));
    final coach = ref.watch(coachChoiceProvider);

    return AppCard(
      padding: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('Tonight I sleep at', style: context.text.bodyStrong)),
              Icon(AppIcons.pin, size: context.dp(AppSizes.icon), color: c.textSecondary),
            ],
          ),
          const VGap(12),
          SegmentedControl<SleepPlace>(
            values: SleepPlace.values,
            selected: place,
            labelOf: (p) => p.label,
            onChanged: ref.read(settingsProvider.notifier).setSleepPlace,
          ),
          const VGap(12),
          Row(
            children: [
              Icon(AppIcons.clock, size: context.dp(AppSizes.iconSmall), color: c.textSecondary),
              const HGap(6),
              Text('Coach', style: context.text.body.tint(c.textSecondary)),
              const HGap(8),
              // Wraps to a second line on narrow phones instead of overflowing.
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: context.dp(8),
                  runSpacing: context.dp(6),
                  children: [
                    for (final t in ref.watch(coachTimesProvider))
                      ChoicePill(
                        label: t,
                        dense: true,
                        height: 26,
                        selected: t == coach,
                        onTap: () => ref.read(coachChoiceProvider.notifier).select(t),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
