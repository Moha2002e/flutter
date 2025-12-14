// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';
// Import du widget personnalisé pour les champs de texte d'authentification
import 'auth_text_field.dart';
// Import du widget personnalisé pour le bouton de soumission
import 'submit_button.dart';
// Import du widget personnalisé pour le bouton d'annulation
import 'cancel_button.dart';

/// Widget réutilisable pour la section de modification du mot de passe
/// Ce widget est un StatefulWidget car il gère l'état des champs de texte (contrôleurs).
class PasswordFormSection extends StatefulWidget {
  // Constructeur constant avec paramètres nommés
  const PasswordFormSection({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Clé globale obligatoire pour identifier et valider le formulaire
    required this.formKey,
    // Fonction callback obligatoire à exécuter lors de l'enregistrement
    required this.onSave,
    // Fonction callback obligatoire à exécuter lors de l'annulation
    required this.onCancel,
  });

  // Clé globale pour valider le formulaire
  final GlobalKey<FormState> formKey;
  // Fonction callback appelée lors de la sauvegarde
  final VoidCallback onSave;
  // Fonction callback appelée lors de l'annulation
  final VoidCallback onCancel;

  @override
  State<PasswordFormSection> createState() => _PasswordFormSectionState();
}

/// État du widget PasswordFormSection
/// Gère les contrôleurs de texte pour les champs de mot de passe
class _PasswordFormSectionState extends State<PasswordFormSection> {
  // Contrôleur pour récupérer le texte saisi dans le champ mot de passe actuel
  final _currentPasswordController = TextEditingController();
  // Contrôleur pour récupérer le texte saisi dans le champ nouveau mot de passe
  final _newPasswordController = TextEditingController();

  // Méthode appelée lorsque le widget est détruit
  @override
  void dispose() {
    // Libère les ressources du contrôleur mot de passe actuel
    _currentPasswordController.dispose();
    // Libère les ressources du contrôleur nouveau mot de passe
    _newPasswordController.dispose();
    // Appelle la méthode dispose de la classe parente
    super.dispose();
  }

  // Getter pour accéder facilement à la valeur du mot de passe actuel
  String get currentPassword => _currentPasswordController.text;
  // Getter pour accéder facilement à la valeur du nouveau mot de passe
  String get newPassword => _newPasswordController.text;

  // Méthode utilitaire pour vider les champs (par exemple après succès)
  void clearFields() {
    // Vide le champ mot de passe actuel
    _currentPasswordController.clear();
    // Vide le champ nouveau mot de passe
    _newPasswordController.clear();
  }

  // Méthode principale qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Form : Conteneur qui permet de valider plusieurs champs ensemble via une clé
    return Form(
      // Clé globale pour valider le formulaire
      key: widget.formKey,
      // Colonne pour organiser les champs et boutons verticalement
      child: Column(
        children: [
          // Champ pour le mot de passe actuel
          AuthTextField(
            // Label du champ
            label: 'Mot de passe actuel',
            // Contrôleur pour gérer le texte saisi
            controller: _currentPasswordController,
            // Masque le texte (étoiles) pour la sécurité
            obscureText: true,
          ),
          // Espacement vertical entre les champs
          const SizedBox(height: kSpacingBetweenFields),
          // Champ pour le nouveau mot de passe
          AuthTextField(
            // Label du champ
            label: 'Nouveau mot de passe',
            // Contrôleur pour gérer le texte saisi
            controller: _newPasswordController,
            // Masque le texte (étoiles) pour la sécurité
            obscureText: true,
          ),
          // Espacement vertical avant les boutons
          const SizedBox(height: kSpacingBeforeButton),
          // Ligne horizontale pour les boutons
          Row(
            children: [
              // Bouton Annuler qui prend une partie de l'espace
              CancelButton(onPressed: widget.onCancel),
              // Petit espacement horizontal entre les boutons
              const SizedBox(width: kSmallSpace),
              // Expanded permet au widget enfant de prendre tout l'espace disponible restant
              Expanded(
                // Bouton de soumission pour enregistrer
                child: SubmitButton(
                  // Texte affiché sur le bouton
                  label: 'Enregistrer',
                  // Pas d'indicateur de chargement ici (géré ailleurs)
                  loading: false,
                  // Action à exécuter lors du clic
                  onPressed: () {
                    // Vérifie si tous les champs du formulaire sont valides
                    if (widget.formKey.currentState!.validate()) {
                      // Déclenche l'action de sauvegarde si la validation réussit
                      widget.onSave();
                    }
                  },
                  // Couleur de fond blanche pour le bouton
                  backgroundColor: kWhiteColor,
                  // Couleur du texte (couleur principale)
                  foregroundColor: kMainButtonColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

