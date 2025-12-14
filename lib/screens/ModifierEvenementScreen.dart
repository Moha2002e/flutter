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
// Import du contrôleur pour gérer les opérations sur les événements
import '../controllers/evenement_controller.dart';
// Import du modèle Evenement pour typer les données
import '../models/evenement.dart';

/// Écran pour modifier un événement existant
/// Permet à un utilisateur authentifié de modifier un événement qu'il a créé
class ModifierEvenementScreen extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const ModifierEvenementScreen({super.key});
  // Nom de la route pour la navigation
  static const String routeName = '/modifier-evenement';

  // Crée l'état associé à ce widget
  @override
  State<ModifierEvenementScreen> createState() => _ModifierEvenementScreenState();
}

// Classe d'état privée pour gérer l'état du formulaire
class _ModifierEvenementScreenState extends State<ModifierEvenementScreen> {
  // Contrôleur pour le champ nom de l'événement (initialisé tardivement)
  late TextEditingController _nomController;
  // Contrôleur pour le champ description de l'événement (initialisé tardivement)
  late TextEditingController _descriptionController;
  // Contrôleur pour le champ lieu de l'événement (initialisé tardivement)
  late TextEditingController _lieuController;
  // Date de l'événement (optionnelle)
  DateTime? _dateEvenement;
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();
  // Variable d'état pour indiquer si une opération est en cours
  bool _loading = false;
  // Événement à modifier (récupéré depuis les arguments de navigation)
  Evenement? _evenement;
  // Indicateur pour savoir si les contrôleurs ont été initialisés
  bool _initialized = false;

  // Méthode appelée quand les dépendances du widget changent
  @override
  void didChangeDependencies() {
    // Appelle la méthode didChangeDependencies de la classe parente
    super.didChangeDependencies();
    // Initialise les contrôleurs une seule fois
    if (!_initialized) {
      // Récupère l'événement depuis les arguments de navigation
      _evenement = ModalRoute.of(context)!.settings.arguments as Evenement;
      // Initialise le contrôleur nom avec le nom actuel de l'événement
      _nomController = TextEditingController(text: _evenement!.nom);
      // Initialise le contrôleur description avec la description actuelle
      _descriptionController = TextEditingController(text: _evenement!.description);
      // Initialise le contrôleur lieu avec le lieu actuel
      _lieuController = TextEditingController(text: _evenement!.lieu);
      // Initialise la date avec la date actuelle de l'événement
      _dateEvenement = _evenement!.date;
      // Marque l'initialisation comme terminée
      _initialized = true;
    }
  }

  // Méthode appelée lorsque le widget est supprimé de l'arbre des widgets
  @override
  void dispose() {
    // Libère les ressources du contrôleur nom
    _nomController.dispose();
    // Libère les ressources du contrôleur description
    _descriptionController.dispose();
    // Libère les ressources du contrôleur lieu
    _lieuController.dispose();
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
      // Date initiale affichée (date actuelle de l'événement ou aujourd'hui)
      initialDate: _dateEvenement ?? DateTime.now(),
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
    if (picked != null && picked != _dateEvenement) {
      // Met à jour l'état avec la nouvelle date
      setState(() {
        // Assigne la date sélectionnée
        _dateEvenement = picked;
      });
    }
  }

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Si les contrôleurs ne sont pas encore initialisés ou l'événement est null
    if (!_initialized || _evenement == null) {
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
                  // Titre de l'écran "Modifier l'événement" avec style prédéfini
                  const Text('Modifier l\'événement', style: kCreerClubTitleText),
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
                          // Champ texte pour le nom de l'événement (pré-rempli)
                          FormTextField(
                            // Label du champ nom
                            label: 'Nom de l\'événement',
                            // Contrôleur pour le champ nom
                            controller: _nomController,
                          ),
                          // Espacement vertical entre les champs
                          const SizedBox(height: kSpacingBetweenFields),
                          // Champ texte pour le lieu de l'événement (pré-rempli)
                          FormTextField(
                            // Label du champ lieu
                            label: 'Lieu',
                            // Contrôleur pour le champ lieu
                            controller: _lieuController,
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
                                _dateEvenement == null
                                    ? 'Sélectionner une date'
                                    // Sinon, affiche la date formatée DD/MM/YYYY
                                    : '${_dateEvenement!.day.toString().padLeft(2, '0')}/${_dateEvenement!.month.toString().padLeft(2, '0')}/${_dateEvenement!.year}',
                                // Style du texte
                                style: kInputTextStyle,
                              ),
                            ),
                          ),
                          // Espacement vertical entre les champs
                          const SizedBox(height: kSpacingBetweenFields),
                          // Champ texte multiligne pour la description (pré-rempli)
                          FormTextField(
                            // Label du champ description
                            label: 'Description',
                            // Contrôleur pour le champ description
                            controller: _descriptionController,
                            // Nombre maximum de lignes pour la description
                            maxLines: kCreerClubDescriptionMaxLines,
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
                            onPressed: _modifierEvenement,
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

  // Méthode asynchrone pour modifier l'événement
  Future<void> _modifierEvenement() async {
    // Si l'événement est null, sort de la méthode
    if (_evenement == null) return;

    // Appelle le contrôleur pour modifier l'événement avec les nouvelles données
    final success = await EvenementController.updateEvenement(
      // Contexte de l'application
      context: context,
      // Clé du formulaire pour la validation
      formKey: _formKey,
      // ID de l'événement à modifier
      evenementId: _evenement!.id,
      // Nouveau nom de l'événement depuis le contrôleur
      nom: _nomController.text,
      // Nouvelle description de l'événement depuis le contrôleur
      description: _descriptionController.text,
      // Nouveau lieu de l'événement depuis le contrôleur
      lieu: _lieuController.text,
      // Nouvelle date sélectionnée (peut être null)
      date: _dateEvenement,
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
