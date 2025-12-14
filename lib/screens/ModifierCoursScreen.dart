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
// Import du widget bouton retour personnalisé
import '../widgets/back_button.dart';
// Import du widget champ de formulaire personnalisé
import '../widgets/form_text_field.dart';
// Import du widget bouton de soumission personnalisé
import '../widgets/submit_button.dart';
// Import du contrôleur pour gérer les opérations sur les cours
import '../controllers/cours_controller.dart';
// Import du modèle Cours pour typer les données
import '../models/cours.dart';

/// Écran pour modifier un cours existant
/// Permet à un utilisateur authentifié de modifier un cours qu'il a créé
class ModifierCoursScreen extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const ModifierCoursScreen({super.key});
  // Nom de la route pour la navigation
  static const String routeName = '/modifier-cours';

  // Crée l'état associé à ce widget
  @override
  State<ModifierCoursScreen> createState() => _ModifierCoursScreenState();
}

// Classe d'état privée pour gérer l'état du formulaire
class _ModifierCoursScreenState extends State<ModifierCoursScreen> {
  // Contrôleur pour le champ nom du cours (initialisé tardivement)
  late TextEditingController _nomController;
  // Contrôleur pour le champ nom du professeur (initialisé tardivement)
  late TextEditingController _nomProfController;
  // Contrôleur pour le champ local (initialisé tardivement)
  late TextEditingController _localController;
  // Date du cours (optionnelle)
  DateTime? _dateCours;
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();
  // Variable d'état pour indiquer si une opération est en cours
  bool _loading = false;
  // Cours à modifier (récupéré depuis les arguments de navigation)
  Cours? _cours;
  // Indicateur pour savoir si les contrôleurs ont été initialisés
  bool _initialized = false;

  // Méthode appelée quand les dépendances du widget changent
  @override
  void didChangeDependencies() {
    // Appelle la méthode didChangeDependencies de la classe parente
    super.didChangeDependencies();
    // Initialise les contrôleurs une seule fois
    if (!_initialized) {
      // Récupère le cours depuis les arguments de navigation
      _cours = ModalRoute.of(context)!.settings.arguments as Cours;
      // Initialise le contrôleur nom avec le nom actuel du cours
      _nomController = TextEditingController(text: _cours!.nom);
      // Initialise le contrôleur nomProf avec le nom du professeur actuel
      _nomProfController = TextEditingController(text: _cours!.nomProf);
      // Initialise le contrôleur local avec le local actuel
      _localController = TextEditingController(text: _cours!.local);
      // Initialise la date avec la date actuelle du cours
      _dateCours = _cours!.date;
      // Marque l'initialisation comme terminée
      _initialized = true;
    }
  }

  // Méthode appelée lorsque le widget est supprimé de l'arbre des widgets
  @override
  void dispose() {
    // Libère les ressources du contrôleur nom
    _nomController.dispose();
    // Libère les ressources du contrôleur nomProf
    _nomProfController.dispose();
    // Libère les ressources du contrôleur local
    _localController.dispose();
    // Appelle la méthode dispose de la classe parente
    super.dispose();
  }

  // Méthode asynchrone pour sélectionner une date
  /// Affiche un sélecteur de date personnalisé avec le thème de l'application
  Future<void> _selectionnerDate(BuildContext context) async {
    // Affiche un dialogue de sélection de date
    final DateTime? picked = await showDatePicker(
      // Contexte de l'application
      context: context,
      // Date initiale affichée (date actuelle du cours ou aujourd'hui)
      initialDate: _dateCours ?? DateTime.now(),
      // Date minimale sélectionnable (aujourd'hui)
      firstDate: DateTime.now(),
      // Date maximale sélectionnable (année 2050)
      lastDate: DateTime(2050),
      // Builder pour personnaliser le thème du sélecteur de date
      builder: (context, child) {
        // Retourne un thème personnalisé
        return Theme(
          // Copie le thème actuel avec modifications
          data: Theme.of(context).copyWith(
            // Schéma de couleurs personnalisé
            colorScheme: const ColorScheme.light(
              // Couleur principale (couleur de l'app)
              primary: kMainButtonColor,
              // Couleur du texte sur la couleur principale (blanc)
              onPrimary: kWhiteColor,
              // Couleur du texte sur la surface (noir)
              onSurface: Colors.black,
            ),
          ),
          // Retourne le widget enfant (le sélecteur de date)
          child: child!,
        );
      },
    );
    // Si une date a été sélectionnée et qu'elle est différente de l'actuelle
    if (picked != null && picked != _dateCours) {
      // Met à jour l'état avec la nouvelle date
      setState(() {
        // Assigne la date sélectionnée
        _dateCours = picked;
      });
    }
  }

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Si les contrôleurs ne sont pas encore initialisés ou le cours est null
    if (!_initialized || _cours == null) {
      // Affiche un indicateur de chargement
      return const Scaffold(
        // Corps de l'écran centré
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Retourne un Scaffold qui est la structure de base d'un écran Material Design
    return Scaffold(
      // Corps de l'écran
      body: SizedBox.expand(
        // Widget qui prend toute la taille disponible
        child: DecoratedBox(
          // Décorateur pour appliquer un dégradé de fond
          decoration: const BoxDecoration(gradient: kBackgroundGradient),
          // Zone sécurisée qui évite les zones système (notch, barre de statut)
          child: SafeArea(
            // Zone scrollable pour le contenu
            child: SingleChildScrollView(
              // Colonne pour organiser les éléments verticalement
              child: Column(
                children: [
                  // Bouton retour personnalisé qui revient à l'écran précédent
                  AppBackButton(onTap: () => Navigator.pop(context)),
                  // Espacement vertical après le bouton retour
                  const SizedBox(height: kSpacingAfterBackButton),
                  // Titre de l'écran "Modifier le cours" avec style prédéfini
                  const Text('Modifier le cours', style: kCreerClubTitleText),
                  // Espacement vertical avant le formulaire
                  const SizedBox(height: kSpacingBeforeForm),
                  // Padding horizontal pour le formulaire
                  Padding(
                    // Padding horizontal large pour le formulaire
                    padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                    // Formulaire pour valider les champs
                    child: Form(
                      // Clé globale pour valider le formulaire
                      key: _formKey,
                      // Colonne pour organiser les champs du formulaire
                      child: Column(
                        children: [
                          // Champ texte pour le nom du cours (pré-rempli)
                          FormTextField(
                            // Label du champ nom
                            label: 'Nom du cours',
                            // Contrôleur pour le champ nom
                            controller: _nomController,
                          ),
                          // Espacement vertical entre les champs
                          const SizedBox(height: kSpacingBetweenFields),
                          // Champ texte pour le nom du professeur (pré-rempli)
                          FormTextField(
                            // Label du champ professeur
                            label: 'Professeur',
                            // Contrôleur pour le champ professeur
                            controller: _nomProfController,
                          ),
                          // Espacement vertical entre les champs
                          const SizedBox(height: kSpacingBetweenFields),
                          // Champ texte pour le local (pré-rempli)
                          FormTextField(
                            // Label du champ local
                            label: 'Local',
                            // Contrôleur pour le champ local
                            controller: _localController,
                          ),
                          // Espacement vertical entre les champs
                          const SizedBox(height: kSpacingBetweenFields),
                          // Widget cliquable pour sélectionner la date
                          GestureDetector(
                            // Action à exécuter lors du tap : ouvrir le sélecteur de date
                            onTap: () => _selectionnerDate(context),
                            // Conteneur stylisé pour afficher la date
                            child: Container(
                              // Prend toute la largeur disponible
                              width: double.infinity,
                              // Padding interne du conteneur
                              padding: const EdgeInsets.all(kInputFieldPadding),
                              // Décoration du conteneur
                              decoration: BoxDecoration(
                                // Fond blanc avec opacité légère
                                color: kWhiteColor.withOpacity(0.9),
                                // Coins arrondis
                                borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                              ),
                              // Texte affiché dans le conteneur
                              child: Text(
                                // Si aucune date n'est sélectionnée, affiche un texte par défaut
                                _dateCours == null
                                    ? 'Sélectionner une date'
                                    // Sinon, affiche la date formatée DD/MM/YYYY
                                    : '${_dateCours!.day.toString().padLeft(2, '0')}/${_dateCours!.month.toString().padLeft(2, '0')}/${_dateCours!.year}',
                                // Style du texte
                                style: kInputTextStyle,
                              ),
                            ),
                          ),
                          // Espacement vertical avant le bouton
                          const SizedBox(height: kSpacingBeforeButton),
                          // Bouton de soumission pour enregistrer les modifications
                          SubmitButton(
                            // Texte affiché sur le bouton
                            label: 'Enregistrer les modifications',
                            // Indique si une opération est en cours
                            loading: _loading,
                            // Fonction à exécuter lors du clic
                            onPressed: _modifierCours,
                            // Couleur de fond blanche pour le bouton
                            backgroundColor: kWhiteColor,
                            // Couleur du texte (couleur principale)
                            foregroundColor: kMainButtonColor,
                          ),
                          // Espacement vertical en bas du formulaire
                          const SizedBox(height: kSpacingBottomForm),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Méthode asynchrone pour modifier le cours
  Future<void> _modifierCours() async {
    // Si le cours est null, sort de la méthode
    if (_cours == null) return;

    // Appelle le contrôleur pour modifier le cours avec les nouvelles données
    final success = await CoursController.updateCours(
      // Contexte de l'application
      context: context,
      // Clé du formulaire pour la validation
      formKey: _formKey,
      // ID du cours à modifier
      coursId: _cours!.id,
      // Nouveau nom du cours depuis le contrôleur
      nom: _nomController.text,
      // Nouveau nom du professeur depuis le contrôleur
      nomProf: _nomProfController.text,
      // Nouveau local depuis le contrôleur
      local: _localController.text,
      // Nouvelle date sélectionnée (peut être null)
      date: _dateCours,
      // Callback pour mettre à jour l'état de chargement
      setLoading: (loading) {
        // Met à jour l'état seulement si le widget est encore monté
        if (mounted) setState(() => _loading = loading);
      },
    );
    // Si la modification a réussi et le contexte est encore monté, retourne à l'écran précédent avec true
    if (success && mounted) {
      // Retourne true pour indiquer que la modification a réussi
      Navigator.pop(context, true);
    }
  }
}
