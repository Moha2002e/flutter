import 'package:flutter/material.dart';
import '../services/firebase_firestore.dart';
import '../services/firebase_auth.dart';
import '../services/notification_service.dart';
import '../models/cours.dart';

/// Contrôleur pour gérer les opérations sur les cours
class CoursController {
  /// Récupère le stream de tous les cours
  /// Récupère le stream de tous les cours
  static Stream<List<Cours>> obtenirTousLesCoursStream() {
    return FirebaseFirestoreService.obtenirTousLesCours();
  }

  /// Récupère un cours par son ID
  static Future<Cours?> obtenirCoursParId(String coursId) async {
    return await FirebaseFirestoreService.obtenirCoursParId(coursId);
  }

  /// Récupère le stream d'un cours par son ID
  static Stream<Cours?> obtenirCoursParIdStream(String coursId) {
    return FirebaseFirestoreService.coursCollection
        .doc(coursId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
        return Cours.fromFirestore(data, data['id']);
      }
      return null;
    });
  }
  /// Crée un nouveau cours
  static Future<bool> createCours({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String nom,
    required DateTime? date,
    required String nomProf,
    required String local,
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
      await FirebaseFirestoreService.creerCours(
        nom: nom,
        date: date,
        nomProf: nomProf,
        local: local,
        createurId: utilisateur.uid,
      );

      // Envoyer une notification pour le nouveau cours
      await NotificationService().notifyNewCours(nom, date);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cours créé avec succès')),
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

  /// Modifie un cours
  static Future<bool> updateCours({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String coursId,
    required String nom,
    required DateTime? date,
    required String nomProf,
    required String local,
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
      await FirebaseFirestoreService.modifierCours(
        coursId: coursId,
        nom: nom,
        date: date,
        nomProf: nomProf,
        local: local,
        createurId: utilisateur.uid,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cours modifié avec succès')),
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

  /// Supprime un cours
  static Future<bool> deleteCours({
    required BuildContext context,
    required String coursId,
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
      await FirebaseFirestoreService.supprimerCours(
        coursId: coursId,
        createurId: utilisateur.uid,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cours supprimé avec succès')),
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

