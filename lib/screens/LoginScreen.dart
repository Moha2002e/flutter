import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/app_localizations.dart';
import '../styles/images.dart';
import '../styles/spacings.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/texts.dart';
import '../widgets/main_button.dart';
import '../services/firebase_auth.dart';
import 'RegisterScreen.dart';
import 'HomeScreen.dart';

/// Écran de connexion
/// Permet à l'utilisateur de se connecter avec son email et mot de passe
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Contrôleurs pour les champs de texte
  final TextEditingController controleurEmail = TextEditingController();
  final TextEditingController controleurMotDePasse = TextEditingController();

  // Clé pour valider le formulaire
  final _cleFormulaire = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: kBackgroundGradient,
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, contraintes) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: contraintes.maxHeight,
                    ),
                    child: Column(
                      children: [
                        // Bouton retour en haut à gauche
                        Padding(
                          padding: const EdgeInsets.all(kHorizontalPadding),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: kBackButtonSize,
                                height: kBackButtonSize,
                                decoration: const BoxDecoration(
                                  color: kWhiteColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: kSpacingAfterBackButton),
                        
                        // Logo et texte "Connection"
                        Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: MediaQuery.of(context).size.width * kWelcomeRatioForm,
                              ),
                              const SizedBox(height: kSpacingAfterLogo),
                              Text(
                                AppLocalizations.of(context)!.connection,
                                style: kLoginTitleText,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: kSpacingBeforeForm),
                        
                        // Formulaire de connexion
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                          child: Form(
                            key: _cleFormulaire,
                            child: Column(
                              children: [
                                // Champ E-mail
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.mail,
                                      style: kLabelText,
                                    ),
                                    const SizedBox(height: kSpacingBetweenLabelAndField),
                                    TextFormField(
                                      controller: controleurEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      style: kInputText,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: kWhiteColor,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: kInputFieldPadding,
                                          vertical: kInputFieldPadding,
                                        ),
                                      ),
                                      validator: (valeur) {
                                        if (valeur == null || valeur.isEmpty) {
                                          return 'Veuillez entrer votre email';
                                        }
                                        if (!valeur.contains('@')) {
                                          return 'Email invalide';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: kSpacingBetweenFields),
                                
                                // Champ Mot de passe
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.password,
                                      style: kLabelText,
                                    ),
                                    const SizedBox(height: kSpacingBetweenLabelAndField),
                                    TextFormField(
                                      controller: controleurMotDePasse,
                                      obscureText: true,
                                      style: kInputText,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: kWhiteColor,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: kInputFieldPadding,
                                          vertical: kInputFieldPadding,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: kSpacingBeforeForgotPassword),
                                
                                // Lien "Mot de passe oublié"
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      _afficherDialogueMotDePasseOublie();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.forgotPassword,
                                      style: kLinkText,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: kSpacingBeforeButton),
                                
                                // Bouton Connexion
                                SizedBox(
                                  width: double.infinity,
                                  child: MainButton(
                                    onTap: () {
                                      _gererConnexion(context);
                                    },
                                    label: AppLocalizations.of(context)!.login,
                                    status: 'login',
                                  ),
                                ),
                                
                                const SizedBox(height: kSpacingAfterButton),
                                
                                // Lien "S'inscrire"
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, RegisterScreen.routeName);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.register,
                                    style: kRegisterLinkText,
                                  ),
                                ),
                                
                                const SizedBox(height: kSpacingBottomForm),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Gère le processus de connexion
  /// Vérifie les champs, puis se connecte avec Firebase
  Future<void> _gererConnexion(BuildContext context) async {
    // Valide le formulaire (vérifie que les champs sont remplis correctement)
    if (_cleFormulaire.currentState!.validate()) {
      try {
        // Récupère les valeurs des champs
        String email = controleurEmail.text;
        String motDePasse = controleurMotDePasse.text;

        // Se connecte avec Firebase
        await FirebaseAuthService.signInWithEmailAndPassword(
          email: email,
          password: motDePasse,
        );
        
        // Si la connexion réussit, navigue vers la page d'accueil
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (erreur) {
        // Affiche un message d'erreur si la connexion échoue
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_obtenirMessageErreur(erreur.code)),
            ),
          );
        }
      }
    }
  }

  /// Convertit le code d'erreur Firebase en message français compréhensible
  String _obtenirMessageErreur(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';
      case 'invalid-email':
        return 'Email invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      default:
        return 'Email ou mot de passe incorrect.';
    }
  }

  /// Affiche un dialogue simple pour réinitialiser le mot de passe
  /// L'utilisateur entre son email et reçoit un lien de réinitialisation
  Future<void> _afficherDialogueMotDePasseOublie() async {
    final TextEditingController controleurEmailReset = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mot de passe oublié'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Entrez votre email pour recevoir un lien de réinitialisation',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: kSpacingBetweenFields),
              TextFormField(
                controller: controleurEmailReset,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: kInputFieldPadding,
                    vertical: kInputFieldPadding,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final email = controleurEmailReset.text.trim();
                
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez entrer votre email')),
                  );
                  return;
                }
                
                if (!email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email invalide')),
                  );
                  return;
                }
                
                try {
                  await FirebaseAuthService.sendPasswordResetEmail(email);
                  
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email de réinitialisation envoyé ! Vérifiez votre boîte mail.'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                }
              },
              child: const Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }
}
