// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';
// Import des styles de texte prédéfinis
import '../styles/texts.dart';

/// Widget réutilisable pour le bouton Annuler
/// Affiche un bouton gris avec texte blanc pour annuler une action
class CancelButton extends StatelessWidget {
  // Constructeur constant avec paramètres nommés
  const CancelButton({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Fonction obligatoire à appeler au clic
    required this.onPressed,
    // Texte optionnel du bouton (défaut: 'Annuler')
    this.label = 'Annuler',
  });

  // Fonction callback appelée lors du clic sur le bouton
  final VoidCallback onPressed;
  // Texte affiché sur le bouton
  final String label;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Utilisation de Expanded pour que le bouton prenne tout l'espace disponible
    return Expanded(
      // Création d'un bouton surélevé (ElevatedButton)
      child: ElevatedButton(
        // Assignation de la fonction à exécuter lors de l'appui
        onPressed: onPressed,
        // Définition du style du bouton personnalisé
        style: ElevatedButton.styleFrom(
          // Couleur de fond du bouton (gris pour annuler)
          backgroundColor: Colors.grey,
          // Couleur du texte et des icônes au premier plan (blanc)
          foregroundColor: kWhiteColor,
          // Padding vertical à l'intérieur du bouton selon la constante définie
          padding: EdgeInsets.symmetric(vertical: kInputFieldPadding),
          // Forme du bouton : rectangle avec bords arrondis
          shape: RoundedRectangleBorder(
            // Rayon des coins arrondis selon la constante définie
            borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
          ),
        ),
        // Texte affiché dans le bouton
        child: Text(
          // Le texte "Annuler" ou autre texte personnalisé
          label,
          // Style du texte, basé sur kProfileButtonText avec modification de couleur en blanc
          style: kProfileButtonText.copyWith(color: kWhiteColor),
        ),
      ),
    );
  }
}

