import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Short access to the design tokens: `context.colors.brand`, `context.text.title`.
extension ThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppTextStyles get text => Theme.of(this).extension<AppTextStyles>()!;
}
