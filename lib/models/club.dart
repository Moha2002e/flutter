import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String id;
  final String nom;
  final String description;
  final int nombreMembres;
  final DateTime? dateCreation;
  final String createurId;

  Club({
    required this.id,
    required this.nom,
    required this.description,
    required this.nombreMembres,
    this.dateCreation,
    required this.createurId,
  });

  // Créer un Club depuis un document Firestore
  factory Club.fromFirestore(Map<String, dynamic> data, String id) {
    Timestamp? timestamp = data['dateCreation'] as Timestamp?;
    DateTime? dateCreation;
    
    if (timestamp != null) {
      dateCreation = timestamp.toDate();
    }

    return Club(
      id: id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      nombreMembres: data['nombreMembres'] ?? 0,
      dateCreation: dateCreation,
      createurId: data['createurId'] ?? '',
    );
  }

  // Convertir un Club en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'description': description,
      'nombreMembres': nombreMembres,
      'createurId': createurId,
    };
  }

  // Formater la date au format DD/MM/YYYY
  String get dateFormatee {
    if (dateCreation == null) return 'DD/MM/YYYY';
    final jour = dateCreation!.day.toString().padLeft(2, '0');
    final mois = dateCreation!.month.toString().padLeft(2, '0');
    final annee = dateCreation!.year.toString();
    return '$jour/$mois/$annee';
  }
}

