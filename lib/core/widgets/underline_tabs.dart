import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../theme/app_dimens.dart';
import '../theme/theme_context.dart';

/// Text tabs with a brass underline under the active one (Exams · Revision · Grades).
class UnderlineTabs<T> extends StatelessWidget {
  const UnderlineTabs({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.line)),
      ),
      // Scrolls sideways if the labels do not fit (small phones, long translations).
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final v in values)
              GestureDetector(
                onTap: () => onChanged(v),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: context.dp(26)),
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          labelOf(v),
                          style: context.text.body.copyWith(
                            fontWeight: v == selected ? FontWeight.w700 : FontWeight.w500,
                            color: v == selected ? c.textPrimary : c.textSecondary,
                          ),
                        ),
                        SizedBox(height: context.dp(8)),
                        AnimatedContainer(
                          duration: AppDurations.fast,
                          height: context.dp(2),
                          color: v == selected ? c.accent : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
