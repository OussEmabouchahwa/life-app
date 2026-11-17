import 'package:flutter/material.dart';

import '../../../../core/ui.dart';
import '../../domain/food_models.dart';

/// [🍴] Breakfast / Eggs, bread · 07:10        420 kcal
/// When nothing is logged, shows "Not logged yet" with a + icon.
class MealRow extends StatelessWidget {
  const MealRow({
    super.key,
    required this.type,
    required this.entries,
    required this.onAdd,
    required this.onOpen,
  });

  final MealType type;
  final List<MealEntry> entries;
  final VoidCallback onAdd;

  /// Opens the list of entries (to delete one).
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final logged = entries.isNotEmpty;
    final kcal = entries.fold<double>(0, (s, e) => s + e.macros.kcal).round();
    final subtitle = logged
        ? '${entries.map((e) => e.description).join(', ')} · ${TimeFormat.hm(entries.first.time)}'
        : 'Not logged yet';

    return AppTile(
      title: type.label,
      subtitle: subtitle,
      onTap: logged ? onOpen : onAdd,
      leading: Container(
        width: context.dp(38),
        height: context.dp(38),
        decoration: BoxDecoration(
          color: logged ? c.brandSoft : c.bgSunken,
          borderRadius: BorderRadius.circular(context.dp(AppRadius.md)),
        ),
        child: Icon(
          logged ? AppIcons.utensils : AppIcons.plus,
          size: context.dp(18),
          color: logged ? c.brand : c.textSecondary,
        ),
      ),
      trailing: logged
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$kcal', style: context.text.time),
                Text('kcal', style: context.text.caption.tint(c.textSecondary)),
              ],
            )
          : null,
    );
  }
}
