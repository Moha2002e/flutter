import 'package:cloud_firestore/cloud_firestore.dart';

class Annonce {
  final String id;
  final String nom;
  final String description;
  final DateTime? date;
  final String categorie;
  final String createurId;
  final DateTime? dateCreation;

  Annonce({
    required this.id,
    required this.nom,
    required this.description,
    this.date,
    required this.categorie,
    required this.createurId,
    this.dateCreation,
  });

  // Créer une Annonce depuis un document Firestore
  factory Annonce.fromFirestore(Map<String, dynamic> data, String id) {
    Timestamp? timestampDate = data['date'] as Timestamp?;
    DateTime? date;
    
    if (timestampDate != null) {
      date = timestampDate.toDate();
    }

    Timestamp? timestampCreation = data['dateCreation'] as Timestamp?;
    DateTime? dateCreation;
    
    if (timestampCreation != null) {
      dateCreation = timestampCreation.toDate();
    }

    return Annonce(
      id: id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      date: date,
      categorie: data['categorie'] ?? '',
      createurId: data['createurId'] ?? '',
      dateCreation: dateCreation,
    );
  }

  // Convertir une Annonce en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'description': description,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'categorie': categorie,
      'createurId': createurId,
    };
  }

  // Formater la date au format DD/MM/YYYY
  String get dateFormatee {
    if (date == null) return 'DD/MM/YYYY';
    final jour = date!.day.toString().padLeft(2, '0');
    final mois = date!.month.toString().padLeft(2, '0');
    final annee = date!.year.toString();
    return '$jour/$mois/$annee';
  }
}


