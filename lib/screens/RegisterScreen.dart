import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../l10n/app_localizations.dart';
import '../styles/images.dart';
import '../styles/spacings.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/texts.dart';
import '../widgets/main_button.dart';
import '../services/firebase_auth.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart';

/// Écran d'inscription
/// Permet à l'utilisateur de créer un nouveau compte
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Contrôleurs pour les champs de texte
  final TextEditingController controleurEmail = TextEditingController();
  final TextEditingController controleurMotDePasse = TextEditingController();
  final TextEditingController controleurConfirmationMotDePasse = TextEditingController();

  // Clé pour valider le formulaire
  final _cleFormulaire = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: kBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
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
                
                // Logo et texte "Inscription"
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
                        AppLocalizations.of(context)!.registration,
                        style: kLoginTitleText,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: kSpacingBeforeForm),
                
                // Formulaire d'inscription
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
                              validator: (valeur) {
                                if (valeur == null || valeur.isEmpty) {
                                  return 'Veuillez entrer votre mot de passe';
                                }
                                if (valeur.length < kMinPasswordLength) {
                                  return 'Le mot de passe doit contenir au moins $kMinPasswordLength caractères';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: kSpacingBetweenFields),
                        
                        // Champ Confirmer mot de passe
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.confirmPassword,
                              style: kLabelText,
                            ),
                            const SizedBox(height: kSpacingBetweenLabelAndField),
                            TextFormField(
                              controller: controleurConfirmationMotDePasse,
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
                              validator: (valeur) {
                                if (valeur == null || valeur.isEmpty) {
                                  return 'Veuillez confirmer votre mot de passe';
                                }
                                if (valeur != controleurMotDePasse.text) {
                                  return 'Les mots de passe ne correspondent pas';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: kSpacingBeforeButton),
                        
                        // Texte "Tu as déjà un compte ?"
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.alreadyHaveAccount,
                            style: kLabelText,
                          ),
                        ),
                        
                        const SizedBox(height: kSpacingAfterButton),
                        
                        // Bouton S'inscrire
                        SizedBox(
                          width: double.infinity,
                          child: MainButton(
                            onTap: () {
                              _gererInscription(context);
                            },
                            label: AppLocalizations.of(context)!.register,
                            status: 'login',
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
        ),
      ),
    );
  }

  /// Gère le processus d'inscription
  /// Vérifie les champs, puis crée le compte avec Firebase
  Future<void> _gererInscription(BuildContext context) async {
    // Valide le formulaire (vérifie que les champs sont remplis correctement)
    if (_cleFormulaire.currentState!.validate()) {
      try {
        // Récupère les valeurs des champs
        String email = controleurEmail.text;
        String motDePasse = controleurMotDePasse.text;

        // Crée le compte avec Firebase
        await FirebaseAuthService.createUserWithEmailAndPassword(
          email: email,
          password: motDePasse,
        );
        
        debugPrint('✅ Utilisateur créé avec succès');
        
        // Si l'inscription réussit, navigue vers la page d'accueil
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (erreur) {
        // Affiche un message d'erreur si l'inscription échoue
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_obtenirMessageErreur(erreur.code)),
            ),
          );
        }
      } catch (erreur) {
        // Affiche un message d'erreur générique en cas d'erreur inattendue
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $erreur'),
            ),
          );
        }
      }
    }
  }

  /// Convertit le code d'erreur Firebase en message français compréhensible
  String _obtenirMessageErreur(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'Email invalide.';
      case 'operation-not-allowed':
        return 'Opération non autorisée.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      default:
        return 'Une erreur est survenue. Veuillez réessayer.';
    }
  }
}
