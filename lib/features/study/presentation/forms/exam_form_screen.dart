import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/stored_list_controller.dart';
import '../../../../core/ui.dart';
import '../../../timetable/application/timetable_providers.dart';
import '../../application/study_providers.dart';
import '../../domain/study_models.dart';

/// Add or edit an exam. Opened with `?id=` to edit.
class ExamFormScreen extends ConsumerStatefulWidget {
  const ExamFormScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<ExamFormScreen> createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends ConsumerState<ExamFormScreen> {
  static const _other = '';

  late final Exam? _existing = widget.id == null ? null : ref.read(examsProvider.notifier).byId(widget.id!);
  late String _code = _existing?.courseCode ?? _other;
  late String _subject = _existing?.subject ?? '';
  late ExamType _type = _existing?.type ?? ExamType.written;
  late DateTime _date = (_existing?.start ?? DateTime.now().add(const Duration(days: 7))).dateOnly;
  late int _startMinutes = _existing == null ? 9 * 60 : _existing.start.hour * 60 + _existing.start.minute;
  late int _minutes = _existing?.minutes ?? 90;
  late String _room = _existing?.room ?? '';

  bool get _valid => _subject.trim().isNotEmpty;

  void _save() => ref
      .read(examsProvider.notifier)
      .save(
        Exam(
          id: _existing?.id ?? newId(),
          subject: _subject.trim(),
          courseCode: _code == _other ? null : _code,
          start: _date.add(Duration(minutes: _startMinutes)),
          minutes: _minutes,
          type: _type,
          room: _room.trim(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(courseProgressProvider);
    final codes = [for (final c in courses) c.code, _other];
    String nameOf(String code) =>
        code == _other ? 'Other subject' : courses.firstWhere((c) => c.code == code).name;

    return FormPage(
      title: _existing == null ? 'Add exam' : 'Edit exam',
      eyebrow: 'Study · Exams',
      canSave: _valid,
      onSave: _save,
      deleteWhat: 'this exam',
      onDelete: _existing == null ? null : () => ref.read(examsProvider.notifier).remove(_existing.id),
      children: [
        PickerField<String>(
          label: 'Course',
          value: _code,
          options: codes,
          labelOf: nameOf,
          onChanged: (code) => setState(() {
            _code = code;
            if (code != _other) _subject = nameOf(code);
          }),
        ),
        if (_code == _other)
          AppTextField(
            label: 'Subject',
            hint: 'e.g. Rattrapage Droit',
            initialValue: _subject,
            onChanged: (v) => setState(() => _subject = v),
          ),
        FormSection(
          title: 'Type',
          children: [
            ChoicePillRow<ExamType>(
              values: ExamType.values,
              selected: _type,
              labelOf: (t) => t.label,
              onChanged: (t) => setState(() => _type = t),
              spacing: 6,
            ),
          ],
        ),
        FormRow(
          children: [
            DateField(label: 'Date', value: _date, onChanged: (d) => setState(() => _date = d.dateOnly)),
            TimeField(
              label: 'Starts',
              minutes: _startMinutes,
              onChanged: (m) => setState(() => _startMinutes = m),
            ),
          ],
        ),
        StepperField(
          label: 'Length',
          value: _minutes,
          min: 15,
          max: 480,
          step: 15,
          unit: 'min',
          onChanged: (v) => setState(() => _minutes = v),
        ),
        AppTextField(label: 'Room', hint: 'Salle TP 4-3', initialValue: _room, onChanged: (v) => _room = v),
      ],
    );
  }
}
