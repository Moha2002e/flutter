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

/// Widget réutilisable pour les cartes d'information du profil (ex: Email: ...)
/// Affiche une carte avec une icône, un label et une valeur
class ProfileInfoCard extends StatelessWidget {
  // Constructeur constant avec paramètres nommés
  const ProfileInfoCard({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Icône obligatoire à afficher (Material Design icon)
    required this.icon,
    // Titre obligatoire (ex: "Email", "Compte créé le")
    required this.label,
    // Valeur obligatoire à afficher (ex: "test@test.com", "01/01/2024")
    required this.value,
  });

  // Icône Material Design à afficher dans la carte
  final IconData icon;
  // Label/titre de la carte
  final String label;
  // Valeur/information affichée dans la carte
  final String value;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Conteneur avec fond et bordure arrondie
    return Container(
      // Padding interne uniforme autour du contenu
      padding: const EdgeInsets.all(kInputFieldPadding),
      // Décoration du conteneur
      decoration: BoxDecoration(
        // Fond blanc semi-transparent selon l'opacité définie
        color: kWhiteColor.withValues(alpha: kProfileInfoBackgroundOpacity),
        // Coins arrondis selon la constante définie
        borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
      ),
      // Ligne horizontale contenant l'icône et les informations
      child: Row(
        children: [
          // Affiche l'icône en blanc avec taille définie
          Icon(icon, color: kWhiteColor, size: kProfileInfoIconSize),
          // Espacement horizontal entre l'icône et le texte
          const SizedBox(width: kSmallSpace),
          // Expanded pour que la colonne prenne le reste de la place disponible
          Expanded(
            // Colonne pour organiser le label et la valeur verticalement
            child: Column(
              // Alignement des enfants à gauche
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Texte du label
                Text(
                  // Label affiché (ex: "Email")
                  label,
                  // Style du label avec taille agrandie selon la constante définie
                  style: kLabelText.copyWith(fontSize: kProfileLabelFontSize),
                ),
                // Espacement vertical entre le label et la valeur
                const SizedBox(height: kProfileInfoSpacing),
                // Texte de la valeur avec style prédéfini
                Text(value, style: kProfileInfoValueText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

