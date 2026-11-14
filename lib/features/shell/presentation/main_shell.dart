import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui.dart';
import 'app_tab_bar.dart';

/// Hosts the five tabs. Each tab keeps its own navigation stack.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const tabs = [
    TabItem('Today', AppIcons.home),
    TabItem('Plan', AppIcons.calendar),
    TabItem('Train', AppIcons.dumbbell),
    TabItem('Study', AppIcons.study),
    TabItem('Food', AppIcons.food),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: AppTabBar(
      items: tabs,
      current: shell.currentIndex,
      // Tapping the active tab again returns to its first screen.
      onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
    ),
  );
}
