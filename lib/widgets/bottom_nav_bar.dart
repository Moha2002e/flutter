import 'package:flutter/material.dart'; // Importation du paquet principal de Flutter pour l'UI
import '../styles/colors.dart'; // Importation des constantes de couleurs définies dans le projet
import '../styles/sizes.dart'; // Importation des constantes de tailles définies dans le projet
import '../utils/nav_items.dart'; // Importation de l'énumération ou classe définissant les items de navigation

// Classe représentant la barre de navigation inférieure personnalisée
class AppBottomNavBar extends StatelessWidget {
  // Constructeur de la constante AppBottomNavBar
  const AppBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  // Index de l'élément actuellement sélectionné dans la barre
  final int currentIndex;
  // Fonction de rappel appelée lorsqu'un élément est tapé/cliqué
  final Function(int) onTap;

  // Méthode build pour construire l'interface du widget
  @override
  Widget build(BuildContext context) {
    // Retourne un Container pour pouvoir appliquer une décoration (gradient)
    return Container(
      // Application de la décoration avec un dégradé défini dans kBottomNavBarGradient
      decoration: const BoxDecoration(gradient: kBottomNavBarGradient),
      // L'enfant du container est le widget BottomNavigationBar standard
      child: BottomNavigationBar(
        // Définit l'élément actif actuel
        currentIndex: currentIndex,
        // Définit l'action à effectuer au tap
        onTap: onTap,
        // Type fixe pour que les items ne bougent pas lors de la sélection
        type: BottomNavigationBarType.fixed,
        // Fond transparent car le Container parent gère la couleur/gradient
        backgroundColor: Colors.transparent,
        // Couleur de l'icône/texte de l'élément sélectionné
        selectedItemColor: kWhiteColor,
        // Couleur de l'élément non sélectionné (blanc avec opacité)
        unselectedItemColor: kWhiteColor.withOpacity(kBottomNavBarUnselectedOpacity),
        // Taille de police pour l'élément sélectionné
        selectedFontSize: kBottomNavBarSelectedFontSize,
        // Taille de police pour l'élément non sélectionné
        unselectedFontSize: kBottomNavBarUnselectedFontSize,
        // Taille des icônes
        iconSize: kBottomNavBarIconSize,
        // Suppression de l'ombre par défaut (elevation 0)
        elevation: 0,
        // Génération de la liste des items à partir de NavItem.values
        items: NavItem.values.map((item) {
          // Vérifie si cet item est l'item actuellement sélectionné
          final isSelected = NavItem.values.indexOf(item) == currentIndex;
          // Retourne un BottomNavigationBarItem pour chaque élément
          return BottomNavigationBarItem(icon: Icon(isSelected ? item.selectedIcon : item.icon), label: item.label);
        }).toList(), // Conversion de l'itérable en liste
      ),
    );
  }
}

