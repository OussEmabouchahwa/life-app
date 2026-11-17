import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui.dart';
import '../../../shared/models/event_category.dart';
import '../../timetable/application/timetable_providers.dart';
import '../application/add_event_controller.dart';
import 'widgets/day_glance_lanes.dart';
import 'widgets/event_when_fields.dart';
import 'widgets/prayer_conflict_card.dart';

/// Figma 12 · Add / edit event. Warns when the event overlaps a prayer.
class AddEventScreen extends ConsumerWidget {
  const AddEventScreen({super.key, this.id, this.category});

  final String? id;
  final String? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (id: id, category: category);
    final s = ref.watch(addEventProvider(args));
    final ctrl = ref.read(addEventProvider(args).notifier);
    final conflict = ref.watch(addEventConflictProvider(args));
    final courses = ref.watch(courseProgressProvider);
    final linksCourse = s.category == EventCategory.study || s.category == EventCategory.classes;

    return FormPage(
      title: s.isEditing ? 'Edit event' : 'Add event',
      eyebrow: s.isEditing ? 'Plan' : 'New event',
      saveLabel: s.repeatWeeks > 0 ? 'Save ${s.repeatWeeks + 1} events' : 'Save event',
      canSave: s.canSave,
      onSave: ctrl.save,
      deleteWhat: 'this event',
      onDelete: s.isEditing ? ctrl.delete : null,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final cat in EventCategory.userPickable) ...[
                ChoicePill(label: cat.label, selected: cat == s.category, onTap: () => ctrl.setCategory(cat)),
                const HGap(8),
              ],
            ],
          ),
        ),
        if (linksCourse && courses.isNotEmpty)
          PickerField<String>(
            label: 'Course',
            value: s.courseCode ?? '',
            options: ['', for (final c in courses) c.code],
            labelOf: (code) => code.isEmpty ? 'None' : courses.firstWhere((c) => c.code == code).name,
            onChanged: (code) => ctrl.setCourse(
              code.isEmpty ? null : code,
              name: code.isEmpty ? null : courses.firstWhere((c) => c.code == code).name,
            ),
          ),
        AppTextField(
          // A new key when the title is filled from the course, so the field shows it.
          key: ValueKey(s.courseCode),
          label: 'Title',
          hint: 'Revision · Algorithms',
          initialValue: s.title,
          autofocus: !s.isEditing && !linksCourse,
          onChanged: ctrl.setTitle,
        ),
        EventWhenFields(args: args),
        if (!s.isEditing)
          StepperField(
            label: 'Repeat weekly',
            value: s.repeatWeeks,
            max: 16,
            unit: s.repeatWeeks == 1 ? 'week' : 'weeks',
            onChanged: ctrl.setRepeat,
          ),
        AppTextField(
          label: 'Notes',
          hint: 'Chapter 4, room…',
          initialValue: s.notes,
          onChanged: ctrl.setNotes,
        ),
        AppCard(
          padding: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Day at a glance', style: context.text.bodyStrong),
              const VGap(12),
              DayGlanceLanes(
                items: ref.watch(addEventDayItemsProvider(args)),
                newStart: s.start,
                newEnd: s.end,
              ),
              const VGap(10),
              Text(
                'Top: your day. Bottom: this event.',
                style: context.text.caption.tint(context.colors.textSecondary),
              ),
            ],
          ),
        ),
        if (conflict != null)
          PrayerConflictCard(
            prayer: conflict,
            eventStart: s.start,
            eventEnd: s.end,
            onMove: () => ctrl.moveAfter(conflict),
            onKeep: ctrl.keepAnyway,
          ),
      ],
    );
  }
}
