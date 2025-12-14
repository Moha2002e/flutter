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

/// Widget réutilisable pour les champs dropdown (liste déroulante)
/// Affiche un menu déroulant avec une liste d'options à sélectionner
class DropdownField extends StatelessWidget {
  // Constructeur constant avec paramètres nommés
  const DropdownField({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Label obligatoire affiché au-dessus du champ
    required this.label,
    // Liste obligatoire des options à afficher dans le menu déroulant
    required this.items,
    // Valeur actuellement sélectionnée (peut être null si aucune sélection)
    required this.value,
    // Fonction callback obligatoire appelée quand une nouvelle valeur est choisie
    required this.onChanged,
    // Optionnel : fonction de validation personnalisée
    this.validator,
  });

  // Label affiché au-dessus du menu déroulant
  final String label;
  // Liste des options (chaînes de caractères) à afficher dans le menu
  final List<String> items;
  // Valeur actuellement sélectionnée (peut être null)
  final String? value;
  // Fonction callback appelée avec la nouvelle valeur sélectionnée
  final Function(String?) onChanged;
  // Fonction de validation personnalisée pour valider la sélection
  final String? Function(String?)? validator;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Retourne une colonne pour organiser le label et le menu déroulant verticalement
    return Column(
      // Alignement des enfants à gauche
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texte du label affiché au-dessus du menu déroulant
        Text(label, style: kLabelText),
        // Espacement vertical entre le label et le menu déroulant
        const SizedBox(height: kSpacingBetweenLabelAndField),
        // Widget DropdownButtonFormField qui gère l'affichage et la validation
        DropdownButtonFormField<String>(
          // Valeur actuellement sélectionnée
          value: value,
          // Décoration du champ (fond, bordure, padding)
          decoration: InputDecoration(
            // Active le remplissage du fond
            filled: true,
            // Couleur de fond blanche
            fillColor: kWhiteColor,
            // Configuration de la bordure
            border: OutlineInputBorder(
              // Coins arrondis selon la constante définie
              borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
              // Pas de bordure visible (bordure transparente)
              borderSide: BorderSide.none,
            ),
            // Padding interne du champ
            contentPadding: const EdgeInsets.symmetric(
              // Padding horizontal
              horizontal: kInputFieldPadding,
              // Padding vertical
              vertical: kInputFieldPadding,
            ),
          ),
          // Style du texte sélectionné affiché dans le champ
          style: kInputText,
          // Icône de la flèche vers le bas affichée à droite
          icon: Icon(
            // Icône Material Design de flèche vers le bas
            Icons.arrow_drop_down,
            // Taille de l'icône selon la constante définie
            size: kDropdownIconSize,
            // Couleur gris foncé pour l'icône
            color: Colors.black54,
          ),
          // Transformation de la liste de String en liste de DropdownMenuItem
          items: items.map((item) {
            // Crée un élément de menu pour chaque option
            return DropdownMenuItem<String>(
              // Valeur interne de l'item (utilisée pour la sélection)
              value: item,
              // Affichage de l'item dans le menu
              child: Text(item),
            );
          }).toList(), // Convertit l'itérable en liste
          // Action quand une nouvelle valeur est choisie
          onChanged: onChanged,
          // Utilise le validateur fourni ou celui par défaut (vérifie qu'une option est sélectionnée)
          validator: validator ?? (v) => v == null || v.isEmpty ? 'Veuillez sélectionner une option' : null,
        ),
      ],
    );
  }
}

