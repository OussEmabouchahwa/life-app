import 'package:flutter/material.dart';

/// Colour tokens, taken from the Figma variables (Foundations / Light & Dark).
///
/// 60 / 30 / 10 rule: parchment backgrounds, bottle-green brand, brass accent.
/// Brass is reserved for the main action, the NOW marker and the active tab.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bgBase,
    required this.bgCard,
    required this.bgSunken,
    required this.line,
    required this.textPrimary,
    required this.textSecondary,
    required this.brand,
    required this.onBrand,
    required this.brandSoft,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.danger,
    required this.catClass,
    required this.catGym,
    required this.catStudy,
    required this.catWork,
    required this.catCommute,
  });

  // Figma variables.
  final Color bgBase;
  final Color bgCard;
  final Color bgSunken;
  final Color line;
  final Color textPrimary;
  final Color textSecondary;
  final Color brand;
  final Color onBrand;
  final Color brandSoft;
  final Color accent;
  final Color onAccent;
  final Color accentSoft;

  // Semantic colours (not Figma variables, picked to sit in the palette).
  final Color danger;
  final Color catClass;
  final Color catGym;
  final Color catStudy;
  final Color catWork;
  final Color catCommute;

  static const light = AppColors(
    bgBase: Color(0xFFF2ECE0),
    bgCard: Color(0xFFFBF8F0),
    bgSunken: Color(0xFFE8E0CF),
    line: Color(0xFFD8CEB8),
    textPrimary: Color(0xFF1B2420),
    textSecondary: Color(0xFF565E57),
    brand: Color(0xFF1D3B33),
    onBrand: Color(0xFFF4EFE2),
    brandSoft: Color(0xFFDCE3D6),
    accent: Color(0xFFB08D3E),
    onAccent: Color(0xFF1B2A24),
    accentSoft: Color(0xFFEFE3C4),
    danger: Color(0xFFA4473A),
    catClass: Color(0xFF1D3B33),
    catGym: Color(0xFF9A5B3C),
    catStudy: Color(0xFF4D6A8A),
    catWork: Color(0xFF6B5A8A),
    catCommute: Color(0xFF8A8F86),
  );

  static const dark = AppColors(
    bgBase: Color(0xFF121714),
    bgCard: Color(0xFF1A211D),
    bgSunken: Color(0xFF0D110F),
    line: Color(0xFF2B342E),
    textPrimary: Color(0xFFEEE9DA),
    textSecondary: Color(0xFFA3A99D),
    brand: Color(0xFF234A40),
    onBrand: Color(0xFFF1ECDD),
    brandSoft: Color(0xFF1F2E28),
    accent: Color(0xFFD4AF5F),
    onAccent: Color(0xFF17120A),
    accentSoft: Color(0xFF33291A),
    danger: Color(0xFFD9826F),
    catClass: Color(0xFF6FA593),
    catGym: Color(0xFFCB8A66),
    catStudy: Color(0xFF8AA6C4),
    catWork: Color(0xFFA897C6),
    catCommute: Color(0xFF8E968C),
  );

  /// Tokens are fixed per theme, so copyWith returns the same instance.
  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      bgBase: l(bgBase, other.bgBase),
      bgCard: l(bgCard, other.bgCard),
      bgSunken: l(bgSunken, other.bgSunken),
      line: l(line, other.line),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      brand: l(brand, other.brand),
      onBrand: l(onBrand, other.onBrand),
      brandSoft: l(brandSoft, other.brandSoft),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentSoft: l(accentSoft, other.accentSoft),
      danger: l(danger, other.danger),
      catClass: l(catClass, other.catClass),
      catGym: l(catGym, other.catGym),
      catStudy: l(catStudy, other.catStudy),
      catWork: l(catWork, other.catWork),
      catCommute: l(catCommute, other.catCommute),
    );
  }
}
