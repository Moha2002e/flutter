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
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';

/// Écran pour créer un nouveau club
/// Permet à un utilisateur authentifié de créer un nouveau club avec nom et description
class CreerClubScreen extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const CreerClubScreen({super.key});
  // Nom de la route pour la navigation
  static const String routeName = '/creer-club';

  // Crée l'état associé à ce widget
  @override
  State<CreerClubScreen> createState() => _CreerClubScreenState();
}

// Classe d'état privée pour gérer l'état du formulaire
class _CreerClubScreenState extends State<CreerClubScreen> {
  // Contrôleur pour le champ nom du club
  final _nomController = TextEditingController();
  // Contrôleur pour le champ description du club
  final _descriptionController = TextEditingController();
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();
  // Variable d'état pour indiquer si une opération est en cours
  bool _loading = false;

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
                // Titre de l'écran "Créer un club" avec style prédéfini
                const Text('Créer un club', style: kCreerClubTitleText),
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
                        // Champ texte pour le nom du club
                        FormTextField(
                          // Label du champ nom
                          label: 'Nom du club',
                          // Contrôleur pour le champ nom
                          controller: _nomController,
                        ),
                        // Espacement vertical entre les champs
                        const SizedBox(height: kSpacingBetweenFields),
                        // Champ texte multiligne pour la description
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
                        // Bouton de soumission pour créer le club
                        SubmitButton(
                          // Texte affiché sur le bouton
                          label: 'Créer le club',
                          // Indique si une opération est en cours
                          loading: _loading,
                          // Fonction à exécuter lors du clic
                          onPressed: _creerClub,
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
    ),);
  }

  // Méthode asynchrone pour créer un nouveau club
  Future<void> _creerClub() async {
    // Appelle le contrôleur pour créer le club avec les données du formulaire
    final success = await ClubController.createClub(
      // Contexte de l'application
      context: context,
      // Clé du formulaire pour la validation
      formKey: _formKey,
      // Nom du club depuis le contrôleur
      nom: _nomController.text,
      // Description du club depuis le contrôleur
      description: _descriptionController.text,
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
