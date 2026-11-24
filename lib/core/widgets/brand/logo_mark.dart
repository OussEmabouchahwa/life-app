import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';

/// Brand colours of the logo. Fixed (not theme tokens) so the icon looks the
/// same everywhere, like any logo.
abstract final class BrandColors {
  static const green = Color(0xFF1D3B33);
  static const greenDeep = Color(0xFF15302A);
  static const brass = Color(0xFFC9A24E);
  static const parchment = Color(0xFFF4EFE2);
}

/// The logo mark: the "OB" monogram (Oussema Bouchahwa) inside a brass ring.
/// The ring is a day dial filling up; its dot is the app's NOW marker.
///
/// [background] draws the green rounded square (app icon); without it the
/// mark is drawn alone, e.g. for the Android adaptive-icon foreground.
class LogoMark extends StatelessWidget {
  const LogoMark({
    super.key,
    required this.size,
    this.background = true,
    this.rounded = true,
    this.scale = 1,
  });

  final double size;
  final bool background;

  /// Square corners for iOS, which rounds the icon itself.
  final bool rounded;

  /// Shrinks the drawing inside the square (adaptive icons need a safe zone).
  final double scale;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: _LogoPainter(background: background, rounded: rounded, scale: scale),
    ),
  );
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({required this.background, required this.rounded, required this.scale});

  final bool background;
  final bool rounded;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final center = Offset(s / 2, s / 2);

    if (background) {
      final rect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(rounded ? s * 0.225 : 0));
      canvas.drawRRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [BrandColors.green, BrandColors.greenDeep],
          ).createShader(Offset.zero & size),
      );
    }

    final u = s * scale; // drawing unit
    final radius = u * 0.34;
    final stroke = u * 0.042;
    final circle = Rect.fromCircle(center: center, radius: radius);

    // Track of the dial, then the brass arc: about 5/6 of the day.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = BrandColors.parchment.withValues(alpha: 0.14),
    );
    const start = -math.pi / 2, sweep = math.pi * 2 * 0.83;
    canvas.drawArc(
      circle,
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = BrandColors.brass,
    );

    // NOW dot at the end of the arc.
    final end = start + sweep;
    final dot = center + Offset(math.cos(end), math.sin(end)) * radius;
    canvas.drawCircle(dot, stroke * 1.25, Paint()..color = BrandColors.parchment);
    canvas.drawCircle(dot, stroke * 0.7, Paint()..color = BrandColors.brass);

    // Monogram.
    final text = TextPainter(
      text: TextSpan(
        text: 'OB',
        style: TextStyle(
          fontFamily: AppTextStyles.serifFamily,
          fontWeight: FontWeight.w600,
          fontSize: u * 0.3,
          height: 1,
          letterSpacing: -u * 0.012,
          color: BrandColors.parchment,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, center - Offset(text.width / 2, text.height / 2 + u * 0.004));
  }

  @override
  bool shouldRepaint(_LogoPainter old) =>
      old.background != background || old.rounded != rounded || old.scale != scale;
}
