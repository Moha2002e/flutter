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
// Import des utilitaires de date (formatage, sélection)
import '../utils/date_utils.dart';

/// Widget réutilisable pour les champs de date
/// Affiche un champ texte en lecture seule qui ouvre un sélecteur de date au clic
class DateField extends StatelessWidget {
  // Constructeur constant avec paramètres nommés
  const DateField({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Label obligatoire affiché au-dessus du champ
    required this.label,
    // Contrôleur obligatoire pour gérer le texte affiché (date formatée)
    required this.controller,
    // Fonction callback obligatoire appelée quand une date est choisie
    required this.onDateSelected,
    // Optionnel : fonction de validation personnalisée
    this.validator,
  });

  // Label affiché au-dessus du champ de date
  final String label;
  // Contrôleur pour gérer le texte affiché (date formatée)
  final TextEditingController controller;
  // Fonction callback appelée avec la date sélectionnée
  final Function(DateTime) onDateSelected;
  // Fonction de validation personnalisée pour valider la date
  final String? Function(String?)? validator;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Retourne une colonne pour organiser le label et le champ verticalement
    return Column(
      // Alignement des enfants à gauche
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texte du label affiché au-dessus du champ
        Text(label, style: kLabelText),
        // Espacement vertical entre le label et le champ
        const SizedBox(height: kSpacingBetweenLabelAndField),
        // Champ de formulaire textuel (lecture seule)
        TextFormField(
          // Lie le champ au contrôleur pour afficher la date formatée
          controller: controller,
          // Lecture seule pour empêcher la saisie manuelle (ouvre le sélecteur au clic)
          readOnly: true,
          // Style du texte affiché dans le champ
          style: kInputText,
          // Décoration du champ (fond, bordure, padding, icône)
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
            // Icône suffixe affichée à la fin du champ (calendrier)
            suffixIcon: Icon(
              // Icône Material Design de calendrier
              Icons.calendar_today,
              // Taille de l'icône selon la constante définie
              size: kDatePickerIconSize,
              // Couleur gris foncé pour l'icône
              color: Colors.black54,
            ),
          ),
          // Action au tap sur le champ : ouvre le sélecteur de date
          onTap: () async {
            // Ouvre le sélecteur de date et attend la sélection
            final date = await AppDateUtils.selectDate(context: context);
            // Si une date a été sélectionnée (non null)
            if (date != null) {
              // Met à jour le texte du contrôleur avec la date formatée
              controller.text = AppDateUtils.formatDate(date);
              // Appelle la callback avec la date sélectionnée
              onDateSelected(date);
            }
          },
          // Utilise le validateur fourni ou celui par défaut (vérifie que le champ n'est pas vide)
          validator: validator ?? (v) => v == null || v.isEmpty ? 'Veuillez sélectionner une date' : null,
        ),
      ],
    );
  }
}

