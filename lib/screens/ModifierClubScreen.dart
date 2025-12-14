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
// Import du contrôleur pour gérer les opérations sur les clubs
import '../controllers/club_controller.dart';
// Import du modèle Club pour typer les données
import '../models/club.dart';

/// Écran pour modifier un club existant
/// Permet à un utilisateur authentifié de modifier un club qu'il a créé
class ModifierClubScreen extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const ModifierClubScreen({super.key});
  // Nom de la route pour la navigation
  static const String routeName = '/modifier-club';

  // Crée l'état associé à ce widget
  @override
  State<ModifierClubScreen> createState() => _ModifierClubScreenState();
}

// Classe d'état privée pour gérer l'état du formulaire
class _ModifierClubScreenState extends State<ModifierClubScreen> {
  // Contrôleur pour le champ nom du club (initialisé tardivement)
  late TextEditingController _nomController;
  // Contrôleur pour le champ description du club (initialisé tardivement)
  late TextEditingController _descriptionController;
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();
  // Variable d'état pour indiquer si une opération est en cours
  bool _loading = false;
  // Club à modifier (récupéré depuis les arguments de navigation)
  Club? _club;
  // Indicateur pour savoir si les contrôleurs ont été initialisés
  bool _initialized = false;

  // Méthode appelée quand les dépendances du widget changent
  @override
  void didChangeDependencies() {
    // Appelle la méthode didChangeDependencies de la classe parente
    super.didChangeDependencies();
    // Initialise les contrôleurs une seule fois
    if (!_initialized) {
      // Récupère le club depuis les arguments de navigation
      _club = ModalRoute.of(context)!.settings.arguments as Club;
      // Initialise le contrôleur nom avec le nom actuel du club
      _nomController = TextEditingController(text: _club!.nom);
      // Initialise le contrôleur description avec la description actuelle
      _descriptionController = TextEditingController(text: _club!.description);
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
    // Appelle la méthode dispose de la classe parente
    super.dispose();
  }

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Si les contrôleurs ne sont pas encore initialisés ou le club est null
    if (!_initialized || _club == null) {
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
                  // Titre de l'écran "Modifier le club" avec style prédéfini
                  const Text('Modifier le club', style: kCreerClubTitleText),
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
                          // Champ texte pour le nom du club (pré-rempli)
                          FormTextField(
                            // Label du champ nom
                            label: 'Nom du club',
                            // Contrôleur pour le champ nom
                            controller: _nomController,
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
                            onPressed: _modifierClub,
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

  // Méthode asynchrone pour modifier le club
  Future<void> _modifierClub() async {
    // Si le club est null, sort de la méthode
    if (_club == null) return;
    
    // Appelle le contrôleur pour modifier le club avec les nouvelles données
    final success = await ClubController.updateClub(
      // Contexte de l'application
      context: context,
      // Clé du formulaire pour la validation
      formKey: _formKey,
      // ID du club à modifier
      clubId: _club!.id,
      // Nouveau nom du club depuis le contrôleur
      nom: _nomController.text,
      // Nouvelle description du club depuis le contrôleur
      description: _descriptionController.text,
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

