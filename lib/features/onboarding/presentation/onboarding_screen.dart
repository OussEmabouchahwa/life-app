import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/presentation/widgets/language_list.dart';
import 'steps/profile_step.dart';
import 'steps/semester_step.dart';
import 'widgets/onboarding_top_bar.dart';

/// Figma 14 · Onboarding: language → name and city → semester.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _steps = 3;
  static const _titles = ['Welcome to Nizam', 'About you', 'Your semester'];
  static const _intros = [
    'One planner for classes, prayer, study, training and food. Choose your language.',
    'Prayer times are calculated on your phone for your city, so they work offline.',
    'Your faculty timetable is already in the app. Check it and you are ready.',
  ];

  int _step = 0;

  void _finish() {
    ref.read(settingsProvider.notifier).completeOnboarding();
    context.go(Routes.today);
  }

  void _next() => _step == _steps - 1 ? _finish() : setState(() => _step++);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppPage(
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(label: _step == _steps - 1 ? 'Start' : 'Continue', onPressed: _next),
          TextButton(
            onPressed: _step == 0 ? _finish : () => setState(() => _step--),
            child: Text(
              _step == 0 ? 'Set up later in Settings' : 'Back',
              style: context.text.body.tint(c.textSecondary),
            ),
          ),
        ],
      ),
      children: [
        OnboardingTopBar(step: _step + 1, steps: _steps),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow('Step ${_step + 1} of $_steps'),
            const VGap(4),
            Text(_titles[_step], style: context.text.display),
            const VGap(6),
            Text(_intros[_step], style: context.text.body.tint(c.textSecondary)),
          ],
        ),
        AnimatedSwitcher(
          duration: AppDurations.normal,
          child: switch (_step) {
            0 => const LanguageList(key: ValueKey(0)),
            1 => const ProfileStep(key: ValueKey(1)),
            _ => const SemesterStep(key: ValueKey(2)),
          },
        ),
      ],
    );
  }
}
