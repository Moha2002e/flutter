import 'package:flutter/material.dart';
import '../services/firebase_firestore.dart';
import '../services/firebase_auth.dart';
import '../services/notification_service.dart';
import '../models/evenement.dart';

/// Contrôleur pour gérer les opérations sur les événements
class EvenementController {
  /// Récupère le stream de tous les événements
  /// Récupère le stream de tous les événements
  static Stream<List<Evenement>> obtenirTousLesEvenementsStream() {
    return FirebaseFirestoreService.obtenirTousLesEvenements();
  }

  /// Récupère un événement par son ID
  static Future<Evenement?> obtenirEvenementParId(String evenementId) async {
    return await FirebaseFirestoreService.obtenirEvenementParId(evenementId);
  }

  /// Récupère le stream d'un événement par son ID
  static Stream<Evenement?> obtenirEvenementParIdStream(String evenementId) {
    return FirebaseFirestoreService.evenementsCollection
        .doc(evenementId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
        return Evenement.fromFirestore(data, data['id']);
      }
      return null;
    });
  }
  /// Crée un nouvel événement
  static Future<bool> createEvenement({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String nom,
    required String description,
    required DateTime? date,
    required String lieu,
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
      await FirebaseFirestoreService.creerEvenement(
        nom: nom,
        description: description,
        date: date,
        lieu: lieu,
        createurId: utilisateur.uid,
      );

      // Envoyer une notification pour le nouvel événement
      await NotificationService().notifyNewEvent(nom, date);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Événement créé avec succès')),
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

  /// Modifie un événement
  static Future<bool> updateEvenement({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String evenementId,
    required String nom,
    required String description,
    required DateTime? date,
    required String lieu,
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
      await FirebaseFirestoreService.modifierEvenement(
        evenementId: evenementId,
        nom: nom,
        description: description,
        date: date,
        lieu: lieu,
        createurId: utilisateur.uid,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Événement modifié avec succès')),
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

  /// Supprime un événement
  static Future<bool> deleteEvenement({
    required BuildContext context,
    required String evenementId,
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
      await FirebaseFirestoreService.supprimerEvenement(
        evenementId: evenementId,
        createurId: utilisateur.uid,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Événement supprimé avec succès')),
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

