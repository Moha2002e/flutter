import 'package:cloud_firestore/cloud_firestore.dart';

class Cours {
  final String id;
  final String nom;
  final DateTime? date;
  final String nomProf;
  final String local;
  final String createurId;
  final DateTime? dateCreation;

  Cours({
    required this.id,
    required this.nom,
    this.date,
    required this.nomProf,
    required this.local,
    required this.createurId,
    this.dateCreation,
  });

  // Créer un Cours depuis un document Firestore
  factory Cours.fromFirestore(Map<String, dynamic> data, String id) {
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

    return Cours(
      id: id,
      nom: data['nom'] ?? '',
      date: date,
      nomProf: data['nomProf'] ?? '',
      local: data['local'] ?? '',
      createurId: data['createurId'] ?? '',
      dateCreation: dateCreation,
    );
  }

  // Convertir un Cours en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'nomProf': nomProf,
      'local': local,
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


