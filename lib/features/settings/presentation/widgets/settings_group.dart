import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// "LANGUAGE" eyebrow above a card of rows.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [Eyebrow(title), const VGap(8), child],
  );
}

/// Label on the left, switch on the right.
class SwitchTile extends StatelessWidget {
  const SwitchTile({super.key, required this.title, required this.value, required this.onChanged});

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => AppTile(
    title: title,
    onTap: () => onChanged(!value),
    trailing: AppSwitch(value: value, onChanged: onChanged),
  );
}
