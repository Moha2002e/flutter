import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../utils/nav_items.dart';
import '../widgets/bottom_nav_bar.dart';
import 'HomeScreen.dart';
import 'ClubsScreen.dart';
import 'AnnoncesScreen.dart';
import 'EvenementsScreen.dart';
import 'CalendrierScreen.dart';

/// Écran principal avec navigation par bottom bar
/// Gère l'affichage des différents écrans selon l'onglet sélectionné
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  static const String routeName = '/main';

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  /// Liste des écrans correspondant aux items de navigation
  final List<Widget> _screens = [
    const HomeScreen(),
    const ClubsScreen(),
    const AnnoncesScreen(),
    const EvenementsScreen(),
    const CalendrierScreen(),
  ];

  /// Gère le changement d'onglet
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

