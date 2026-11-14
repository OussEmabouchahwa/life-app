import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/theme_context.dart';

/// 46 × 28 toggle from the Settings design.
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final w = context.dp(46), h = context.dp(28), thumb = context.dp(22);
    return Semantics(
      toggled: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          width: w,
          height: h,
          padding: EdgeInsets.all((h - thumb) / 2),
          decoration: BoxDecoration(
            color: value ? c.brand : c.bgSunken,
            borderRadius: BorderRadius.circular(h),
            border: Border.all(color: value ? c.brand : c.line),
          ),
          child: AnimatedAlign(
            duration: AppDurations.fast,
            alignment: value ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
            child: Container(
              width: thumb,
              height: thumb,
              decoration: BoxDecoration(shape: BoxShape.circle, color: value ? c.onBrand : c.bgCard),
            ),
          ),
        ),
      ),
    );
  }
}
