import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/ui.dart';
import '../application/add_meal_controller.dart';
import '../application/food_diary_controller.dart';
import '../domain/food_models.dart';
import 'widgets/food_search_field.dart';
import 'widgets/selected_food_card.dart';

/// Figma 10 · Add meal. `foodId` preselects a food (after a barcode scan).
class AddMealScreen extends ConsumerWidget {
  const AddMealScreen({super.key, this.foodId});

  final String? foodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final provider = addMealProvider(foodId);
    final s = ref.watch(provider);
    final ctrl = ref.read(provider.notifier);
    final ramadan = ref.watch(foodSettingsProvider).mode == FoodMode.ramadan;
    final results = _results(ref.watch(allFoodsProvider), ref.watch(recentFoodNamesProvider), s.query);

    return AppPage(
      bottom: AppButton(
        label: s.food == null
            ? 'Choose a food'
            : 'Add ${s.macros.kcal.round()} kcal to ${s.type.label.toLowerCase()}',
        icon: AppIcons.check,
        onPressed: s.food == null
            ? null
            : () {
                ctrl.confirm();
                Navigator.of(context).pop();
              },
      ),
      children: [
        ScreenHeader(eyebrow: '${s.type.label} · Today', title: 'Add meal', showBack: true),
        ChoicePillRow<MealType>(
          values: ramadan ? MealType.ramadan : MealType.standard,
          selected: s.type,
          labelOf: (t) => t.label,
          onChanged: ctrl.setType,
          spacing: 6,
        ),
        FoodSearchField(onChanged: ctrl.setQuery),
        if (s.food != null)
          SelectedFoodCard(
            food: s.food!,
            grams: s.grams,
            onMinus: () => ctrl.changeGrams(-1),
            onPlus: () => ctrl.changeGrams(1),
          ),
        FormRow(
          children: [
            AppButton(
              label: 'Scan barcode',
              icon: Icons.qr_code_scanner_rounded,
              height: 44,
              variant: AppButtonVariant.outlined,
              onPressed: () => context.pushReplacement(Routes.barcodeScanner),
            ),
            AppButton(
              label: 'New food',
              icon: AppIcons.plus,
              height: 44,
              variant: AppButtonVariant.outlined,
              onPressed: () => context.push(Routes.foodForm),
            ),
          ],
        ),
        SectionHeader(title: s.query.isEmpty ? 'Recent and common' : 'Results · ${results.length}'),
        if (results.isEmpty)
          Text('No food matches. Create it with "New food".', style: context.text.body.tint(c.textSecondary))
        else
          AppCard(
            padding: 0,
            child: DividedColumn(
              children: [
                for (final f in results.take(30))
                  AppTile(
                    title: f.name,
                    subtitle: f.portionGrams == null
                        ? '100 g · ${f.per100g.kcal.round()} kcal'
                        : '${f.portionLabel} · ${f.forGrams(f.portionGrams!).kcal.round()} kcal',
                    onTap: () => ctrl.selectFood(f),
                    trailing: f.id == s.food?.id
                        ? const CheckCircle(checked: true)
                        : Icon(AppIcons.plus, color: c.brand, size: context.dp(AppSizes.icon)),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  /// Recently eaten foods first, then the rest; filtered by the search text.
  static List<Food> _results(List<Food> all, List<String> recent, String query) {
    final q = query.trim().toLowerCase();
    final matching = q.isEmpty ? all : all.where((f) => f.name.toLowerCase().contains(q)).toList();
    int rank(Food f) {
      final i = recent.indexOf(f.name);
      return i < 0 ? recent.length : i;
    }

    return [...matching]..sort((a, b) => rank(a).compareTo(rank(b)));
  }
}
