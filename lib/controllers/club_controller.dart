import 'package:flutter/material.dart';
import '../services/firebase_firestore.dart';
import '../services/firebase_auth.dart';
import '../services/notification_service.dart';
import '../models/club.dart';

/// Contrôleur pour gérer les opérations sur les clubs
class ClubController {
  /// Récupère le stream de tous les clubs
  /// Récupère le stream de tous les clubs
  static Stream<List<Club>> obtenirTousLesClubsStream() {
    return FirebaseFirestoreService.obtenirTousLesClubs();
  }

  /// Récupère un club par son ID
  static Future<Club?> obtenirClubParId(String clubId) async {
    return await FirebaseFirestoreService.obtenirClubParId(clubId);
  }

  /// Récupère le stream d'un club par son ID
  static Stream<Club?> obtenirClubParIdStream(String clubId) {
    return FirebaseFirestoreService.clubsCollection
        .doc(clubId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
        return Club.fromFirestore(data, data['id']);
      }
      return null;
    });
  }
  /// Crée un nouveau club
  static Future<bool> createClub({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String nom,
    required String description,
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
      await FirebaseFirestoreService.creerClub(
        nom: nom,
        description: description,
        createurId: utilisateur.uid,
      );

      // Envoyer une notification pour le nouveau club
      await NotificationService().notifyNewClub(nom);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Club créé avec succès')),
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

  /// Rejoint ou quitte un club
  static Future<void> toggleMembership({
    required BuildContext context,
    required String clubId,
    required bool isMember,
    required Function(bool) setLoading,
    required Function(bool) setMemberStatus,
  }) async {
    final utilisateur = FirebaseAuthService.currentUser;
    if (utilisateur == null) return;

    setLoading(true);

    try {
      if (isMember) {
        await FirebaseFirestoreService.quitterClub(
          clubId: clubId,
          userId: utilisateur.uid,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vous avez quitté le club')),
          );
        }
      } else {
        await FirebaseFirestoreService.rejoindreClub(
          clubId: clubId,
          userId: utilisateur.uid,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vous avez rejoint le club')),
          );
        }
      }
      
      setMemberStatus(!isMember);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      setLoading(false);
    }
  }

  /// Vérifie si l'utilisateur est membre d'un club
  static Future<bool> checkMembership(String clubId, String userId) async {
    return await FirebaseFirestoreService.estMembre(
      clubId: clubId,
      userId: userId,
    );
  }

  /// Modifie un club
  static Future<bool> updateClub({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String clubId,
    required String nom,
    required String description,
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
      await FirebaseFirestoreService.modifierClub(
        clubId: clubId,
        nom: nom,
        description: description,
        createurId: utilisateur.uid,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Club modifié avec succès')),
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

  /// Supprime un club
  static Future<bool> deleteClub({
    required BuildContext context,
    required String clubId,
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
      await FirebaseFirestoreService.supprimerClub(
        clubId: clubId,
        createurId: utilisateur.uid,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Club supprimé avec succès')),
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


  /// Compte le nombre de clubs rejoints par l'utilisateur
  static Future<int> countJoinedClubs(String userId) async {
    try {
      final clubs = await FirebaseFirestoreService.clubsCollection.get();
      int count = 0;
      
      for (var doc in clubs.docs) {
        final isMember = await FirebaseFirestoreService.estMembre(
          clubId: doc.id,
          userId: userId,
        );
        if (isMember) count++;
      }
      
      return count;
    } catch (e) {
      return 0;
    }
  }
}

