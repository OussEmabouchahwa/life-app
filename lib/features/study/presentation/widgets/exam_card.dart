import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';
import '../../domain/study_models.dart';

/// [31 OCT] Databases / Prof… / 🕘 09:00 · Written     (in 5 days)
class ExamCard extends StatelessWidget {
  const ExamCard({super.key, required this.exam, required this.today});

  final Exam exam;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final days = exam.date.difference(today).inDays;
    return AppCard(
      padding: 14,
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
                Text(exam.date.day.toString().padLeft(2, '0'), style: context.text.timeLarge),
                Eyebrow(DateFormat.MMM(locale).format(exam.date)),
              ],
            ),
          ),
          const HGap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exam.subject, style: context.text.bodyStrong),
                Text(exam.detail, style: context.text.bodySmall.tint(c.textSecondary)),
                const VGap(4),
                Row(
                  children: [
                    Icon(AppIcons.clock, size: context.dp(13), color: c.textSecondary),
                    const HGap(4),
                    Flexible(
                      child: Text(
                        exam.when,
                        style: context.text.caption.tint(c.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SoftTag(label: 'in $days days', warning: days <= 5),
        ],
      ),
    );
  }
}
