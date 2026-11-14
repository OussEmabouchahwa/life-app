import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';

/// Seven day cells (M 26 · T 27 …). Selected day is filled green; a dot shows
/// days that have something planned.
class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.days,
    required this.selected,
    required this.onSelect,
    required this.hasItems,
  });

  final List<DateTime> days;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;
  final bool Function(DateTime day) hasItems;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Row(
      children: [
        for (var i = 0; i < days.length; i++) ...[
          if (i > 0) const HGap(6),
          Expanded(
            child: _DayCell(
              letter: DateFormat.E(locale).format(days[i]).characters.first,
              number: '${days[i].day}',
              selected: days[i].isSameDay(selected),
              dot: hasItems(days[i]),
              onTap: () => onSelect(days[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.letter,
    required this.number,
    required this.selected,
    required this.dot,
    required this.onTap,
  });

  final String letter;
  final String number;
  final bool selected;
  final bool dot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.onBrand : c.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        height: context.dp(70),
        decoration: BoxDecoration(
          color: selected ? c.brand : c.bgCard,
          borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
          border: Border.all(color: selected ? c.brand : c.line),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(letter, style: context.text.caption.tint(selected ? fg : c.textSecondary)),
            Text(number, style: context.text.title.tint(fg)),
            const VGap(6),
            Container(
              width: context.dp(4),
              height: context.dp(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dot ? (selected ? c.accent : c.brand) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
