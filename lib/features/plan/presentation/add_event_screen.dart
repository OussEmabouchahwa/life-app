import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui.dart';
import '../../../shared/models/event_category.dart';
import '../application/add_event_controller.dart';
import 'widgets/day_glance_lanes.dart';
import 'widgets/event_title_field.dart';
import 'widgets/event_when_fields.dart';
import 'widgets/prayer_conflict_card.dart';

/// Figma 12 · Add event. Warns when the event overlaps a prayer.
class AddEventScreen extends ConsumerWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(addEventProvider);
    final ctrl = ref.read(addEventProvider.notifier);
    final conflict = ref.watch(addEventConflictProvider);

    return AppPage(
      bottom: AppButton(
        label: 'Save event',
        icon: AppIcons.check,
        onPressed: s.canSave
            ? () {
                if (ctrl.save()) Navigator.of(context).pop();
              }
            : null,
      ),
      children: [
        const ScreenHeader(eyebrow: 'New event', title: 'Add event', showBack: true),
        EventTitleField(onChanged: ctrl.setTitle),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final cat in EventCategory.values) ...[
                ChoicePill(label: cat.label, selected: cat == s.category, onTap: () => ctrl.setCategory(cat)),
                const HGap(8),
              ],
            ],
          ),
        ),
        const EventWhenFields(),
        AppCard(
          padding: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Day at a glance', style: context.text.bodyStrong),
              const VGap(12),
              DayGlanceLanes(items: ref.watch(addEventDayItemsProvider), newStart: s.start, newEnd: s.end),
              const VGap(10),
              Text(
                'Top: your fixed plan. Bottom: the new event.',
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
