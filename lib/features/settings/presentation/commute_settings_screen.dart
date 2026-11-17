import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui.dart';
import '../application/settings_controller.dart';

/// Edits the two sleeping places, the commute length and coach departures.
class CommuteSettingsScreen extends ConsumerStatefulWidget {
  const CommuteSettingsScreen({super.key});

  @override
  ConsumerState<CommuteSettingsScreen> createState() => _CommuteSettingsScreenState();
}

class _CommuteSettingsScreenState extends ConsumerState<CommuteSettingsScreen> {
  late final _initial = ref.read(settingsProvider);
  late String _near = _initial.nearPlace;
  late String _far = _initial.farPlace;
  late int _minutes = _initial.commuteMinutes;
  late final List<int> _coaches = [for (final t in _initial.coachTimes) _parse(t)]..sort();

  static int _parse(String hm) => int.parse(hm.substring(0, 2)) * 60 + int.parse(hm.substring(3, 5));

  Future<void> _addCoach() async {
    final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 7, minute: 0));
    if (t == null) return;
    final m = t.hour * 60 + t.minute;
    if (_coaches.contains(m)) return;
    setState(
      () => _coaches
        ..add(m)
        ..sort(),
    );
  }

  void _save() {
    final ctrl = ref.read(settingsProvider.notifier)
      ..setPlaces(
        near: _near.isEmpty ? _initial.nearPlace : _near,
        far: _far.isEmpty ? _initial.farPlace : _far,
      );
    ctrl.setCommute(minutes: _minutes, coachTimes: [for (final m in _coaches) TimeFormat.minutes(m)]);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return FormPage(
      title: 'Commute',
      eyebrow: 'Settings',
      onSave: _save,
      canSave: _coaches.isNotEmpty,
      children: [
        FormSection(
          title: 'Where you sleep',
          children: [
            AppTextField(
              label: 'Near the faculty',
              initialValue: _near,
              onChanged: (v) => setState(() => _near = v),
            ),
            AppTextField(
              label: 'Far place (coach needed)',
              initialValue: _far,
              onChanged: (v) => setState(() => _far = v),
            ),
          ],
        ),
        FormSection(
          title: 'Coach',
          children: [
            StepperField(
              label: 'Trip length',
              value: _minutes,
              min: 5,
              max: 240,
              step: 5,
              unit: 'min',
              onChanged: (v) => setState(() => _minutes = v),
            ),
            Wrap(
              spacing: context.dp(8),
              runSpacing: context.dp(8),
              children: [
                for (final m in _coaches)
                  InputChip(
                    label: Text(TimeFormat.minutes(m), style: context.text.body.bold),
                    backgroundColor: c.bgCard,
                    side: BorderSide(color: c.line),
                    onDeleted: () => setState(() => _coaches.remove(m)),
                  ),
                ActionChip(
                  avatar: Icon(AppIcons.plus, size: context.dp(16), color: c.brand),
                  label: Text('Add departure', style: context.text.body.tint(c.brand)),
                  backgroundColor: c.brandSoft,
                  side: BorderSide.none,
                  onPressed: _addCoach,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
