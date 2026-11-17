import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui.dart';
import '../../application/study_providers.dart';
import '../../domain/study_models.dart';

/// Marks, coefficient and weights of one subject (id = course code).
class GradeFormScreen extends ConsumerStatefulWidget {
  const GradeFormScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<GradeFormScreen> createState() => _GradeFormScreenState();
}

class _GradeFormScreenState extends ConsumerState<GradeFormScreen> {
  late final SubjectGrades _subject = ref.read(subjectsProvider).firstWhere((s) => s.id == widget.id);
  late double? _coef = _subject.coef;
  late final Map<Assessment, double?> _marks = {for (final a in Assessment.values) a: _subject.marks[a]};
  late final Map<Assessment, double?> _weights = {
    for (final a in Assessment.values) a: _subject.weightOf(a) * 100,
  };

  bool get _hasSaved => ref.read(gradesProvider).any((g) => g.id == widget.id);
  double get _weightSum => _weights.values.fold(0, (s, w) => s + (w ?? 0));
  bool get _marksValid => _marks.values.every((m) => m == null || (m >= 0 && m <= 20));
  bool get _valid => (_coef ?? 0) > 0 && (_weightSum - 100).abs() < 0.01 && _marksValid;

  SubjectGrades get _draft => _subject.copyWith(
    coef: _coef ?? _subject.coef,
    weights: {for (final e in _weights.entries) e.key: (e.value ?? 0) / 100},
    marks: {
      for (final e in _marks.entries)
        if (e.value != null && (_weights[e.key] ?? 0) > 0) e.key: e.value!,
    },
  );

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final preview = _draft.average;
    final problem = !_marksValid
        ? 'Marks must be between 0 and 20.'
        : (_weightSum - 100).abs() >= 0.01
        ? 'Weights add up to ${_weightSum.toStringAsFixed(0)} %, they must make 100 %.'
        : null;

    return FormPage(
      title: _subject.name,
      eyebrow: 'Study · Grades',
      canSave: _valid,
      onSave: () => ref.read(gradesProvider.notifier).save(_draft),
      deleteWhat: 'the marks of this subject',
      onDelete: _hasSaved ? () => ref.read(gradesProvider.notifier).remove(widget.id) : null,
      children: [
        NumberField(label: 'Coefficient', value: _coef, onChanged: (v) => setState(() => _coef = v)),
        for (final a in Assessment.values)
          FormRow(
            children: [
              NumberField(
                label: '${a.label} mark',
                suffix: '/ 20',
                hint: '—',
                value: _marks[a],
                onChanged: (v) => setState(() => _marks[a] = v),
              ),
              NumberField(
                label: '${a.label} weight',
                suffix: '%',
                value: _weights[a],
                onChanged: (v) => setState(() => _weights[a] = v),
              ),
            ],
          ),
        if (problem != null)
          Text(problem, style: context.text.bodySmall.tint(c.danger))
        else
          AppCard(
            color: c.brandSoft,
            borderColor: c.brandSoft,
            child: Row(
              children: [
                Expanded(child: Text('Average so far', style: context.text.body)),
                ValueWithUnit(value: preview?.toStringAsFixed(2) ?? '—', unit: '/ 20'),
              ],
            ),
          ),
        Text(
          'Set a weight to 0 % when the subject has no such assessment (e.g. no TP).',
          style: context.text.bodySmall.tint(c.textSecondary),
        ),
      ],
    );
  }
}
