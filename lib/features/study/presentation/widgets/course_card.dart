import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';
import '../../../timetable/application/timetable_providers.dart';

/// Course from the timetable: sessions done so far and the next one.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final CourseProgress course;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final next = course.next;
    final nextText = next == null
        ? 'No more sessions this semester'
        : 'Next: ${DateFormat('EEE d MMM', locale).format(next.start)} · ${TimeFormat.hm(next.start)}'
              '${next.roomShort == null ? '' : ' · ${next.roomShort}'}';

    return AppCard(
      padding: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.name, style: context.text.bodyStrong),
                    Text(
                      '${course.code} · ${course.professor}',
                      style: context.text.bodySmall.tint(c.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const HGap(8),
              Text('${course.done} / ${course.total}', style: context.text.time),
            ],
          ),
          const VGap(10),
          AppProgressBar(value: course.progress),
          const VGap(10),
          Row(
            children: [
              Icon(AppIcons.clock, size: context.dp(14), color: c.textSecondary),
              const HGap(6),
              Expanded(
                child: Text(
                  nextText,
                  style: context.text.bodySmall.tint(c.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
