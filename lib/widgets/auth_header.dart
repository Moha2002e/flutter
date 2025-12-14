// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des images utilisées dans l'application
import '../styles/images.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';
// Import des styles de texte prédéfinis
import '../styles/texts.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';

/// Widget réutilisable pour l'en-tête des écrans d'authentification (Login, Register...)
/// Il affiche le logo et éventuellement un bouton retour
class AuthHeader extends StatelessWidget {
  // Constructeur constant pour optimiser les performances
  const AuthHeader({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Titre obligatoire à afficher (ex: "Bienvenue", "Connection")
    required this.title,
    // Action optionnelle pour le bouton retour (null si pas de bouton)
    this.onBack,
  });

  // Titre affiché sous le logo
  final String title;
  // Fonction callback optionnelle appelée lors du clic sur le bouton retour
  final VoidCallback? onBack;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Utilisation d'une colonne pour empiler le bouton retour (si présent) et le logo/titre
    return Column(
      children: [
        // Si une action de retour est fournie, on affiche le bouton retour
        if (onBack != null)
          // Padding autour du bouton retour
          Padding(
            // Marge uniforme autour du bouton
            padding: const EdgeInsets.all(kHorizontalPadding),
            // Alignement du bouton en haut à gauche
            child: Align(
              // Aligné en haut à gauche de l'écran
              alignment: Alignment.topLeft,
              // Détecteur de geste pour capturer le clic
              child: GestureDetector(
                // Déclenche l'action au clic
                onTap: onBack,
                // Conteneur circulaire pour le bouton
                child: Container(
                  // Taille fixe du bouton (carré)
                  width: kBackButtonSize,
                  height: kBackButtonSize,
                  // Décoration du conteneur
                  decoration: BoxDecoration(
                    // Fond blanc
                    color: kWhiteColor,
                    // Forme circulaire
                    shape: BoxShape.circle,
                  ),
                  // Icône flèche retour en noir
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
          ),
        // Alignement du logo et du titre au centre
        Align(
          // Aligné en haut au centre
          alignment: Alignment.topCenter,
          // Colonne pour empiler le logo et le titre
          child: Column(
            children: [
              // Affichage du logo depuis les assets
              Image.asset(
                // Chemin vers l'image du logo
                'assets/images/logo.png',
                // Largeur dynamique basée sur la largeur de l'écran
                width: MediaQuery.of(context).size.width * kWelcomeRatioForm,
              ),
              // Affichage du titre avec le style défini
              Text(title, style: kLoginTitleText),
            ],
          ),
        ),
      ],
    );
  }
}

