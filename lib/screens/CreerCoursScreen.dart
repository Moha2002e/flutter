// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';
// Import des styles de texte prédéfinis
import '../styles/texts.dart';
// Import du widget bouton retour personnalisé
import '../widgets/back_button.dart';
// Import du widget champ de date personnalisé
import '../widgets/date_field.dart';
// Import du widget menu déroulant personnalisé
import '../widgets/dropdown_field.dart';
// Import du widget bouton de soumission personnalisé
import '../widgets/submit_button.dart';
// Import du contrôleur pour gérer les opérations sur les cours
import '../controllers/cours_controller.dart';
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';

/// Écran pour créer un nouveau cours
/// Permet à un utilisateur authentifié de créer un nouveau cours avec nom, date, professeur et local
class CreerCoursScreen extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const CreerCoursScreen({super.key});
  // Nom de la route pour la navigation
  static const String routeName = '/creer-cours';

  // Crée l'état associé à ce widget
  @override
  State<CreerCoursScreen> createState() => _CreerCoursScreenState();
}

// Classe d'état privée pour gérer l'état du formulaire
class _CreerCoursScreenState extends State<CreerCoursScreen> {
  // Contrôleur pour le champ date du cours
  final _dateController = TextEditingController();
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();
  // Variable d'état pour indiquer si une opération est en cours
  bool _loading = false;
  // Date sélectionnée par l'utilisateur (optionnelle)
  DateTime? _selectedDate;
  // Cours sélectionné par l'utilisateur depuis le menu déroulant (optionnel)
  String? _selectedCourse;
  // Professeur sélectionné par l'utilisateur depuis le menu déroulant (optionnel)
  String? _selectedProf;
  // Local sélectionné par l'utilisateur depuis le menu déroulant (optionnel)
  String? _selectedLocal;

  // Liste des cours disponibles pour sélection
  final List<String> _courses = [
    'Mathématiques', 'Physique', 'Chimie', 'Informatique',
    'Anglais', 'Français', 'Histoire', 'Géographie',
  ];

  // Liste des professeurs disponibles pour sélection
  final List<String> _profs = [
    'M. Dupont', 'Mme Martin', 'M. Bernard',
    'Mme Dubois', 'M. Leroy', 'Mme Moreau',
  ];

  // Liste des locaux disponibles pour sélection
  final List<String> _locals = [
    'Salle 101', 'Salle 102', 'Salle 201', 'Salle 202',
    'Amphithéâtre A', 'Amphithéâtre B', 'Laboratoire 1', 'Laboratoire 2',
  ];

  // Méthode appelée lorsque le widget est supprimé de l'arbre des widgets
  @override
  void dispose() {
    // Libère les ressources du contrôleur date
    _dateController.dispose();
    // Appelle la méthode dispose de la classe parente
    super.dispose();
  }

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Vérifie si l'utilisateur est en mode invité et bloque l'accès si nécessaire
    if (blockGuestAccess(context)) {
      // Retourne un écran vide avec le fond dégradé si l'accès est bloqué
      return Scaffold(
        // Corps de l'écran
        body: SizedBox.expand(
          // Widget qui prend toute la taille disponible
          child: DecoratedBox(
            // Décorateur pour appliquer un dégradé de fond
            decoration: const BoxDecoration(gradient: kBackgroundGradient),
          ),
        ),
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
                // Titre de l'écran "Ajouter cours" avec style prédéfini
                const Text('Ajouter cours', style: kCreerCoursTitleText),
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
                        // Menu déroulant pour sélectionner le nom du cours
                        DropdownField(
                          // Label du menu déroulant
                          label: 'Nom du cours',
                          // Liste des cours disponibles
                          items: _courses,
                          // Cours actuellement sélectionné
                          value: _selectedCourse,
                          // Callback appelé quand un cours est sélectionné
                          onChanged: (value) => setState(() => _selectedCourse = value),
                        ),
                        // Espacement vertical entre les champs
                        const SizedBox(height: kSpacingBetweenFields),
                        // Champ date pour sélectionner la date du cours
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
                        // Menu déroulant pour sélectionner le professeur
                        DropdownField(
                          // Label du menu déroulant
                          label: 'Nom du prof',
                          // Liste des professeurs disponibles
                          items: _profs,
                          // Professeur actuellement sélectionné
                          value: _selectedProf,
                          // Callback appelé quand un professeur est sélectionné
                          onChanged: (value) => setState(() => _selectedProf = value),
                        ),
                        // Espacement vertical entre les champs
                        const SizedBox(height: kSpacingBetweenFields),
                        // Menu déroulant pour sélectionner le local
                        DropdownField(
                          // Label du menu déroulant
                          label: 'Local',
                          // Liste des locaux disponibles
                          items: _locals,
                          // Local actuellement sélectionné
                          value: _selectedLocal,
                          // Callback appelé quand un local est sélectionné
                          onChanged: (value) => setState(() => _selectedLocal = value),
                        ),
                        // Espacement vertical avant le bouton
                        const SizedBox(height: kSpacingBeforeButton),
                        // Bouton de soumission pour créer le cours
                        SubmitButton(
                          // Texte affiché sur le bouton
                          label: 'Ajouter',
                          // Indique si une opération est en cours
                          loading: _loading,
                          // Fonction à exécuter lors du clic
                          onPressed: _creerCours,
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
    ),);
  }

  // Méthode asynchrone pour créer un nouveau cours
  Future<void> _creerCours() async {
    // Appelle le contrôleur pour créer le cours avec les données du formulaire
    final success = await CoursController.createCours(
      // Contexte de l'application
      context: context,
      // Clé du formulaire pour la validation
      formKey: _formKey,
      // Nom du cours sélectionné ou chaîne vide par défaut
      nom: _selectedCourse ?? '',
      // Date sélectionnée (peut être null)
      date: _selectedDate,
      // Nom du professeur sélectionné ou chaîne vide par défaut
      nomProf: _selectedProf ?? '',
      // Local sélectionné ou chaîne vide par défaut
      local: _selectedLocal ?? '',
      // Callback pour mettre à jour l'état de chargement
      setLoading: (loading) {
        // Met à jour l'état seulement si le widget est encore monté
        if (mounted) setState(() => _loading = loading);
      },
    );
    // Si la création a réussi et le contexte est encore monté, retourne à l'écran précédent
    if (success && context.mounted) Navigator.pop(context);
  }
}


