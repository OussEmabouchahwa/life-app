import 'package:flutter/widgets.dart';

import '../responsive/responsive.dart';

/// Vertical space in Figma px, scaled to the screen.
class VGap extends StatelessWidget {
  const VGap(this.figmaPx, {super.key});

  final double figmaPx;

  @override
  Widget build(BuildContext context) => SizedBox(height: context.dp(figmaPx));
}

/// Horizontal space in Figma px, scaled to the screen.
class HGap extends StatelessWidget {
  const HGap(this.figmaPx, {super.key});

  final double figmaPx;

  @override
  Widget build(BuildContext context) => SizedBox(width: context.dp(figmaPx));
}
