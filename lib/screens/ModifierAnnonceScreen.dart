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
// Import du widget champ de date personnalisé
import '../widgets/date_field.dart';
// Import du widget menu déroulant personnalisé
import '../widgets/dropdown_field.dart';
// Import du widget bouton de soumission personnalisé
import '../widgets/submit_button.dart';
// Import du contrôleur pour gérer les opérations sur les annonces
import '../controllers/annonce_controller.dart';
// Import du modèle Annonce pour typer les données
import '../models/annonce.dart';
// Import des utilitaires pour formater les dates
import '../utils/date_utils.dart';

/// Écran pour modifier une annonce existante
/// Permet à un utilisateur authentifié de modifier une annonce qu'il a créée
class ModifierAnnonceScreen extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const ModifierAnnonceScreen({super.key});
  // Nom de la route pour la navigation
  static const String routeName = '/modifier-annonce';

  // Crée l'état associé à ce widget
  @override
  State<ModifierAnnonceScreen> createState() => _ModifierAnnonceScreenState();
}

// Classe d'état privée pour gérer l'état du formulaire
class _ModifierAnnonceScreenState extends State<ModifierAnnonceScreen> {
  // Contrôleur pour le champ nom de l'annonce (initialisé tardivement)
  late TextEditingController _nomController;
  // Contrôleur pour le champ description de l'annonce (initialisé tardivement)
  late TextEditingController _descriptionController;
  // Contrôleur pour le champ date de l'annonce (initialisé tardivement)
  late TextEditingController _dateController;
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();
  // Variable d'état pour indiquer si une opération est en cours
  bool _loading = false;
  // Annonce à modifier (récupérée depuis les arguments de navigation)
  Annonce? _annonce;
  // Date sélectionnée par l'utilisateur (optionnelle)
  DateTime? _selectedDate;
  // Catégorie sélectionnée par l'utilisateur (optionnelle)
  String? _selectedCategory;
  // Indicateur pour savoir si les contrôleurs ont été initialisés
  bool _initialized = false;

  // Liste des catégories disponibles pour les annonces
  final List<String> _categories = ['Vente', 'Location', 'Emploi', 'Services', 'Autre'];

  // Méthode appelée quand les dépendances du widget changent
  @override
  void didChangeDependencies() {
    // Appelle la méthode didChangeDependencies de la classe parente
    super.didChangeDependencies();
    // Initialise les contrôleurs une seule fois
    if (!_initialized) {
      // Récupère l'annonce depuis les arguments de navigation
      _annonce = ModalRoute.of(context)!.settings.arguments as Annonce;
      // Initialise le contrôleur nom avec le nom actuel de l'annonce
      _nomController = TextEditingController(text: _annonce!.nom);
      // Initialise le contrôleur description avec la description actuelle
      _descriptionController = TextEditingController(text: _annonce!.description);
      // Initialise le contrôleur date avec la date formatée ou une chaîne vide
      _dateController = TextEditingController(
        // Formate la date si elle existe, sinon chaîne vide
        text: _annonce!.date != null ? AppDateUtils.formatDate(_annonce!.date!) : '',
      );
      // Initialise la date sélectionnée avec la date actuelle de l'annonce
      _selectedDate = _annonce!.date;
      // Initialise la catégorie sélectionnée avec la catégorie actuelle
      _selectedCategory = _annonce!.categorie;
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
    // Libère les ressources du contrôleur date
    _dateController.dispose();
    // Appelle la méthode dispose de la classe parente
    super.dispose();
  }

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Si les contrôleurs ne sont pas encore initialisés ou l'annonce est null
    if (!_initialized || _annonce == null) {
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
                  // Titre de l'écran "Modifier l'annonce" avec style prédéfini
                  const Text('Modifier l\'annonce', style: kCreerAnnonceTitleText),
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
                          // Champ texte pour le nom de l'annonce (pré-rempli)
                          FormTextField(
                            // Label du champ nom
                            label: 'Nom de l\'annonce',
                            // Contrôleur pour le champ nom
                            controller: _nomController,
                          ),
                          // Espacement vertical entre les champs
                          const SizedBox(height: kSpacingBetweenFields),
                          // Champ date pour sélectionner la date de l'annonce (pré-rempli)
                          DateField(
                            // Label du champ date
                            label: 'Date',
                            // Contrôleur pour le champ date
                            controller: _dateController,
                            // Callback appelé quand une date est sélectionnée
                            onDateSelected: (date) => setState(() => _selectedDate = date),
                          ),
                          // Espacement vertical entre les champs
                          const SizedBox(height: kSpacingBetweenFields),
                          // Menu déroulant pour sélectionner la catégorie (pré-sélectionné)
                          DropdownField(
                            // Label du menu déroulant
                            label: 'Catégorie',
                            // Liste des catégories disponibles
                            items: _categories,
                            // Catégorie actuellement sélectionnée
                            value: _selectedCategory,
                            // Callback appelé quand une catégorie est sélectionnée
                            onChanged: (value) => setState(() => _selectedCategory = value),
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
                            maxLines: kCreerAnnonceDescriptionMaxLines,
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
                            onPressed: _modifierAnnonce,
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

  // Méthode asynchrone pour modifier l'annonce
  Future<void> _modifierAnnonce() async {
    // Si l'annonce est null, sort de la méthode
    if (_annonce == null) return;
    
    // Appelle le contrôleur pour modifier l'annonce avec les nouvelles données
    final success = await AnnonceController.updateAnnonce(
      // Contexte de l'application
      context: context,
      // Clé du formulaire pour la validation
      formKey: _formKey,
      // ID de l'annonce à modifier
      annonceId: _annonce!.id,
      // Nouveau nom de l'annonce depuis le contrôleur
      nom: _nomController.text,
      // Nouvelle description de l'annonce depuis le contrôleur
      description: _descriptionController.text,
      // Nouvelle date sélectionnée (peut être null)
      date: _selectedDate,
      // Nouvelle catégorie sélectionnée ou chaîne vide par défaut
      categorie: _selectedCategory ?? '',
      // Callback pour mettre à jour l'état de chargement
      setLoading: (loading) {
        // Met à jour l'état seulement si le widget est encore monté
        if (mounted) setState(() => _loading = loading);
      },
    );
    // Si la modification a réussi et le contexte est encore monté, retourne à l'écran précédent avec true
    if (success && context.mounted) {
      // Retourne true pour indiquer que la modification a réussi
      Navigator.pop(context, true);
    }
  }
}

