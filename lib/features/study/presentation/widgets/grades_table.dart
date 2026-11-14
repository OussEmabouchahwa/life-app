import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/study_models.dart';

/// SUBJECT | DS | TP | EXAM | AVG. The subject column takes a share of the
/// width; the four mark columns split the rest equally.
class GradesTable extends StatelessWidget {
  const GradesTable({super.key, required this.subjects});

  final List<SubjectGrades> subjects;

  static const _subjectFlex = 5, _markFlex = 2;

  String _mark(double? v) =>
      v == null ? '—' : (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1));

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget cell(Widget child) => Expanded(
      flex: _markFlex,
      child: Center(child: child),
    );

    return AppCard(
      padding: 0,
      child: DividedColumn(
        children: [
          Padding(
            padding: context.padSym(h: 14, v: 10),
            child: Row(
              children: [
                const Expanded(flex: _subjectFlex, child: Eyebrow('Subject')),
                for (final a in Assessment.values) cell(Eyebrow(a.label)),
                cell(const Eyebrow('Avg')),
              ],
            ),
          ),
          for (final s in subjects)
            Padding(
              padding: context.padSym(h: 14, v: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: _subjectFlex,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name, style: context.text.body.bold),
                        Text(
                          '${s.prof} · coef ${_mark(s.coef)}',
                          style: context.text.caption.tint(c.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  for (final a in Assessment.values) cell(Text(_mark(s.marks[a]), style: context.text.body)),
                  cell(Text(s.average?.toStringAsFixed(1) ?? '—', style: context.text.title)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
