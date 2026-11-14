import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';

/// ‹  9 – 13 Nov  ›  with the day headers of the grid underneath.
class WeekSwitcher extends StatelessWidget {
  const WeekSwitcher({
    super.key,
    required this.monday,
    required this.dayCount,
    required this.today,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final DateTime monday;
  final int dayCount;
  final DateTime today;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final days = [for (var i = 0; i < dayCount; i++) monday.add(Duration(days: i))];
    final range =
        '${DateFormat.MMMd(locale).format(days.first)} – ${DateFormat.MMMd(locale).format(days.last)}';
    final offset = today.dateOnly.difference(monday).inDays;
    final isThisWeek = offset >= 0 && offset < 7;

    return Column(
      children: [
        Row(
          children: [
            IconBoxButton(
              icon: Icons.chevron_left_rounded,
              size: 36,
              tooltip: 'Previous week',
              onPressed: onPrevious,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(range, style: context.text.bodyStrong),
                  if (!isThisWeek)
                    GestureDetector(
                      onTap: onToday,
                      child: Text('Back to this week', style: context.text.caption.tint(c.accent).bold),
                    ),
                ],
              ),
            ),
            IconBoxButton(
              icon: Icons.chevron_right_rounded,
              size: 36,
              tooltip: 'Next week',
              onPressed: onNext,
            ),
          ],
        ),
        const VGap(12),
        Row(
          children: [
            SizedBox(width: context.dp(32)),
            for (final d in days)
              Expanded(
                child: Column(
                  children: [
                    Eyebrow(DateFormat.E(locale).format(d), color: d.isSameDay(today) ? c.accent : null),
                    Text('${d.day}', style: context.text.time),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
