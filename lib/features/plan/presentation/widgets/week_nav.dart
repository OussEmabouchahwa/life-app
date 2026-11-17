import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';

/// ‹  16 Nov – 22 Nov  ›  with "This week" when browsing another week.
class WeekNav extends StatelessWidget {
  const WeekNav({
    super.key,
    required this.from,
    required this.to,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    required this.isCurrent,
  });

  final DateTime from;
  final DateTime to;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final f = DateFormat.MMMd(Localizations.localeOf(context).languageCode);
    return Row(
      children: [
        IconBoxButton(
          icon: Icons.chevron_left_rounded,
          size: 34,
          tooltip: 'Previous week',
          onPressed: onPrevious,
        ),
        Expanded(
          child: Column(
            children: [
              Text('${f.format(from)} – ${f.format(to)}', style: context.text.body.bold),
              if (!isCurrent)
                GestureDetector(
                  onTap: onToday,
                  child: Text('Back to this week', style: context.text.caption.tint(c.accent).bold),
                ),
            ],
          ),
        ),
        IconBoxButton(icon: Icons.chevron_right_rounded, size: 34, tooltip: 'Next week', onPressed: onNext),
      ],
    );
  }
}
