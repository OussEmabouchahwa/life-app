/// Design measurements in Figma px (390-wide frame).
///
/// These are never used directly as sizes: always pass them through
/// `context.dp(...)` so they scale with the screen.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  /// Horizontal page margin: 346 px of content inside a 390 px frame.
  static const double gutter = 22;

  /// Vertical gap between the main blocks of a screen.
  static const double section = 16;
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;
}

abstract final class AppSizes {
  static const double iconButton = 42;
  static const double buttonHeight = 52;
  static const double checkCircle = 24;
  static const double categoryBar = 3;
  static const double progressBar = 5;
  static const double icon = 20;
  static const double iconSmall = 16;
  static const double tabIcon = 22;
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
}
