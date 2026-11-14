import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// Ring showing calories eaten vs goal. Its diameter is a share of the
/// screen width (33 %, 128 px on the Figma frame).
class CalorieRing extends StatelessWidget {
  const CalorieRing({super.key, required this.eaten, required this.goal});

  final double eaten;
  final double goal;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = context.wp(0.33);
    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: goal == 0 ? 0 : (eaten / goal).clamp(0, 1)),
        duration: AppDurations.normal * 2,
        builder: (context, progress, child) => CustomPaint(
          painter: _RingPainter(progress: progress, track: c.bgSunken, fill: c.brand, stroke: size * 0.08),
          child: child,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_thousands(eaten), style: context.text.timeLarge),
              Text('kcal eaten', style: context.text.caption.tint(c.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  static String _thousands(double v) {
    final s = v.round().toString();
    return s.length > 3 ? '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}' : s;
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.track, required this.fill, required this.stroke});

  final double progress;
  final Color track;
  final Color fill;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress, false, paint..color = fill);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.track != track || old.fill != fill || old.stroke != stroke;
}
