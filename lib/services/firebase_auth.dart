import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseAuth get instance => _auth;

  /// Connexion avec email et mot de passe
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Inscription avec email et mot de passe
  static Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Déconnexion
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Obtenir l'utilisateur actuel
  static User? get currentUser => _auth.currentUser;

  /// Stream des changements d'état d'authentification
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Envoie un email de réinitialisation de mot de passe
  /// L'utilisateur recevra un email avec un lien pour réinitialiser son mot de passe
  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

