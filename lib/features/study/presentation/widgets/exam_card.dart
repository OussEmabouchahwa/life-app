import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';
import '../../domain/study_models.dart';

/// [17 NOV] Subject / Written · Salle 4-3 / 🕘 09:00 · 1 h 30     (in 5 days)
class ExamCard extends StatelessWidget {
  const ExamCard({super.key, required this.exam, required this.today, this.onTap});

  final Exam exam;
  final DateTime today;
  final VoidCallback? onTap;

  String get _countdown {
    final days = exam.start.dateOnly.difference(today).inDays;
    return switch (days) {
      < 0 => 'Done',
      0 => 'Today',
      1 => 'Tomorrow',
      _ => 'in $days days',
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final days = exam.start.dateOnly.difference(today).inDays;
    final meta = [exam.type.label, if (exam.room.isNotEmpty) exam.room].join(' · ');

    return AppCard(
      padding: 14,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: context.dp(52),
            padding: context.padSym(v: 8),
            decoration: BoxDecoration(
              color: c.bgSunken,
              borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
            ),
            child: Column(
              children: [
                Text(exam.start.day.toString().padLeft(2, '0'), style: context.text.timeLarge),
                Eyebrow(DateFormat.MMM(locale).format(exam.start)),
              ],
            ),
          ),
          const HGap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.subject,
                  style: context.text.bodyStrong,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(meta, style: context.text.bodySmall.tint(c.textSecondary)),
                const VGap(4),
                Row(
                  children: [
                    Icon(AppIcons.clock, size: context.dp(13), color: c.textSecondary),
                    const HGap(4),
                    Flexible(
                      child: Text(
                        '${TimeFormat.hm(exam.start)} · ${TimeFormat.length(Duration(minutes: exam.minutes))}',
                        style: context.text.caption.tint(c.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const HGap(8),
          SoftTag(label: _countdown, warning: days >= 0 && days <= 3),
        ],
      ),
    );
  }
}
