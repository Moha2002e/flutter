import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../utils/nav_items.dart';

/// Widget réutilisable pour la barre de navigation en bas
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: kBottomNavBarGradient,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: kWhiteColor,
        unselectedItemColor: kWhiteColor.withOpacity(kBottomNavBarUnselectedOpacity),
        selectedFontSize: kBottomNavBarSelectedFontSize,
        unselectedFontSize: kBottomNavBarUnselectedFontSize,
        iconSize: kBottomNavBarIconSize,
        elevation: 0,
      items: NavItem.values.map((item) {
        final isSelected = NavItem.values.indexOf(item) == currentIndex;
        return BottomNavigationBarItem(
          icon: Icon(isSelected ? item.selectedIcon : item.icon),
          label: item.label,
        );
      }).toList(),
      ),
    );
  }
}

