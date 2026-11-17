import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui.dart';
import '../../../prayers/application/prayer_providers.dart';
import '../../../prayers/data/cities.dart';
import '../../../settings/application/settings_controller.dart';

/// Name and city, with today's prayer times for that city as a preview.
class ProfileStep extends ConsumerWidget {
  const ProfileStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final s = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);
    final prayers = ref.watch(todayPrayersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Your name',
          hint: 'Oussema',
          initialValue: s.userName,
          onChanged: ctrl.setUserName,
        ),
        const VGap(10),
        PickerField<City>(
          label: 'City',
          value: Cities.byName(s.city),
          options: Cities.all,
          labelOf: (city) => city.name,
          onChanged: (city) => ctrl.setCity(city.name),
        ),
        const VGap(14),
        AppCard(
          color: c.brandSoft,
          borderColor: c.brandSoft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Eyebrow('Today in ${s.city}'),
              const VGap(8),
              Row(
                children: [
                  for (final p in prayers)
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(fit: BoxFit.scaleDown, child: Eyebrow(p.label)),
                          Text(TimeFormat.hm(p.time), style: context.text.time),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
