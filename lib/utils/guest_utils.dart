import 'package:flutter/material.dart';
import '../services/guest_service.dart';

/// Message standard affiché aux invités lorsqu'ils tentent d'accéder à une fonctionnalité réservée
const String kGuestMessage = 'Fonctionnalité réservée aux membres — créez un compte pour continuer.';

/// Durée d'affichage du message pour les invités
const Duration kGuestMessageDuration = Duration(seconds: 3);

/// Vérifie si l'utilisateur est en mode invité
bool isGuest() => GuestService().isGuest;

/// Affiche un message informatif si l'utilisateur est invité
void showGuestMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(kGuestMessage),
      duration: kGuestMessageDuration,
    ),
  );
}

/// Bloque l'accès à un écran si l'utilisateur est invité
/// Retourne true si l'accès doit être bloqué
bool blockGuestAccess(BuildContext context) {
  if (isGuest()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showGuestMessage(context);
      Navigator.pop(context);
    });
    return true;
  }
  return false;
}

/// Gère l'action d'un bouton en vérifiant si l'utilisateur est invité
/// Si invité, affiche un message et ne fait rien
/// Sinon, exécute la fonction fournie
void handleGuestAction(BuildContext context, VoidCallback action) {
  if (isGuest()) {
    showGuestMessage(context);
  } else {
    action();
  }
}

/// Retourne l'opacité et la couleur pour un bouton désactivé si invité
Map<String, dynamic> getGuestButtonStyle() {
  final guest = isGuest();
  return {
    'opacity': guest ? 0.5 : 1.0,
    'color': guest ? Colors.grey : Colors.black,
  };
}

/// Réinitialise le mode invité
void resetGuestMode() {
  GuestService().reset();
}

/// Désactive le mode invité (lors de la connexion/inscription)
void disableGuestMode() {
  GuestService().disableGuestMode();
}

/// Active le mode invité
void enableGuestMode() {
  GuestService().enableGuestMode();
}

