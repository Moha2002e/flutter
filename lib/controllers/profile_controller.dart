import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth.dart';

/// Contrôleur pour gérer les opérations du profil utilisateur
class ProfileController {
  /// Met à jour le mot de passe de l'utilisateur
  static Future<bool> updatePassword({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String currentPassword,
    required String newPassword,
    required VoidCallback onSuccess,
  }) async {
    if (!formKey.currentState!.validate()) return false;

    try {
      final utilisateur = FirebaseAuthService.currentUser;
      if (utilisateur == null || utilisateur.email == null) {
        _showError(context, 'Utilisateur non connecté');
        return false;
      }

      // Réauthentifie l'utilisateur avec le mot de passe actuel
      final identifiants = EmailAuthProvider.credential(
        email: utilisateur.email!,
        password: currentPassword,
      );
      await utilisateur.reauthenticateWithCredential(identifiants);

      // Met à jour le mot de passe
      await utilisateur.updatePassword(newPassword);
      
      onSuccess();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mot de passe mis à jour avec succès')),
        );
      }
      return true;
    } on FirebaseAuthException catch (erreur) {
      if (context.mounted) {
        _showError(context, _getErrorMessage(erreur.code));
      }
      return false;
    } catch (erreur) {
      if (context.mounted) {
        _showError(context, 'Erreur lors de la mise à jour: $erreur');
      }
      return false;
    }
  }

  /// Affiche un message d'erreur
  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Convertit le code d'erreur Firebase en message français
  static String _getErrorMessage(String code) {
    switch (code) {
      case 'wrong-password':
        return 'Mot de passe actuel incorrect.';
      case 'weak-password':
        return 'Le nouveau mot de passe est trop faible.';
      case 'requires-recent-login':
        return 'Veuillez vous reconnecter pour modifier votre mot de passe.';
      default:
        return 'Erreur lors de la mise à jour du mot de passe.';
    }
  }
}

