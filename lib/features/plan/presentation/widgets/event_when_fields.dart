import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui.dart';
import '../../application/add_event_controller.dart';

/// Date · Starts · Length boxes, each opening the matching picker.
class EventWhenFields extends ConsumerWidget {
  const EventWhenFields({super.key, required this.args});

  final AddEventArgs args;

  static const _lengths = [30, 45, 60, 90, 120, 180, 240];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(addEventProvider(args));
    final ctrl = ref.read(addEventProvider(args).notifier);

    return FormRow(
      children: [
        DateField(label: 'Date', value: s.date, onChanged: ctrl.setDate),
        TimeField(label: 'Starts', minutes: s.startMinutes, onChanged: ctrl.setStart),
        PickerField<int>(
          label: 'Length',
          value: s.length.inMinutes,
          options: _lengths,
          labelOf: (m) => TimeFormat.length(Duration(minutes: m)),
          onChanged: (m) => ctrl.setLength(Duration(minutes: m)),
        ),
      ],
    );
  }
}
