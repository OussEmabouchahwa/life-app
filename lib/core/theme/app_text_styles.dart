import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography from the Figma foundations:
///  * Fraunces → titles, times and numbers.
///  * Manrope  → all interface text (10.5 – 18 px).
///
/// Sizes are Figma px for the 390 frame. [scaled] multiplies them by the
/// screen scale factor once per size change (see `AppTheme.scaled`).
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.hero,
    required this.display,
    required this.headline,
    required this.title,
    required this.timeLarge,
    required this.time,
    required this.bodyStrong,
    required this.body,
    required this.bodySmall,
    required this.caption,
    required this.eyebrow,
    required this.button,
  });

  /// Fonts are bundled in assets/fonts; Arabic text falls back to Noto Naskh.
  static const serifFamily = 'Fraunces', sansFamily = 'Manrope', arabicFamily = 'NotoNaskhArabic';

  factory AppTextStyles.create(AppColors c) {
    TextStyle serif(double size, FontWeight w, {double height = 1.15}) => TextStyle(
      fontFamily: serifFamily,
      fontFamilyFallback: const [arabicFamily],
      fontSize: size,
      fontWeight: w,
      height: height,
      color: c.textPrimary,
    );

    TextStyle sans(double size, FontWeight w, {double height = 1.35, double spacing = 0}) => TextStyle(
      fontFamily: sansFamily,
      fontFamilyFallback: const [arabicFamily],
      fontSize: size,
      fontWeight: w,
      height: height,
      letterSpacing: spacing,
      color: c.textPrimary,
    );

    return AppTextStyles(
      hero: serif(48, FontWeight.w600, height: 1.1),
      display: serif(30, FontWeight.w600),
      headline: serif(26, FontWeight.w600),
      title: serif(19, FontWeight.w600),
      timeLarge: serif(28, FontWeight.w600),
      time: serif(15, FontWeight.w600),
      bodyStrong: sans(15, FontWeight.w700),
      body: sans(14, FontWeight.w500),
      bodySmall: sans(12.5, FontWeight.w500),
      caption: sans(11, FontWeight.w500),
      eyebrow: sans(11, FontWeight.w700, spacing: 1.1),
      button: sans(15.5, FontWeight.w700),
    );
  }

  /// Big numbers: grade average, rest timer.
  final TextStyle hero;

  /// Screen titles ("Plan", "Training").
  final TextStyle display;

  /// Greeting, next prayer name, workout title.
  final TextStyle headline;

  /// Section heads and card titles.
  final TextStyle title;

  /// Prominent times / values ("12:08", "60 kg").
  final TextStyle timeLarge;

  /// Times in lists.
  final TextStyle time;

  /// Row titles.
  final TextStyle bodyStrong;
  final TextStyle body;

  /// Row subtitles and metadata.
  final TextStyle bodySmall;
  final TextStyle caption;

  /// Uppercase labels ("NEXT PRAYER").
  final TextStyle eyebrow;
  final TextStyle button;

  List<TextStyle> get _all => [
    hero, display, headline, title, timeLarge, time, //
    bodyStrong, body, bodySmall, caption, eyebrow, button,
  ];

  AppTextStyles _from(List<TextStyle> s) => AppTextStyles(
    hero: s[0],
    display: s[1],
    headline: s[2],
    title: s[3],
    timeLarge: s[4],
    time: s[5],
    bodyStrong: s[6],
    body: s[7],
    bodySmall: s[8],
    caption: s[9],
    eyebrow: s[10],
    button: s[11],
  );

  /// Returns the same styles with font sizes multiplied by [factor].
  AppTextStyles scaled(double factor) =>
      _from([for (final s in _all) s.copyWith(fontSize: s.fontSize! * factor)]);

  @override
  AppTextStyles copyWith() => this;

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    final a = _all, b = other._all;
    return _from([for (var i = 0; i < a.length; i++) TextStyle.lerp(a[i], b[i], t)!]);
  }
}

/// Small helpers so widgets stay short: `context.text.body.muted(c)`.
extension TextStyleX on TextStyle {
  TextStyle tint(Color color) => copyWith(color: color);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
}
