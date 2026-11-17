import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';
import '../../domain/training_models.dart';

/// Last finished workouts with sets and total volume.
class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.sessions});

  final List<WorkoutSession> sessions;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return AppCard(
      padding: 0,
      child: DividedColumn(
        children: [
          for (final s in sessions)
            AppTile(
              title: s.workoutName,
              subtitle: '${DateFormat('EEE d MMM', locale).format(s.date)} · ${s.setCount} sets',
              trailing: ValueWithUnit(
                value: NumberFormat.decimalPattern(locale).format(s.volume.round()),
                unit: 'kg',
                style: context.text.time,
              ),
            ),
        ],
      ),
    );
  }
}
