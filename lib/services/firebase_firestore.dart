import 'package:cloud_firestore/cloud_firestore.dart';
import '../styles/sizes.dart';

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
  static Stream<List<Map<String, dynamic>>> obtenirTousLesClubs() {
    return clubsCollection
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }

  /// Récupérer un club par son ID
  static Future<Map<String, dynamic>?> obtenirClubParId(String clubId) async {
    try {
      final doc = await clubsCollection.doc(clubId).get();
      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
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
        
        final nombreMembres = (clubDoc.data() as Map<String, dynamic>)['nombreMembres'] as int;

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
        
        final nombreMembres = (clubDoc.data() as Map<String, dynamic>)['nombreMembres'] as int;

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
  static Stream<List<Map<String, dynamic>>> obtenirToutesLesAnnonces() {
    return annoncesCollection
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }

  /// Récupérer une annonce par son ID
  static Future<Map<String, dynamic>?> obtenirAnnonceParId(String annonceId) async {
    try {
      final doc = await annoncesCollection.doc(annonceId).get();
      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'annonce: $e');
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
  static Stream<List<Map<String, dynamic>>> obtenirTousLesEvenements() {
    return evenementsCollection
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }

  /// Récupérer un événement par son ID
  static Future<Map<String, dynamic>?> obtenirEvenementParId(String evenementId) async {
    try {
      final doc = await evenementsCollection.doc(evenementId).get();
      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'événement: $e');
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
  static Stream<List<Map<String, dynamic>>> obtenirTousLesCours() {
    return coursCollection
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }

  /// Récupérer un cours par son ID
  static Future<Map<String, dynamic>?> obtenirCoursParId(String coursId) async {
    try {
      final doc = await coursCollection.doc(coursId).get();
      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du cours: $e');
    }
  }
}
