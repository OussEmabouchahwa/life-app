import 'package:flutter/material.dart';

import '../../../core/ui.dart';

class TabItem {
  const TabItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Bottom bar: hairline on top, brass marker over the active tab.
class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key, required this.items, required this.current, required this.onTap});

  final List<TabItem> items;
  final int current;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.bgBase,
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: context.dp(60),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _Tab(item: items[i], active: i == current, onTap: () => onTap(i)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.active, required this.onTap});

  final TabItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = active ? c.textPrimary : c.textSecondary;
    return Semantics(
      selected: active,
      button: true,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: AppDurations.fast,
              width: context.dp(28),
              height: context.dp(2),
              color: active ? c.accent : Colors.transparent,
            ),
            const VGap(6),
            Icon(item.icon, size: context.dp(AppSizes.tabIcon), color: color),
            const VGap(4),
            Text(
              item.label,
              style: context.text.caption.copyWith(
                color: color,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
