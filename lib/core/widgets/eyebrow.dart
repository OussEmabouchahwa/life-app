import 'package:flutter/widgets.dart';

import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';

/// Small uppercase label ("NEXT PRAYER", "SET 3 OF 4").
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: context.text.eyebrow.tint(color ?? context.colors.textSecondary));
}
