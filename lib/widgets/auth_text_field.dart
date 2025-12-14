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

/// Un champ de texte personnalisé pour l'authentification (email, password...)
/// C'est un StatefulWidget car il gère l'état de la visibilité du mot de passe (obscureText)
class AuthTextField extends StatefulWidget {
  // Constructeur du widget avec paramètres nommés
  const AuthTextField({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Label obligatoire affiché au-dessus du champ
    required this.label,
    // Contrôleur obligatoire pour récupérer et contrôler la valeur du champ
    required this.controller,
    // Optionnel : indique si le texte doit être masqué (défaut: false)
    this.obscureText = false,
    // Optionnel : type de clavier à afficher (email, phone, etc.)
    this.keyboardType,
    // Optionnel : fonction de validation personnalisée
    this.validator,
    // Optionnel : contrôleur pour la confirmation de mot de passe (validation croisée)
    this.confirmPasswordController,
  });

  // Label affiché au-dessus du champ de texte
  final String label;
  // Contrôleur pour gérer le texte saisi dans le champ
  final TextEditingController controller;
  // Indique si le texte doit être masqué (pour les mots de passe)
  final bool obscureText;
  // Type de clavier à afficher (email, numérique, etc.)
  final TextInputType? keyboardType;
  // Fonction de validation personnalisée pour valider la saisie
  final String? Function(String?)? validator;
  // Contrôleur optionnel pour valider que deux mots de passe correspondent
  final TextEditingController? confirmPasswordController;

  // Crée l'état associé à ce widget
  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

// Classe d'état privée pour gérer l'état de visibilité du texte
class _AuthTextFieldState extends State<AuthTextField> {
  // État local pour savoir si le texte est masqué ou non (initialisé tardivement)
  late bool _isObscure;

  // Méthode appelée lors de l'initialisation du widget
  @override
  void initState() {
    // Appelle la méthode initState de la classe parente
    super.initState();
    // Initialise l'état de masquage avec la valeur passée en paramètre
    _isObscure = widget.obscureText;
  }

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Retourne une colonne pour organiser le label et le champ verticalement
    return Column(
      // Alignement des enfants à gauche
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texte du label affiché au-dessus du champ
        Text(widget.label, style: kLabelText),
        // Espacement vertical entre le label et le champ
        const SizedBox(height: kSpacingBetweenLabelAndField),
        // Champ de formulaire pour la saisie de texte
        TextFormField(
          // Lie le champ au contrôleur pour récupérer/modifier la valeur
          controller: widget.controller,
          // Masque ou affiche le texte selon l'état local
          obscureText: _isObscure,
          // Type de clavier à afficher (email, numérique, etc.)
          keyboardType: widget.keyboardType,
          // Style du texte saisi dans le champ
          style: kInputText,
          // Décoration du champ (fond, bordure, padding, icônes)
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
            contentPadding: const EdgeInsets.all(kInputFieldPadding),
            // Icône suffixe : ajoute une icône "œil" si c'est un champ mot de passe
            suffixIcon: widget.obscureText
                // Si c'est un champ mot de passe, affiche un bouton avec icône
                ? IconButton(
                    // Icône qui change selon l'état de visibilité (œil ouvert/fermé)
                    icon: Icon(_isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.black),
                    // Action au clic : inverse l'état de visibilité
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  )
                // Sinon, pas d'icône suffixe
                : null,
          ),
          // Utilise le validateur fourni en paramètre ou celui par défaut
          validator: widget.validator ?? _getDefaultValidator(),
        ),
      ],
    );
  }

  /// Génère un validateur par défaut selon le type de champ
  /// Retourne une fonction de validation adaptée au contexte (email, mot de passe, confirmation)
  String? Function(String?)? _getDefaultValidator() {
    // Cas 1 : Confirmation de mot de passe (si un contrôleur de confirmation est fourni)
    if (widget.confirmPasswordController != null) {
      // Retourne une fonction qui valide que le champ n'est pas vide et correspond au mot de passe original
      return (val) => (val == null || val.isEmpty) ? 'Confirmation requise' : (val != widget.confirmPasswordController!.text ? 'Non identique' : null);
    }
    // Cas 2 : Mot de passe (si le texte est masqué)
    if (widget.obscureText) {
      // Retourne une fonction qui valide que le champ n'est pas vide et respecte la longueur minimale
      return (val) => (val == null || val.isEmpty) ? 'Mot de passe requis' : (val.length < kMinPasswordLength ? 'Min $kMinPasswordLength caractères' : null);
    }
    // Cas 3 : Email (si le type de clavier est email)
    if (widget.keyboardType == TextInputType.emailAddress) {
      // Retourne une fonction qui valide que le champ n'est pas vide et contient le caractère @
      return (val) => (val == null || val.isEmpty) ? 'Email requis' : (!val.contains('@') ? 'Email invalide' : null);
    }
    // Cas 4 : Pas de validation par défaut pour les autres types de champs
    return null;
  }
}

