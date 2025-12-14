// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des items de navigation (non utilisé actuellement)
import '../utils/nav_items.dart';
// Import du widget barre de navigation inférieure personnalisé
import '../widgets/bottom_nav_bar.dart';
// Import de l'écran d'accueil
import 'HomeScreen.dart';
// Import de l'écran de liste des clubs
import 'ClubsScreen.dart';
// Import de l'écran de liste des annonces
import 'AnnoncesScreen.dart';
// Import de l'écran de liste des événements
import 'EvenementsScreen.dart';
// Import de l'écran de calendrier (liste des cours)
import 'CalendrierScreen.dart';

/// Écran principal avec navigation par bottom bar
/// Gère l'affichage des différents écrans selon l'onglet sélectionné
/// Utilise un IndexedStack pour conserver l'état de chaque écran
class MainNavigationScreen extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const MainNavigationScreen({super.key});

  // Nom de la route pour la navigation
  static const String routeName = '/main';

  // Crée l'état associé à ce widget
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

// Classe d'état privée pour gérer l'état de la navigation
class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Index de l'onglet actuellement sélectionné (0 = Accueil)
  int _currentIndex = 0;

  /// Liste des écrans correspondant aux items de navigation
  /// Chaque écran est conservé en mémoire grâce à IndexedStack
  final List<Widget> _screens = [
    // Écran d'accueil (index 0)
    const HomeScreen(),
    // Écran de liste des clubs (index 1)
    const ClubsScreen(),
    // Écran de liste des annonces (index 2)
    const AnnoncesScreen(),
    // Écran de liste des événements (index 3)
    const EvenementsScreen(),
    // Écran de calendrier/liste des cours (index 4)
    const CalendrierScreen(),
  ];

  /// Gère le changement d'onglet
  /// Met à jour l'index de l'onglet sélectionné
  void _onTabTapped(int index) {
    // Met à jour l'état avec le nouvel index
    setState(() {
      // Assigne le nouvel index sélectionné
      _currentIndex = index;
    });
  }

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Retourne un Scaffold qui est la structure de base d'un écran Material Design
    return Scaffold(
      // Corps de l'écran
      body: IndexedStack(
        // Index de l'écran à afficher
        index: _currentIndex,
        // Liste des écrans disponibles
        children: _screens,
      ),
      // Barre de navigation inférieure
      bottomNavigationBar: AppBottomNavBar(
        // Index de l'onglet actuellement sélectionné
        currentIndex: _currentIndex,
        // Fonction à exécuter lors du tap sur un onglet
        onTap: _onTabTapped,
      ),
    );
  }
}

