// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des localisations pour l'internationalisation (français/anglais)
import '../l10n/app_localizations.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';
// Import des styles de texte prédéfinis
import '../styles/texts.dart';
// Import du widget bouton principal personnalisé
import '../widgets/main_button.dart';
// Import du widget champ de texte d'authentification personnalisé
import '../widgets/auth_text_field.dart';
// Import du widget en-tête d'authentification personnalisé
import '../widgets/auth_header.dart';
// Import du contrôleur pour gérer l'authentification
import '../controllers/auth_controller.dart';
// Import de l'écran d'inscription
import 'RegisterScreen.dart';

/// Écran de connexion
/// Permet à un utilisateur de se connecter avec son email et mot de passe
class LoginScreen extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const LoginScreen({super.key});
  // Nom de la route pour la navigation
  static const String routeName = '/login';

  // Crée l'état associé à ce widget
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Classe d'état privée pour gérer l'état du formulaire
class _LoginScreenState extends State<LoginScreen> {
  // Contrôleur pour le champ email
  final _emailController = TextEditingController();
  // Contrôleur pour le champ mot de passe
  final _passwordController = TextEditingController();
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Méthode appelée lorsque le widget est supprimé de l'arbre des widgets
  @override
  void dispose() {
    // Libère les ressources du contrôleur email
    _emailController.dispose();
    // Libère les ressources du contrôleur mot de passe
    _passwordController.dispose();
    // Appelle la méthode dispose de la classe parente
    super.dispose();
  }

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Récupère les localisations pour afficher les textes dans la langue de l'utilisateur
    final localizations = AppLocalizations.of(context)!;
    
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
                // En-tête d'authentification avec titre et bouton retour
                AuthHeader(
                  // Titre localisé "Connection"
                  title: localizations.connection,
                  // Action du bouton retour : retourne à l'écran précédent
                  onBack: () => Navigator.pop(context),
                ),
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
                        // Champ texte pour l'email avec clavier email
                        AuthTextField(
                          // Label localisé "Email address"
                          label: localizations.mail,
                          // Contrôleur pour le champ email
                          controller: _emailController,
                          // Type de clavier : clavier email avec @
                          keyboardType: TextInputType.emailAddress,
                        ),
                        // Espacement vertical entre les champs
                        const SizedBox(height: kSpacingBetweenFields),
                        // Champ texte pour le mot de passe (masqué)
                        AuthTextField(
                          // Label localisé "Password"
                          label: localizations.password,
                          // Contrôleur pour le champ mot de passe
                          controller: _passwordController,
                          // Masque le texte saisi (affiche des points)
                          obscureText: true,
                        ),
                        // Espacement vertical avant le lien "Mot de passe oublié"
                        const SizedBox(height: kSpacingBeforeForgotPassword),
                        // Lien cliquable pour réinitialiser le mot de passe
                        GestureDetector(
                          // Action à exécuter lors du tap : affiche un dialogue de réinitialisation
                          onTap: () => AuthController.showPasswordResetDialog(context),
                          // Texte localisé "Forgot password?"
                          child: Text(localizations.forgotPassword, style: kLinkText),
                        ),
                        // Espacement vertical avant le bouton
                        const SizedBox(height: kSpacingBeforeButton),
                        // Conteneur pour le bouton de connexion (pleine largeur)
                        SizedBox(
                          // Prend toute la largeur disponible
                          width: double.infinity,
                          // Bouton principal pour se connecter
                          child: MainButton(
                            // Action à exécuter lors du clic : appelle le contrôleur d'authentification
                            onTap: () => AuthController.signIn(
                              // Contexte de l'application
                              context: context,
                              // Clé du formulaire pour la validation
                              formKey: _formKey,
                              // Email saisi par l'utilisateur
                              email: _emailController.text,
                              // Mot de passe saisi par l'utilisateur
                              password: _passwordController.text,
                            ),
                            // Texte localisé "Log in"
                            label: localizations.login,
                            // Statut du bouton : style "login"
                            status: 'login',
                          ),
                        ),
                        // Espacement vertical après le bouton
                        const SizedBox(height: kSpacingAfterButton),
                        // Lien cliquable pour aller vers l'écran d'inscription
                        GestureDetector(
                          // Action à exécuter lors du tap : navigue vers l'écran d'inscription
                          onTap: () => Navigator.pushNamed(context, RegisterScreen.routeName),
                          // Texte localisé "Sign up"
                          child: Text(localizations.register, style: kRegisterLinkText),
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
}
