// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import du contrôleur pour gérer les opérations sur les clubs
import '../controllers/club_controller.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';
// Import des styles de texte prédéfinis
import '../styles/texts.dart';
// Import du service d'authentification Firebase
import '../services/firebase_auth.dart';
// Import des utilitaires pour gérer les informations utilisateur
import '../utils/user_utils.dart';
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';
// Import du contrôleur pour gérer les opérations sur le profil
import '../controllers/profile_controller.dart';
// Import du widget bouton retour personnalisé
import '../widgets/back_button.dart';
// Import du widget avatar de profil personnalisé
import '../widgets/profile_avatar.dart';
// Import du widget carte d'information de profil personnalisé
import '../widgets/profile_info_card.dart';
// Import du widget section de formulaire de mot de passe personnalisé
import '../widgets/password_form_section.dart';
// Import du widget bouton de soumission personnalisé
import '../widgets/submit_button.dart';

/// Écran de profil utilisateur
/// Affiche les informations de l'utilisateur connecté et permet de modifier le mot de passe
class ProfileScreen extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const ProfileScreen({super.key});
  // Nom de la route pour la navigation
  static const String routeName = '/profile';

  // Crée l'état associé à ce widget
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// Classe d'état privée pour gérer l'état de l'écran
class _ProfileScreenState extends State<ProfileScreen> {
  // Clé globale pour valider le formulaire principal (non utilisé actuellement)
  final _formKey = GlobalKey<FormState>();
  // Clé globale pour valider le formulaire de modification de mot de passe
  final _passwordFormKey = GlobalKey<FormState>();
  // Variable d'état pour indiquer si l'utilisateur est en train de modifier le mot de passe
  bool _isEditingPassword = false;
  // Mot de passe actuel saisi par l'utilisateur (non utilisé actuellement)
  String _currentPassword = '';
  // Nouveau mot de passe saisi par l'utilisateur (non utilisé actuellement)
  String _newPassword = '';

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
    
    // Récupère l'utilisateur actuellement connecté
    final user = FirebaseAuthService.currentUser;
    // Récupère le nom d'utilisateur formaté
    final userName = getUserName(user);
    // Récupère l'email de l'utilisateur ou une chaîne vide par défaut
    final userEmail = user?.email ?? '';

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
              // Padding autour du contenu
              child: Padding(
                // Padding uniforme autour du contenu
                padding: EdgeInsets.all(kHomeContentPadding),
                // Colonne pour organiser les éléments verticalement
                child: Column(
                  children: [
                    // Bouton retour personnalisé qui revient à l'écran précédent
                    AppBackButton(onTap: () => Navigator.pop(context)),
                    // Espacement vertical après le bouton retour
                    const SizedBox(height: kSpacingAfterHeader),
                    // Avatar de profil de l'utilisateur
                    const ProfileAvatar(),
                    // Espacement vertical après l'avatar
                    const SizedBox(height: kSpacingAfterGreeting),
                    // Nom d'utilisateur avec style de salutation
                    Text(
                      // Nom d'utilisateur formaté
                      userName,
                      // Style de texte avec taille personnalisée
                      style: kGreetingText.copyWith(fontSize: kGreetingFontSize),
                      // Alignement centré
                      textAlign: TextAlign.center,
                    ),
                    // Espacement vertical après le nom
                    const SizedBox(height: kSmallSpace),
                    // Email de l'utilisateur
                    Text(
                      // Email de l'utilisateur
                      userEmail,
                      // Style de texte avec taille personnalisée pour l'email
                      style: kLabelText.copyWith(fontSize: kProfileEmailFontSize),
                      // Alignement centré
                      textAlign: TextAlign.center,
                    ),
                    // Espacement vertical avant le formulaire
                    const SizedBox(height: kSpacingBeforeForm),
                    // Padding horizontal pour le formulaire de mot de passe
                    Padding(
                      // Padding horizontal large
                      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                      // Affiche soit le formulaire de modification, soit le bouton
                      child: _isEditingPassword
                          // Si en mode édition, affiche le formulaire de modification de mot de passe
                          ? PasswordFormSection(
                              // Clé du formulaire pour la validation
                              formKey: _passwordFormKey,
                              // Fonction à exécuter lors de la sauvegarde
                              onSave: _updatePassword,
                              // Fonction à exécuter lors de l'annulation
                              onCancel: _cancelEdit,
                            )
                          // Sinon, affiche le bouton pour commencer l'édition
                          : _buildEditButton(),
                    ),
                    // Espacement vertical après le formulaire/bouton
                    const SizedBox(height: kSpacingAfterButton),
                    // Padding horizontal pour les cartes d'information
                    Padding(
                      // Padding horizontal large
                      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                      // Colonne pour organiser les cartes d'information
                      child: Column(
                        children: [
                          // Carte d'information pour l'email
                          ProfileInfoCard(
                            // Icône Material Design pour l'email
                            icon: Icons.email_outlined,
                            // Label de la carte
                            label: 'Email',
                            // Valeur affichée (email de l'utilisateur)
                            value: userEmail,
                          ),
                          // Espacement vertical entre les cartes
                          const SizedBox(height: kSpacingBetweenFields),
                          // Carte d'information pour la date de création du compte
                          ProfileInfoCard(
                            // Icône Material Design pour le calendrier
                            icon: Icons.calendar_today_outlined,
                            // Label de la carte
                            label: 'Compte créé le',
                            // Valeur affichée (date formatée de création)
                            value: formatCreationDate(user),
                          ),
                        ],
                      ),
                    ),
                    // Espacement vertical après les cartes d'information
                    const SizedBox(height: kSpacingAfterButton),
                    // Section Badges : affiche un badge si l'utilisateur a rejoint 3+ clubs
                    FutureBuilder<int>(
                      // Future qui compte le nombre de clubs rejoints par l'utilisateur
                      future: user != null ? ClubController.countJoinedClubs(user.uid) : Future.value(0),
                      // Builder qui construit l'UI selon le résultat du future
                      builder: (context, snapshot) {
                        // Récupère le nombre de clubs rejoints ou 0 par défaut
                        final count = snapshot.data ?? 0;
                        // Si moins de 3 clubs, n'affiche rien
                        if (count < 3) return const SizedBox.shrink();

                        // Retourne une colonne avec le badge
                        return Column(
                          children: [
                            // Titre de la section "Badges"
                            Text(
                              'Badges',
                              // Style de texte avec taille personnalisée
                              style: kGreetingText.copyWith(fontSize: 20),
                            ),
                            // Espacement vertical après le titre
                            const SizedBox(height: kSmallSpace),
                            // Conteneur pour le badge "Membre Actif"
                            Container(
                              // Padding interne du conteneur
                              padding: const EdgeInsets.all(kInputFieldPadding),
                              // Décoration du conteneur
                              decoration: BoxDecoration(
                                // Fond blanc avec opacité
                                color: kWhiteColor.withValues(alpha: kProfileInfoBackgroundOpacity),
                                // Coins arrondis
                                borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                // Bordure dorée de 2 pixels
                                border: Border.all(color: Colors.amber, width: 2),
                              ),
                              // Ligne horizontale pour l'icône et le texte
                              child: Row(
                                // Taille minimale de la ligne
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icône étoile dorée
                                  const Icon(Icons.stars, color: Colors.amber, size: 30),
                                  // Espacement horizontal entre l'icône et le texte
                                  const SizedBox(width: kSmallSpace),
                                  // Texte du badge
                                  Text(
                                    'Membre Actif',
                                    // Style de texte avec couleur dorée et gras
                                    style: kLabelText.copyWith(
                                      // Couleur dorée foncée
                                      color: Colors.amber[800],
                                      // Texte en gras
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Espacement vertical après le badge
                            const SizedBox(height: kSpacingBetweenFields),
                          ],
                        );
                      },
                    ),
                    // Espacement vertical en bas de l'écran
                    const SizedBox(height: kSpacingBottomForm),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Construit le bouton pour commencer l'édition du mot de passe
  Widget _buildEditButton() {
    // Retourne un bouton de soumission
    return SubmitButton(
      // Texte affiché sur le bouton
      label: 'Modifier le mot de passe',
      // Indique qu'aucune opération n'est en cours
      loading: false,
      // Action à exécuter : active le mode édition
      onPressed: () => setState(() => _isEditingPassword = true),
      // Couleur de fond blanche pour le bouton
      backgroundColor: kWhiteColor,
      // Couleur du texte (couleur principale)
      foregroundColor: kMainButtonColor,
    );
  }

  // Annule l'édition du mot de passe
  void _cancelEdit() {
    // Désactive le mode édition
    setState(() => _isEditingPassword = false);
  }

  // Met à jour le mot de passe de l'utilisateur
  void _updatePassword() {
    // Récupère l'état du formulaire
    final formState = _passwordFormKey.currentState;
    // Si le formulaire n'existe pas ou n'est pas valide, sort de la méthode
    if (formState == null || !formState.validate()) return;

    // Appelle le contrôleur pour mettre à jour le mot de passe
    ProfileController.updatePassword(
      // Contexte de l'application
      context: context,
      // Clé du formulaire pour la validation
      formKey: _passwordFormKey,
      // Mot de passe actuel (non utilisé actuellement)
      currentPassword: _currentPassword,
      // Nouveau mot de passe (non utilisé actuellement)
      newPassword: _newPassword,
      // Fonction à exécuter en cas de succès : annule l'édition
      onSuccess: _cancelEdit,
    );
  }
}
