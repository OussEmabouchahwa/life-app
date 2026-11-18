import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/theme_context.dart';

/// Thin rounded progress bar on a sunken track. [value] is 0.0 – 1.0.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, required this.value, this.color, this.height = AppSizes.progressBar});

  final double value;
  final Color? color;

  /// Thickness in Figma px.
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final h = context.dp(height);
    return ClipRRect(
      borderRadius: BorderRadius.circular(h),
      // Full width of its parent, even inside a centred column.
      child: SizedBox(
        width: double.infinity,
        height: h,
        child: ColoredBox(
          color: c.bgSunken,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: value.clamp(0.0, 1.0)),
            duration: AppDurations.normal,
            builder: (context, v, _) => FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: v,
              child: ColoredBox(color: color ?? c.brand),
            ),
          ),
        ),
      ),
    );
  }
}
