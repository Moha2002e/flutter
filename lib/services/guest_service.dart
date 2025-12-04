/// Service pour gérer l'état du mode invité (Guest Mode)
/// 
/// Ce service permet de déterminer si l'utilisateur utilise l'application
/// en mode invité (sans compte) ou en tant qu'utilisateur authentifié.
class GuestService {
  // Instance singleton
  static final GuestService _instance = GuestService._internal();
  factory GuestService() => _instance;
  GuestService._internal();

  /// Indique si l'utilisateur est en mode invité
  bool _isGuest = false;

  /// Vérifie si l'utilisateur est en mode invité
  bool get isGuest => _isGuest;

  /// Active le mode invité
  void enableGuestMode() {
    _isGuest = true;
  }

  /// Désactive le mode invité (lors de la connexion)
  void disableGuestMode() {
    _isGuest = false;
  }

  /// Réinitialise l'état du service
  void reset() {
    _isGuest = false;
  }
}

