// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';

/// Bouton de retour personnalisé
/// Utilise un GestureDetector pour détecter le clic
class AppBackButton extends StatelessWidget {
  // Constructeur constant avec fonction callback obligatoire
  const AppBackButton({super.key, required this.onTap});
  // Fonction à appeler lors du clic sur le bouton
  final VoidCallback onTap;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Retourne un padding autour du bouton
    return Padding(
      // Espacement uniforme autour du bouton
      padding: const EdgeInsets.all(kHorizontalPadding),
      // Alignement du bouton en haut à gauche
      child: Align(
        // Positionné en haut à gauche de l'écran
        alignment: Alignment.topLeft,
        // Détecteur de geste pour capturer le clic
        child: GestureDetector(
          // Déclenche l'action de retour au clic
          onTap: onTap,
          // Conteneur circulaire pour le bouton
          child: Container(
            // Taille fixe du bouton (carré)
            width: kBackButtonSize,
            height: kBackButtonSize,
            // Décoration : cercle blanc
            decoration: BoxDecoration(color: kWhiteColor, shape: BoxShape.circle),
            // Icône flèche retour en noir
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

