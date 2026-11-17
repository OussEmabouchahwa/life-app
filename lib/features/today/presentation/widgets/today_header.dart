import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/ui.dart';
import '../../../settings/presentation/widgets/profile_avatar.dart';

/// Profile photo, date, greeting with the user's name, settings button.
class TodayHeader extends StatelessWidget {
  const TodayHeader({super.key, required this.now, required this.name});

  final DateTime now;
  final String name;

  String get _greeting => switch (now.hour) {
    < 12 => 'Good morning,',
    < 18 => 'Good afternoon,',
    _ => 'Good evening,',
  };

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final date = DateFormat('EEEE · d MMMM y', locale).format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const ProfileAvatar(size: 56),
            const HGap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow(date),
                  const VGap(4),
                  Text(_greeting, style: context.text.headline),
                  if (name.isNotEmpty) Text(name, style: context.text.headline),
                ],
              ),
            ),
            IconBoxButton(
              icon: AppIcons.sliders,
              tooltip: 'Settings',
              onPressed: () => context.push(Routes.settings),
            ),
          ],
        ),
        const VGap(12),
        const Divider(),
      ],
    );
  }
}
