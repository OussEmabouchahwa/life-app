import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';
import '../../application/add_event_controller.dart';

/// Date · Starts · Length boxes, each opening the matching picker.
class EventWhenFields extends ConsumerWidget {
  const EventWhenFields({super.key});

  static const _lengths = [30, 45, 60, 90, 120, 180];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(addEventProvider);
    final ctrl = ref.read(addEventProvider.notifier);
    final locale = Localizations.localeOf(context).languageCode;

    Future<void> pickDate() async {
      final d = await showDatePicker(
        context: context,
        initialDate: s.date,
        firstDate: DateTime.now().subtract(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (d != null) ctrl.setDate(d);
    }

    Future<void> pickStart() async {
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: s.startMinutes ~/ 60, minute: s.startMinutes % 60),
      );
      if (t != null) ctrl.setStart(t.hour * 60 + t.minute);
    }

    Future<void> pickLength() async {
      final m = await showModalBottomSheet<int>(
        context: context,
        backgroundColor: context.colors.bgCard,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final m in _lengths)
                AppTile(
                  title: TimeFormat.length(Duration(minutes: m)),
                  onTap: () => Navigator.pop(context, m),
                ),
            ],
          ),
        ),
      );
      if (m != null) ctrl.setLength(Duration(minutes: m));
    }

    return Row(
      children: [
        Expanded(
          child: FieldBox(label: 'Date', value: DateFormat('E d', locale).format(s.date), onTap: pickDate),
        ),
        const HGap(8),
        Expanded(
          child: FieldBox(label: 'Starts', value: TimeFormat.hm(s.start), onTap: pickStart),
        ),
        const HGap(8),
        Expanded(
          child: FieldBox(label: 'Length', value: TimeFormat.length(s.length), onTap: pickLength),
        ),
      ],
    );
  }
}
