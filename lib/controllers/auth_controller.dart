import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth.dart';
import '../utils/guest_utils.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/LoginScreen.dart';
import '../styles/spacings.dart';
import '../styles/sizes.dart';

/// Contrôleur pour gérer l'authentification (connexion, inscription, réinitialisation)
class AuthController {
  /// Gère le processus de connexion
  static Future<void> signIn({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) return;

    try {
      await FirebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      disableGuestMode();
      
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainNavigationScreen.routeName,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (erreur) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_getErrorMessage(erreur.code))),
        );
      }
    }
  }

  /// Gère le processus d'inscription
  static Future<void> signUp({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) return;

    try {
      await FirebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      disableGuestMode();
      
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainNavigationScreen.routeName,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (erreur) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_getSignUpErrorMessage(erreur.code))),
        );
      }
    } catch (erreur) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $erreur')),
        );
      }
    }
  }

  /// Affiche un dialogue pour réinitialiser le mot de passe
  static Future<void> showPasswordResetDialog(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (dialogContext) {
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
                controller: emailController,
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => _handlePasswordReset(dialogContext, emailController.text),
              child: const Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }

  /// Traite la réinitialisation du mot de passe
  static Future<void> _handlePasswordReset(BuildContext context, String email) async {
    final trimmedEmail = email.trim();
    
    if (trimmedEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre email')),
      );
      return;
    }
    
    if (!trimmedEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email invalide')),
      );
      return;
    }
    
    try {
      await FirebaseAuthService.sendPasswordResetEmail(trimmedEmail);
      
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
  }

  /// Convertit le code d'erreur Firebase en message français pour la connexion
  static String _getErrorMessage(String code) {
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

  /// Convertit le code d'erreur Firebase en message français pour l'inscription
  static String _getSignUpErrorMessage(String code) {
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

