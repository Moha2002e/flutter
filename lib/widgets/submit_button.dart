// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';

/// Widget réutilisable pour les boutons de soumission
/// Affiche un bouton avec indicateur de chargement optionnel
class SubmitButton extends StatelessWidget {
  // Constructeur constant avec paramètres nommés
  const SubmitButton({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Texte obligatoire affiché sur le bouton
    required this.label,
    // Fonction obligatoire appelée au clic (peut être null si désactivé)
    required this.onPressed,
    // État de chargement optionnel (défaut: false)
    this.loading = false,
    // Couleur de fond optionnelle (défaut: couleur du bouton de connexion)
    this.backgroundColor = kLoginButtonColor,
    // Couleur du texte optionnelle (défaut: blanc)
    this.foregroundColor,
  });

  // Texte à afficher sur le bouton
  final String label;
  // Fonction callback appelée au clic (peut être null si désactivé)
  final VoidCallback? onPressed;
  // Booléen pour indiquer si le bouton est en mode chargement
  final bool loading;
  // Couleur de fond du bouton
  final Color backgroundColor;
  // Couleur du texte/icône (optionnelle, défaut: blanc)
  final Color? foregroundColor;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Détermine la couleur du texte (celle fournie ou blanc par défaut)
    final textColor = foregroundColor ?? kWhiteColor;
    // SizedBox pour donner une largeur infinie au bouton
    return SizedBox(
      // Largeur infinie : prend toute la largeur du parent
      width: double.infinity,
      // Création d'un bouton surélevé (ElevatedButton)
      child: ElevatedButton(
        // Si loading est vrai, onPressed est null (désactive le bouton), sinon action normale
        onPressed: loading ? null : onPressed,
        // Style du bouton personnalisé
        style: ElevatedButton.styleFrom(
          // Couleur de fond du bouton
          backgroundColor: backgroundColor,
          // Couleur du premier plan (texte/icônes)
          foregroundColor: textColor,
          // Padding vertical standardisé
          padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
          // Forme rectangulaire arrondie
          shape: RoundedRectangleBorder(
            // Rayon de l'arrondi selon la constante définie
            borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
          ),
        ),
        // Contenu enfant du bouton (conditionnel selon l'état de chargement)
        child: loading
            // Si en chargement, affiche un indicateur de progression circulaire
            ? CircularProgressIndicator(color: textColor)
            // Sinon, affiche le texte du bouton
            : Text(
                // Texte du bouton
                label,
                // Style du texte défini manuellement
                style: TextStyle(
                  // Taille de police de 18 pixels
                  fontSize: 18,
                  // Police personnalisée 'Avenir'
                  fontFamily: 'Avenir',
                  // Graisse de police semi-gras (w600)
                  fontWeight: FontWeight.w600,
                  // Couleur du texte
                  color: textColor,
                ),
              ),
      ),
    );
  }
}

