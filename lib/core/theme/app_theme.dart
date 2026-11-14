import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Builds the Material theme from the design tokens.
/// Both themes share the same layout and tokens, only the colours change.
abstract final class AppTheme {
  /// Built once and reused.
  static final ThemeData light = _build(AppColors.light, Brightness.light);
  static final ThemeData dark = _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.brand,
      onPrimary: c.onBrand,
      secondary: c.accent,
      onSecondary: c.onAccent,
      error: c.danger,
      onError: c.onBrand,
      surface: c.bgCard,
      onSurface: c.textPrimary,
      surfaceContainerHighest: c.bgSunken,
      outline: c.line,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bgBase,
      fontFamily: AppTextStyles.useGoogleFonts ? GoogleFonts.manrope().fontFamily : null,
      dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
      splashColor: c.brand.withValues(alpha: 0.06),
      highlightColor: c.brand.withValues(alpha: 0.04),
      textSelectionTheme: TextSelectionThemeData(cursorColor: c.accent),
      extensions: [c, AppTextStyles.create(c)],
    );
  }

  /// Applies the screen scale factor to the typography. Called from
  /// `MaterialApp.builder`, so it only runs when the screen size or theme changes.
  static ThemeData scaled(ThemeData base, double factor) {
    final text = base.extension<AppTextStyles>()!;
    return base.copyWith(extensions: [base.extension<AppColors>()!, text.scaled(factor)]);
  }
}
