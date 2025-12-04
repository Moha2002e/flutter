import 'package:cloud_firestore/cloud_firestore.dart';
import '../styles/sizes.dart';
import '../models/club.dart';
import '../models/annonce.dart';
import '../models/evenement.dart';
import '../models/cours.dart';

class FirebaseFirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference pour les clubs
  static CollectionReference get clubsCollection => 
      _firestore.collection('clubs');

  // Collection reference pour les annonces
  static CollectionReference get annoncesCollection => 
      _firestore.collection('annonces');

  // Collection reference pour les événements
  static CollectionReference get evenementsCollection => 
      _firestore.collection('evenements');

  // Collection reference pour les cours
  static CollectionReference get coursCollection => 
      _firestore.collection('cours');

  /// Créer un nouveau club
  static Future<String> creerClub({
    required String nom,
    required String description,
    required String createurId,
  }) async {
    try {
      // Crée le document du club
      final docRef = await clubsCollection.add({
        'nom': nom,
        'description': description,
        'nombreMembres': kNombreMembresInitial,
        'dateCreation': FieldValue.serverTimestamp(),
        'createurId': createurId,
      });

      // Ajoute le créateur comme membre dans la sous-collection
      await docRef.collection('membres').doc(createurId).set({
        'dateAdhesion': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création du club: $e');
    }
  }

  /// Récupérer tous les clubs
  static Stream<List<Club>> obtenirTousLesClubs() {
    return clubsCollection
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Club.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Récupérer un club par son ID
  /// Récupérer un club par son ID
  static Future<Club?> obtenirClubParId(String clubId) async {
    try {
      final doc = await clubsCollection.doc(clubId).get();
      if (doc.exists) {
        return Club.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du club: $e');
    }
  }

  /// Rejoindre un club
  static Future<void> rejoindreClub({
    required String clubId,
    required String userId,
  }) async {
    try {
      final clubRef = clubsCollection.doc(clubId);
      final membreRef = clubRef.collection('membres').doc(userId);

      // Vérifie si l'utilisateur est déjà membre
      final membreDoc = await membreRef.get();
      if (membreDoc.exists) {
        throw Exception('Vous êtes déjà membre de ce club');
      }

      // Utilise une transaction pour mettre à jour le compteur et ajouter le membre
      await _firestore.runTransaction((transaction) async {
        // Toutes les lectures en premier
        final clubDoc = await transaction.get(clubRef);
        
        if (!clubDoc.exists) {
          throw Exception('Le club n\'existe pas');
        }
        
        final club = Club.fromFirestore(clubDoc.data() as Map<String, dynamic>, clubDoc.id);
        final nombreMembres = club.nombreMembres;

        // Puis toutes les écritures
        transaction.set(membreRef, {
          'dateAdhesion': FieldValue.serverTimestamp(),
        });

        transaction.update(clubRef, {
          'nombreMembres': nombreMembres + kIncrementMembre,
        });
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'adhésion au club: $e');
    }
  }

  /// Quitter un club
  static Future<void> quitterClub({
    required String clubId,
    required String userId,
  }) async {
    try {
      final clubRef = clubsCollection.doc(clubId);
      final membreRef = clubRef.collection('membres').doc(userId);

      // Utilise une transaction pour mettre à jour le compteur et supprimer le membre
      await _firestore.runTransaction((transaction) async {
        // Toutes les lectures en premier
        final clubDoc = await transaction.get(clubRef);
        
        if (!clubDoc.exists) {
          throw Exception('Le club n\'existe pas');
        }
        
        final club = Club.fromFirestore(clubDoc.data() as Map<String, dynamic>, clubDoc.id);
        final nombreMembres = club.nombreMembres;

        // Puis toutes les écritures
        transaction.delete(membreRef);

        transaction.update(clubRef, {
          'nombreMembres': nombreMembres - kDecrementMembre,
        });
      });
    } catch (e) {
      throw Exception('Erreur lors de la sortie du club: $e');
    }
  }

  /// Vérifier si un utilisateur est membre d'un club
  static Future<bool> estMembre({
    required String clubId,
    required String userId,
  }) async {
    try {
      final membreDoc = await clubsCollection
          .doc(clubId)
          .collection('membres')
          .doc(userId)
          .get();
      return membreDoc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Modifier un club
  static Future<void> modifierClub({
    required String clubId,
    required String nom,
    required String description,
    required String createurId,
  }) async {
    try {
      final docRef = clubsCollection.doc(clubId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('Club introuvable');
      }
      
      final club = Club.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (club.createurId != createurId) {
        throw Exception('Vous n\'êtes pas autorisé à modifier ce club');
      }
      
      await docRef.update({
        'nom': nom,
        'description': description,
      });
    } catch (e) {
      throw Exception('Erreur lors de la modification du club: $e');
    }
  }

  /// Supprimer un club
  static Future<void> supprimerClub({
    required String clubId,
    required String createurId,
  }) async {
    try {
      final docRef = clubsCollection.doc(clubId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('Club introuvable');
      }
      
      final club = Club.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (club.createurId != createurId) {
        throw Exception('Vous n\'êtes pas autorisé à supprimer ce club');
      }
      
      // Supprimer aussi la sous-collection des membres
      final membresSnapshot = await docRef.collection('membres').get();
      final batch = _firestore.batch();
      for (var membreDoc in membresSnapshot.docs) {
        batch.delete(membreDoc.reference);
      }
      await batch.commit();
      
      // Supprimer le club
      await docRef.delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression du club: $e');
    }
  }

  /// Créer une nouvelle annonce
  static Future<String> creerAnnonce({
    required String nom,
    required String description,
    required DateTime? date,
    required String categorie,
    required String createurId,
  }) async {
    try {
      final docRef = await annoncesCollection.add({
        'nom': nom,
        'description': description,
        'date': date != null ? Timestamp.fromDate(date) : null,
        'categorie': categorie,
        'dateCreation': FieldValue.serverTimestamp(),
        'createurId': createurId,
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'annonce: $e');
    }
  }

  /// Récupérer toutes les annonces
  static Stream<List<Annonce>> obtenirToutesLesAnnonces() {
    return annoncesCollection
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Annonce.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Récupérer une annonce par son ID
  /// Récupérer une annonce par son ID
  static Future<Annonce?> obtenirAnnonceParId(String annonceId) async {
    try {
      final doc = await annoncesCollection.doc(annonceId).get();
      if (doc.exists) {
        return Annonce.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'annonce: $e');
    }
  }

  /// Modifier une annonce
  static Future<void> modifierAnnonce({
    required String annonceId,
    required String nom,
    required String description,
    required DateTime? date,
    required String categorie,
    required String createurId,
  }) async {
    try {
      final docRef = annoncesCollection.doc(annonceId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('Annonce introuvable');
      }
      
      final annonce = Annonce.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (annonce.createurId != createurId) {
        throw Exception('Vous n\'êtes pas autorisé à modifier cette annonce');
      }
      
      await docRef.update({
        'nom': nom,
        'description': description,
        'date': date != null ? Timestamp.fromDate(date) : null,
        'categorie': categorie,
      });
    } catch (e) {
      throw Exception('Erreur lors de la modification de l\'annonce: $e');
    }
  }

  /// Supprimer une annonce
  static Future<void> supprimerAnnonce({
    required String annonceId,
    required String createurId,
  }) async {
    try {
      final docRef = annoncesCollection.doc(annonceId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('Annonce introuvable');
      }
      
      final annonce = Annonce.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (annonce.createurId != createurId) {
        throw Exception('Vous n\'êtes pas autorisé à supprimer cette annonce');
      }
      
      await docRef.delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'annonce: $e');
    }
  }

  /// Créer un nouvel événement
  static Future<String> creerEvenement({
    required String nom,
    required String description,
    required DateTime? date,
    required String lieu,
    required String createurId,
  }) async {
    try {
      final docRef = await evenementsCollection.add({
        'nom': nom,
        'description': description,
        'date': date != null ? Timestamp.fromDate(date) : null,
        'lieu': lieu,
        'dateCreation': FieldValue.serverTimestamp(),
        'createurId': createurId,
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'événement: $e');
    }
  }

  /// Récupérer tous les événements
  static Stream<List<Evenement>> obtenirTousLesEvenements() {
    return evenementsCollection
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Evenement.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Récupérer un événement par son ID
  /// Récupérer un événement par son ID
  static Future<Evenement?> obtenirEvenementParId(String evenementId) async {
    try {
      final doc = await evenementsCollection.doc(evenementId).get();
      if (doc.exists) {
        return Evenement.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'événement: $e');
    }
  }

  /// Modifier un événement
  static Future<void> modifierEvenement({
    required String evenementId,
    required String nom,
    required String description,
    required DateTime? date,
    required String lieu,
    required String createurId,
  }) async {
    try {
      final docRef = evenementsCollection.doc(evenementId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('Événement introuvable');
      }
      
      final evenement = Evenement.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (evenement.createurId != createurId) {
        throw Exception('Vous n\'êtes pas autorisé à modifier cet événement');
      }
      
      await docRef.update({
        'nom': nom,
        'description': description,
        'date': date != null ? Timestamp.fromDate(date) : null,
        'lieu': lieu,
      });
    } catch (e) {
      throw Exception('Erreur lors de la modification de l\'événement: $e');
    }
  }

  /// Supprimer un événement
  static Future<void> supprimerEvenement({
    required String evenementId,
    required String createurId,
  }) async {
    try {
      final docRef = evenementsCollection.doc(evenementId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('Événement introuvable');
      }
      
      final evenement = Evenement.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (evenement.createurId != createurId) {
        throw Exception('Vous n\'êtes pas autorisé à supprimer cet événement');
      }
      
      await docRef.delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'événement: $e');
    }
  }

  /// Créer un nouveau cours
  static Future<String> creerCours({
    required String nom,
    required DateTime? date,
    required String nomProf,
    required String local,
    required String createurId,
  }) async {
    try {
      final docRef = await coursCollection.add({
        'nom': nom,
        'date': date != null ? Timestamp.fromDate(date) : null,
        'nomProf': nomProf,
        'local': local,
        'dateCreation': FieldValue.serverTimestamp(),
        'createurId': createurId,
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création du cours: $e');
    }
  }

  /// Récupérer tous les cours
  static Stream<List<Cours>> obtenirTousLesCours() {
    return coursCollection
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Cours.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Récupérer un cours par son ID
  /// Récupérer un cours par son ID
  static Future<Cours?> obtenirCoursParId(String coursId) async {
    try {
      final doc = await coursCollection.doc(coursId).get();
      if (doc.exists) {
        return Cours.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du cours: $e');
    }
  }

  /// Modifier un cours
  static Future<void> modifierCours({
    required String coursId,
    required String nom,
    required DateTime? date,
    required String nomProf,
    required String local,
    required String createurId,
  }) async {
    try {
      final docRef = coursCollection.doc(coursId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('Cours introuvable');
      }
      
      final cours = Cours.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (cours.createurId != createurId) {
        throw Exception('Vous n\'êtes pas autorisé à modifier ce cours');
      }
      
      await docRef.update({
        'nom': nom,
        'date': date != null ? Timestamp.fromDate(date) : null,
        'nomProf': nomProf,
        'local': local,
      });
    } catch (e) {
      throw Exception('Erreur lors de la modification du cours: $e');
    }
  }

  /// Supprimer un cours
  static Future<void> supprimerCours({
    required String coursId,
    required String createurId,
  }) async {
    try {
      final docRef = coursCollection.doc(coursId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        throw Exception('Cours introuvable');
      }
      
      final cours = Cours.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (cours.createurId != createurId) {
        throw Exception('Vous n\'êtes pas autorisé à supprimer ce cours');
      }
      
      await docRef.delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression du cours: $e');
    }
  }

  /// Obtenir le nombre de clubs
  static Stream<int> obtenirNombreClubs() {
    return clubsCollection.snapshots().map((snapshot) => snapshot.docs.length);
  }

  /// Obtenir le nombre d'annonces
  static Stream<int> obtenirNombreAnnonces() {
    return annoncesCollection.snapshots().map((snapshot) => snapshot.docs.length);
  }

  /// Obtenir le nombre d'événements
  static Stream<int> obtenirNombreEvenements() {
    return evenementsCollection.snapshots().map((snapshot) => snapshot.docs.length);
  }

  /// Obtenir le nombre de cours
  static Stream<int> obtenirNombreCours() {
    return coursCollection.snapshots().map((snapshot) => snapshot.docs.length);
  }
}
