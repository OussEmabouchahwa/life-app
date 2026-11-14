import 'package:flutter/material.dart';

/// A column with a hairline divider between each child (list cards).
class DividedColumn extends StatelessWidget {
  const DividedColumn({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 0; i < children.length; i++) ...[if (i > 0) const Divider(), children[i]],
    ],
  );
}
