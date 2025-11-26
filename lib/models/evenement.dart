import 'package:cloud_firestore/cloud_firestore.dart';

class Evenement {
  final String id;
  final String nom;
  final String description;
  final DateTime? date;
  final String lieu;
  final String createurId;
  final DateTime? dateCreation;

  Evenement({
    required this.id,
    required this.nom,
    required this.description,
    this.date,
    required this.lieu,
    required this.createurId,
    this.dateCreation,
  });

  // Créer un Evenement depuis un document Firestore
  factory Evenement.fromFirestore(Map<String, dynamic> data, String id) {
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

    return Evenement(
      id: id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      date: date,
      lieu: data['lieu'] ?? '',
      createurId: data['createurId'] ?? '',
      dateCreation: dateCreation,
    );
  }

  // Convertir un Evenement en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'description': description,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'lieu': lieu,
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


