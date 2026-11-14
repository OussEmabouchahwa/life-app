import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/class_session.dart';
import 'session_kind_style.dart';

/// Hour lines on the side and sessions placed by weekday and time.
/// Column width is a share of the available width, never a constant.
class TimetableGrid extends StatelessWidget {
  const TimetableGrid({
    super.key,
    required this.sessions,
    required this.dayCount,
    required this.now,
    required this.onTap,
  });

  final List<ClassSession> sessions;

  /// 5 (Mon–Fri) or 6 when the week has Saturday classes.
  final int dayCount;
  final DateTime now;
  final ValueChanged<ClassSession> onTap;

  static const firstHour = 8, lastHour = 17;
  static const _hourHeight = 40.0; // Figma px
  static const timeColumn = 32.0; // Figma px

  @override
  Widget build(BuildContext context) {
    final hourH = context.dp(_hourHeight);
    final timeCol = context.dp(timeColumn);
    double top(DateTime t) => (t.hour + t.minute / 60 - firstHour) * hourH;
    final showNow = now.weekday <= dayCount && now.hour >= firstHour && now.hour < lastHour;

    return LayoutBuilder(
      builder: (context, box) {
        final dayW = (box.maxWidth - timeCol) / dayCount;
        double left(DateTime t) => timeCol + (t.weekday - 1) * dayW;

        return SizedBox(
          height: (lastHour - firstHour) * hourH,
          child: Stack(
            children: [
              for (var h = firstHour; h < lastHour; h++) _HourLine(top: (h - firstHour) * hourH, hour: h),
              for (final s in sessions)
                if (s.start.weekday <= dayCount)
                  Positioned(
                    top: top(s.start) + 1,
                    left: left(s.start) + 2,
                    width: dayW - 4,
                    height: s.duration.inMinutes / 60 * hourH - 2,
                    child: _SessionBlock(session: s, onTap: () => onTap(s)),
                  ),
              if (showNow)
                Positioned(
                  top: top(now) - context.dp(3.5),
                  left: left(now) - context.dp(3.5),
                  child: _NowDot(size: context.dp(7)),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HourLine extends StatelessWidget {
  const _HourLine({required this.top, required this.hour});

  final double top;
  final int hour;

  @override
  Widget build(BuildContext context) => Positioned(
    top: top,
    left: 0,
    right: 0,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.dp(TimetableGrid.timeColumn),
          child: Text(
            hour.toString().padLeft(2, '0'),
            style: context.text.caption.tint(context.colors.textSecondary),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    ),
  );
}

class _SessionBlock extends StatelessWidget {
  const _SessionBlock({required this.session, required this.onTap});

  final ClassSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: session.kind.background(c),
      borderRadius: BorderRadius.circular(context.dp(AppRadius.sm)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: BorderDirectional(
              start: BorderSide(color: session.kind.marker(c), width: context.dp(3)),
            ),
          ),
          padding: context.padAll(5),
          alignment: AlignmentDirectional.topStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // One line that shrinks on narrow columns instead of breaking mid-word.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(session.shortName, style: context.text.caption.bold, maxLines: 1),
              ),
              if (session.roomShort != null)
                Text(
                  session.roomShort!,
                  style: context.text.caption.tint(c.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NowDot extends StatelessWidget {
  const _NowDot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: context.colors.accent, shape: BoxShape.circle),
  );
}
