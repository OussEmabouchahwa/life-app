import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/presentation/widgets/language_list.dart';
import 'widgets/onboarding_top_bar.dart';

/// Figma 14 · Onboarding (step 1: language and city).
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final s = ref.watch(settingsProvider);

    void finish() {
      ref.read(settingsProvider.notifier).completeOnboarding();
      context.go(Routes.today);
    }

    return AppPage(
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(label: 'Continue', onPressed: finish),
          TextButton(
            onPressed: finish,
            child: Text('Set up later in Settings', style: context.text.body.tint(c.textSecondary)),
          ),
        ],
      ),
      children: [
        const OnboardingTopBar(step: 1, steps: 3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Step 1 of 3'),
            const VGap(4),
            Text('Welcome to Nizam', style: context.text.display),
            const VGap(6),
            Text(
              'Choose your language and city. Prayer times are calculated on your phone, '
              'so they work offline.',
              style: context.text.body.tint(c.textSecondary),
            ),
          ],
        ),
        const LanguageList(),
        AppCard(
          padding: 0,
          child: DividedColumn(
            children: [
              ValueTile(title: 'City for prayer times', value: s.city),
              ValueTile(title: 'Tonight I usually sleep at', value: s.sleepPlace.label),
            ],
          ),
        ),
      ],
    );
  }
}
