import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';

/// Scrollable page body with the design's 22 px gutter.
///
/// [children] are laid out top to bottom with [spacing] between them, so
/// screens only list their blocks. [bottom] stays pinned under the scroll
/// area (main action buttons on pushed screens).
class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.children, this.bottom, this.spacing = AppSpacing.section});

  final List<Widget> children;
  final Widget? bottom;

  /// Space between blocks in Figma px.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final gutter = context.dp(AppSpacing.gutter);
    final gap = context.dp(spacing);
    return Scaffold(
      body: SafeArea(
        bottom: bottom != null,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsetsDirectional.fromSTEB(gutter, context.dp(8), gutter, gutter),
                itemCount: children.length,
                separatorBuilder: (_, _) => SizedBox(height: gap),
                itemBuilder: (_, i) => children[i],
              ),
            ),
            if (bottom != null)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(gutter, 0, gutter, context.dp(12)),
                child: bottom,
              ),
          ],
        ),
      ),
    );
  }
}
