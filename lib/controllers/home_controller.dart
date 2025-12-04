import 'package:flutter/material.dart';
import '../services/firebase_auth.dart';
import '../services/firebase_firestore.dart';
import '../utils/guest_utils.dart';
import '../screens/WelcomeScreen.dart';
import '../screens/LoginScreen.dart';

/// Contrôleur pour gérer les actions de l'écran d'accueil
class HomeController {
  /// Gère la déconnexion de l'utilisateur
  static Future<void> signOut(BuildContext context) async {
    if (isGuest()) {
      resetGuestMode();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          WelcomeScreen.routeName,
          (route) => false,
        );
      }
    } else {
      await FirebaseAuthService.signOut();
      resetGuestMode();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.routeName,
          (route) => false,
        );
      }
    }
  }

  /// Récupère le stream du nombre de cours
  static Stream<int> obtenirNombreCoursStream() {
    return FirebaseFirestoreService.obtenirNombreCours();
  }

  /// Récupère le stream du nombre d'annonces
  static Stream<int> obtenirNombreAnnoncesStream() {
    return FirebaseFirestoreService.obtenirNombreAnnonces();
  }

  /// Récupère le stream du nombre d'événements
  static Stream<int> obtenirNombreEvenementsStream() {
    return FirebaseFirestoreService.obtenirNombreEvenements();
  }

  /// Récupère le stream du nombre de clubs
  static Stream<int> obtenirNombreClubsStream() {
    return FirebaseFirestoreService.obtenirNombreClubs();
  }
}

