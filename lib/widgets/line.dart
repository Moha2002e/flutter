// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';

/// Widget Line qui affiche deux lignes séparées par "Où"
/// Utilisé comme séparateur décoratif dans l'interface
class Line extends StatelessWidget {
  // Constructeur constant pour optimiser les performances
  const Line({super.key});

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Padding externe vertical et horizontal autour du widget
    return Padding(
      // Padding symétrique horizontal et vertical selon les constantes définies
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL, vertical: kVerticalPaddingLMid),
      // Ligne horizontale (Row) pour organiser les éléments
      child: Row(
        children: [
          // Flexible permet à la ligne de prendre l'espace disponible
          Flexible(
            // Conteneur pour la ligne gauche avec hauteur et couleur
            child: Container(height: kWidth / 2, color: kMainButtonColor),
          ),
          // Espacement horizontal entre la ligne et le texte
          const SizedBox(width: kSmallSpace),
          // Texte central "Où"
          const Text('Où'),
          // Espacement horizontal entre le texte et la ligne
          const SizedBox(width: kSmallSpace),
          // Flexible permet à la ligne de prendre l'espace disponible
          Flexible(
            // Conteneur pour la ligne droite avec hauteur et couleur
            child: Container(height: kWidth / 2, color: kMainButtonColor),
          ),
        ],
      ),
    );
  }
}