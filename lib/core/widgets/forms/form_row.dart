import 'package:flutter/widgets.dart';

import '../../responsive/responsive.dart';
import '../eyebrow.dart';

/// Fields side by side with equal width.
class FormRow extends StatelessWidget {
  const FormRow({super.key, required this.children, this.spacing = 8});

  final List<Widget> children;

  /// Gap in Figma px.
  final double spacing;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) SizedBox(width: context.dp(spacing)),
        Expanded(child: children[i]),
      ],
    ],
  );
}

/// Eyebrow title over a group of fields.
class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Eyebrow(title),
      for (final child in children) ...[SizedBox(height: context.dp(8)), child],
    ],
  );
}
