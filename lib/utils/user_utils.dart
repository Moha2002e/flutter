import 'package:firebase_auth/firebase_auth.dart';

/// Obtient le nom d'affichage de l'utilisateur
/// 
/// Retourne le displayName s'il existe, sinon extrait le prénom de l'email,
/// ou 'Utilisateur' par défaut
String getUserName(User? utilisateur) {
  if (utilisateur == null) return 'Utilisateur';
  
  // Utiliser le displayName s'il existe
  if (utilisateur.displayName != null && utilisateur.displayName!.isNotEmpty) {
    return utilisateur.displayName!.split(' ')[0];
  }
  
  // Sinon extraire le prénom de l'email (partie avant @)
  String email = '';
  if (utilisateur.email != null) {
    email = utilisateur.email!;
  } else {
    email = '';
  }
  if (email.isNotEmpty) {
    String partieNom = email.split('@')[0];
    // Capitaliser la première lettre
    if (partieNom.isNotEmpty) {
      return partieNom[0].toUpperCase() + partieNom.substring(1);
    }
  }
  
  return 'Utilisateur';
}

/// Formate la date de création du compte
/// 
/// Retourne une chaîne formatée "jour/mois/année" ou "Non disponible"
String formatCreationDate(User? utilisateur) {
  if (utilisateur != null) {
    if (utilisateur.metadata.creationTime != null) {
      final date = utilisateur.metadata.creationTime!;
      return '${date.day}/${date.month}/${date.year}';
    } else {
      return 'Non disponible';
    }
  } else {
    return 'Non disponible';
  }
}
