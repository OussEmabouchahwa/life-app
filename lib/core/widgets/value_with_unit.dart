import 'package:flutter/widgets.dart';

import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';

/// A big number followed by a small unit: "60 kg", "13.6 / 20", "1,640 kcal".
class ValueWithUnit extends StatelessWidget {
  const ValueWithUnit({super.key, required this.value, required this.unit, this.style, this.color});

  final String value;
  final String unit;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = style ?? context.text.timeLarge;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: value, style: color == null ? base : base.tint(color!)),
          TextSpan(text: ' $unit', style: context.text.bodySmall.tint(context.colors.textSecondary)),
        ],
      ),
    );
  }
}
