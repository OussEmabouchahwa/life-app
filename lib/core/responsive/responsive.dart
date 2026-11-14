import 'package:flutter/widgets.dart';

/// The Figma frames are drawn at 390 × 844. Every measurement read from the
/// design is relative to this frame.
abstract final class DesignFrame {
  static const double width = 390;
  static const double height = 844;
}

/// Screen-relative sizing.
///
/// Nothing in the UI uses a raw constant for layout. Either:
///  * `context.wp(0.2)` / `context.hp(0.2)` → 20 % of the screen width/height,
///    for things that are a share of the screen (rings, spacers, hero areas).
///  * `context.dp(22)` → a Figma measurement converted to this screen.
///    It equals `22 / 390` of the width, so it is a percentage too, but you can
///    copy numbers straight from Figma.
///
/// `MediaQuery.sizeOf` only rebuilds a widget when the size changes, so these
/// calls are cheap.
extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Fraction of the screen width (0.0 – 1.0).
  double wp(double fraction) => screenSize.width * fraction;

  /// Fraction of the screen height (0.0 – 1.0).
  double hp(double fraction) => screenSize.height * fraction;

  /// Width ratio between this screen and the Figma frame. Clamped so small
  /// phones stay readable and tablets do not blow everything up.
  double get scaleFactor => (screenSize.width / DesignFrame.width).clamp(0.85, 1.25);

  /// Converts a Figma measurement (px on the 390 frame) to this screen.
  double dp(double figmaPx) => figmaPx * scaleFactor;

  /// Symmetric padding from Figma values.
  EdgeInsets padAll(double figmaPx) => EdgeInsets.all(dp(figmaPx));

  EdgeInsetsDirectional padSym({double h = 0, double v = 0}) =>
      EdgeInsetsDirectional.symmetric(horizontal: dp(h), vertical: dp(v));
}
