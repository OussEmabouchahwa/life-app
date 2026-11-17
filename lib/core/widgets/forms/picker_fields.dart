import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/time_format.dart';
import '../field_box.dart';
import 'options_sheet.dart';

/// Field that opens an options sheet.
class PickerField<T> extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    this.subtitleOf,
    this.placeholder = 'Choose',
  });

  final String label;
  final T? value;
  final List<T> options;
  final String Function(T) labelOf;
  final String? Function(T)? subtitleOf;
  final ValueChanged<T> onChanged;
  final String placeholder;

  @override
  Widget build(BuildContext context) => FieldBox(
    label: label,
    value: value == null ? placeholder : labelOf(value as T),
    onTap: () async {
      final picked = await showOptionsSheet<T>(
        context: context,
        title: label,
        options: options,
        labelOf: labelOf,
        subtitleOf: subtitleOf,
        selected: value,
      );
      if (picked != null) onChanged(picked);
    },
  );
}

class DateField extends StatelessWidget {
  const DateField({super.key, required this.label, required this.value, required this.onChanged});

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return FieldBox(
      label: label,
      value: DateFormat('EEE d MMM', locale).format(value),
      onTap: () async {
        final now = DateTime.now();
        final d = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(now.year - 1),
          lastDate: DateTime(now.year + 2),
        );
        if (d != null) onChanged(d);
      },
    );
  }
}

/// Time of day as minutes after midnight (easy to store and compare).
class TimeField extends StatelessWidget {
  const TimeField({super.key, required this.label, required this.minutes, required this.onChanged});

  final String label;
  final int minutes;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => FieldBox(
    label: label,
    value: TimeFormat.minutes(minutes),
    onTap: () async {
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      );
      if (t != null) onChanged(t.hour * 60 + t.minute);
    },
  );
}
