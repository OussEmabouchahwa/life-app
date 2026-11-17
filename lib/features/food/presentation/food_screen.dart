import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../application/fasting_providers.dart';
import '../application/food_diary_controller.dart';
import '../domain/food_models.dart';
import 'widgets/calories_card.dart';
import 'widgets/fasting_card.dart';
import 'widgets/meal_entries_sheet.dart';
import 'widgets/meal_row.dart';
import 'widgets/water_card.dart';

/// Figma 09 · Food and 18 · Food – Ramadan.
class FoodScreen extends ConsumerWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final settings = ref.watch(foodSettingsProvider);
    final ramadan = settings.mode == FoodMode.ramadan;
    final byType = ref.watch(mealsByTypeProvider);
    final types = ramadan ? MealType.ramadan : MealType.standard;
    void addMeal() => context.push(Routes.addMeal);

    return AppPage(
      children: [
        ScreenHeader(
          eyebrow: DateFormat('EEEE · d MMM', locale).format(DateTime.now()),
          title: 'Food',
          trailing: IconBoxButton(
            icon: AppIcons.sliders,
            tooltip: 'Goals',
            onPressed: () => context.push(Routes.nutritionGoals),
          ),
        ),
        SegmentedControl<FoodMode>(
          values: FoodMode.values,
          selected: settings.mode,
          labelOf: (m) => m == FoodMode.standard ? 'Standard' : 'Ramadan',
          iconOf: (m) => m == FoodMode.ramadan ? Icons.nightlight_round : null,
          onChanged: ref.read(foodSettingsProvider.notifier).setMode,
        ),
        if (ramadan) FastingCard(status: ref.watch(fastingStatusProvider)),
        CaloriesCard(eaten: ref.watch(eatenTodayProvider), goal: settings.goal),
        const SectionHeader(title: 'Meals'),
        AppCard(
          padding: 0,
          child: DividedColumn(
            children: [
              for (final t in types)
                MealRow(
                  type: t,
                  entries: byType[t]!,
                  onAdd: addMeal,
                  onOpen: () => showMealEntriesSheet(context, t),
                ),
            ],
          ),
        ),
        WaterCard(
          glasses: ref.watch(waterTodayProvider),
          goal: settings.waterGlasses,
          hint: ramadan ? 'Drink between iftar and suhoor.' : null,
          onChanged: (n) => ref.read(waterProvider.notifier).set(DateTime.now(), n),
        ),
        FormRow(
          children: [
            AppButton(label: 'Add meal', icon: AppIcons.plus, onPressed: addMeal),
            AppButton(
              label: 'Scan',
              icon: Icons.qr_code_scanner_rounded,
              variant: AppButtonVariant.outlined,
              onPressed: () => context.push(Routes.barcodeScanner),
            ),
          ],
        ),
      ],
    );
  }
}
