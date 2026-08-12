import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';

/// Bottom-navigation container for the five main sections.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const List<_NavItem> _items = [
    _NavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavItem(
      label: 'Library',
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center_rounded,
    ),
    _NavItem(
      label: 'Streaks',
      icon: Icons.local_fire_department_outlined,
      activeIcon: Icons.local_fire_department_rounded,
    ),
    _NavItem(
      label: 'Progress',
      icon: Icons.show_chart_outlined,
      activeIcon: Icons.show_chart_rounded,
    ),
    _NavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  void _onTap(int index) {
    HapticFeedback.selectionClick();
    // Tapping the active tab pops that branch back to its root.
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: Sizes.bottomNavHeight,
            child: Row(
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(
                    child: _NavButton(
                      item: _items[i],
                      isActive: i == shell.currentIndex,
                      onTap: () => _onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tint = isActive ? c.accent : c.textTertiary;

    return Semantics(
      selected: isActive,
      button: true,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isActive ? 1.08 : 1,
                duration: Motion.fast,
                curve: Motion.emphasized,
                child: Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 23,
                  color: tint,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: tint,
                  fontSize: 10.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
