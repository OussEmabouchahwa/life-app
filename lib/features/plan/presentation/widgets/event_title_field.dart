import 'package:flutter/material.dart';

import '../../../../core/ui.dart';

/// Labelled text input in the card style ("Title  Revision · Algorithms").
class EventTitleField extends StatelessWidget {
  const EventTitleField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title', style: context.text.caption.tint(c.textSecondary)),
          TextField(
            autofocus: true,
            onChanged: onChanged,
            style: context.text.bodyStrong.copyWith(fontSize: context.text.title.fontSize),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: 'Revision · Algorithms',
              hintStyle: context.text.bodyStrong.tint(c.textSecondary.withValues(alpha: 0.5)),
              contentPadding: EdgeInsets.only(top: context.dp(4)),
            ),
          ),
        ],
      ),
    );
  }
}
