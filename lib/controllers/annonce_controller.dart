import 'package:flutter/material.dart';
import '../services/firebase_firestore.dart';
import '../services/firebase_auth.dart';
import '../services/notification_service.dart';
import '../models/annonce.dart';

/// Contrôleur pour gérer les opérations sur les annonces
class AnnonceController {
  /// Récupère le stream de toutes les annonces
  /// Récupère le stream de toutes les annonces
  static Stream<List<Annonce>> obtenirToutesLesAnnoncesStream() {
    return FirebaseFirestoreService.obtenirToutesLesAnnonces();
  }

  /// Récupère une annonce par son ID
  static Future<Annonce?> obtenirAnnonceParId(String annonceId) async {
    return await FirebaseFirestoreService.obtenirAnnonceParId(annonceId);
  }

  /// Récupère le stream d'une annonce par son ID
  static Stream<Annonce?> obtenirAnnonceParIdStream(String annonceId) {
    return FirebaseFirestoreService.annoncesCollection
        .doc(annonceId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
        return Annonce.fromFirestore(data, data['id']);
      }
      return null;
    });
  }
  /// Crée une nouvelle annonce
  static Future<bool> createAnnonce({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String nom,
    required String description,
    required DateTime? date,
    required String categorie,
    required Function(bool) setLoading,
  }) async {
    if (!formKey.currentState!.validate()) return false;

    final utilisateur = FirebaseAuthService.currentUser;
    if (utilisateur == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez être connecté')),
      );
      return false;
    }

    setLoading(true);

    try {
      await FirebaseFirestoreService.creerAnnonce(
        nom: nom,
        description: description,
        date: date,
        categorie: categorie,
        createurId: utilisateur.uid,
      );

      // Envoyer une notification pour la nouvelle annonce
      await NotificationService().notifyNewAnnonce(nom);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Annonce créée avec succès')),
        );
        return true;
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Modifie une annonce
  static Future<bool> updateAnnonce({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String annonceId,
    required String nom,
    required String description,
    required DateTime? date,
    required String categorie,
    required Function(bool) setLoading,
  }) async {
    if (!formKey.currentState!.validate()) return false;

    final utilisateur = FirebaseAuthService.currentUser;
    if (utilisateur == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez être connecté')),
      );
      return false;
    }

    setLoading(true);

    try {
      await FirebaseFirestoreService.modifierAnnonce(
        annonceId: annonceId,
        nom: nom,
        description: description,
        date: date,
        categorie: categorie,
        createurId: utilisateur.uid,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Annonce modifiée avec succès')),
        );
        return true;
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Supprime une annonce
  static Future<bool> deleteAnnonce({
    required BuildContext context,
    required String annonceId,
    required Function(bool) setLoading,
  }) async {
    final utilisateur = FirebaseAuthService.currentUser;
    if (utilisateur == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez être connecté')),
      );
      return false;
    }

    setLoading(true);

    try {
      await FirebaseFirestoreService.supprimerAnnonce(
        annonceId: annonceId,
        createurId: utilisateur.uid,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Annonce supprimée avec succès')),
        );
        return true;
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
      return false;
    } finally {
      setLoading(false);
    }
  }
}

