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

/// Widget réutilisable pour les champs de formulaire génériques (texte simple)
class FormTextField extends StatelessWidget {
  // Constructeur constant avec paramètres nommés
  const FormTextField({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Label obligatoire affiché au-dessus du champ
    required this.label,
    // Contrôleur obligatoire pour récupérer et contrôler la valeur du champ
    required this.controller,
    // Optionnel : masque le texte (pour mot de passe éventuel, défaut: false)
    this.obscureText = false,
    // Optionnel : nombre de lignes (1 par défaut, plus pour les descriptions)
    this.maxLines = 1,
    // Optionnel : fonction de validation personnalisée
    this.validator,
  });

  // Label affiché au-dessus du champ de texte
  final String label;
  // Contrôleur pour gérer le texte saisi dans le champ
  final TextEditingController controller;
  // Indique si le texte doit être masqué (pour les mots de passe)
  final bool obscureText;
  // Nombre maximum de lignes pour le champ (1 = ligne unique, >1 = multiligne)
  final int maxLines;
  // Fonction de validation personnalisée pour valider la saisie
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
        // Champ de formulaire pour la saisie de texte
        TextFormField(
          // Lie le champ au contrôleur pour récupérer/modifier la valeur
          controller: controller,
          // Masque ou affiche le texte selon le paramètre
          obscureText: obscureText,
          // Nombre maximum de lignes pour le champ
          maxLines: maxLines,
          // Style du texte saisi dans le champ
          style: kInputText,
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
          // Utilise le validateur fourni ou celui par défaut (vérifie que le champ n'est pas vide)
          validator: validator ?? (v) => v == null || v.isEmpty ? 'Ce champ est requis' : null,
        ),
      ],
    );
  }
}

