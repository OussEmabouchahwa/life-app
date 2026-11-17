import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/study_models.dart';

/// SUBJECT | DS | TP | EXAM | AVG. Tap a row to edit its marks.
/// The subject column takes a share of the width; marks split the rest.
class GradesTable extends StatelessWidget {
  const GradesTable({super.key, required this.subjects, required this.onTap});

  final List<SubjectGrades> subjects;
  final ValueChanged<SubjectGrades> onTap;

  static const _subjectFlex = 5, _markFlex = 2;

  static String mark(double? v) =>
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
            InkWell(
              onTap: () => onTap(s),
              child: Padding(
                padding: context.padSym(h: 14, v: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: _subjectFlex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: context.text.body.bold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('coef ${mark(s.coef)}', style: context.text.caption.tint(c.textSecondary)),
                        ],
                      ),
                    ),
                    for (final a in Assessment.values)
                      cell(
                        Text(
                          s.weightOf(a) == 0 ? '·' : mark(s.marks[a]),
                          style: context.text.body.tint(s.weightOf(a) == 0 ? c.line : c.textPrimary),
                        ),
                      ),
                    cell(
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          s.average?.toStringAsFixed(1) ?? '—',
                          style: context.text.title.tint((s.average ?? 10) < 10 ? c.danger : c.textPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
