import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui.dart';
import '../../domain/class_session.dart';
import 'session_kind_style.dart';

/// Full details of a class, opened by tapping it in the grid.
Future<void> showSessionDetails(BuildContext context, ClassSession s) => showModalBottomSheet<void>(
  context: context,
  backgroundColor: context.colors.bgCard,
  showDragHandle: true,
  builder: (_) => _SessionDetails(session: s),
);

class _SessionDetails extends StatelessWidget {
  const _SessionDetails({required this.session});

  final ClassSession session;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final s = session;
    final rows = [
      (
        AppIcons.clock,
        '${DateFormat('EEEE d MMMM', locale).format(s.start)} · '
            '${TimeFormat.hm(s.start)} – ${TimeFormat.hm(s.end)}',
      ),
      (Icons.person_outline_rounded, s.professor),
      (AppIcons.pin, s.room ?? 'Room not set yet'),
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(context.dp(22), 0, context.dp(22), context.dp(22)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Eyebrow(s.code),
                const HGap(8),
                Eyebrow(s.kind.label, color: s.kind.marker(c)),
              ],
            ),
            const VGap(4),
            Text(s.title, style: context.text.headline),
            const VGap(14),
            for (final (icon, text) in rows) ...[
              Row(
                children: [
                  Icon(icon, size: context.dp(18), color: c.textSecondary),
                  const HGap(10),
                  Expanded(child: Text(text, style: context.text.body)),
                ],
              ),
              const VGap(10),
            ],
          ],
        ),
      ),
    );
  }
}
