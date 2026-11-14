import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// "Search food or scan a barcode" input.
class FoodSearchField extends StatelessWidget {
  const FoodSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(context.dp(AppRadius.md));
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color),
    );

    return TextField(
      onChanged: onChanged,
      style: context.text.body,
      decoration: InputDecoration(
        filled: true,
        fillColor: c.bgCard,
        isDense: true,
        prefixIcon: Icon(AppIcons.search, color: c.textSecondary, size: context.dp(AppSizes.icon)),
        hintText: 'Search food or scan a barcode',
        hintStyle: context.text.body.tint(c.textSecondary),
        contentPadding: context.padSym(v: 13),
        enabledBorder: border(c.line),
        focusedBorder: border(c.brand),
      ),
    );
  }
}
