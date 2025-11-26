import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_firestore.dart';
import '../models/cours.dart';
import 'CreerCoursScreen.dart';
import 'CoursDetailScreen.dart';

/// Écran affichant la liste des cours (calendrier)
class CalendrierScreen extends StatelessWidget {
  const CalendrierScreen({super.key});

  static const String routeName = '/calendrier';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: kBackgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _construireEnTete(context),
                const SizedBox(height: kSpacingAfterHeader),
                _construireListeCours(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit l'en-tête avec bouton retour, titre et bouton ajouter
  Widget _construireEnTete(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _construireBoutonRetour(context),
          const Text('Calendrier', style: kCalendrierScreenTitleText),
          _construireBoutonAjouter(context),
        ],
      ),
    );
  }

  /// Construit le bouton retour
  Widget _construireBoutonRetour(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: kBackButtonSize,
        height: kBackButtonSize,
        decoration: const BoxDecoration(
          color: kWhiteColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  /// Construit le bouton ajouter
  Widget _construireBoutonAjouter(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CreerCoursScreen.routeName);
      },
      child: Container(
        width: kBackButtonSize,
        height: kBackButtonSize,
        decoration: const BoxDecoration(
          color: kWhiteColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  /// Construit la liste des cours
  Widget _construireListeCours() {
    return Expanded(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirebaseFirestoreService.obtenirTousLesCours(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kWhiteColor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur: ${snapshot.error}',
                style: const TextStyle(color: kWhiteColor),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aucun cours disponible',
                style: TextStyle(color: kWhiteColor),
              ),
            );
          }

          final cours = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            itemCount: cours.length,
            itemBuilder: (context, index) {
              final coursItem = Cours.fromFirestore(cours[index], cours[index]['id']);
              return _construireCarteCours(context, coursItem);
            },
          );
        },
      ),
    );
  }

  /// Construit une carte de cours
  Widget _construireCarteCours(BuildContext context, Cours cours) {
    return Container(
      margin: const EdgeInsets.only(bottom: kSmallSpace),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kInputFieldPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _construireContenuCours(cours)),
                const SizedBox(width: kSmallSpace),
                _construireBoutonVoir(context, cours.id),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le contenu de la carte (nom, infos)
  Widget _construireContenuCours(Cours cours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(cours.nom, style: kCoursCardTitleText),
        const SizedBox(height: kSpacingAfterCoursCardTitle),
        Text(cours.dateFormatee, style: kCoursCardInfoText),
        const SizedBox(height: kSpacingAfterCoursCardInfo),
        Row(
          children: [
            Text('Prof: ${cours.nomProf}', style: kCoursCardInfoText),
            const SizedBox(width: kSmallSpace),
            Text('Local: ${cours.local}', style: kCoursCardInfoText),
          ],
        ),
      ],
    );
  }

  /// Construit le bouton "Voir"
  Widget _construireBoutonVoir(BuildContext context, String coursId) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, CoursDetailScreen.routeName, arguments: coursId);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kMainButtonColor,
        foregroundColor: kWhiteColor,
        padding: const EdgeInsets.symmetric(
          horizontal: kCoursCardButtonHorizontalPadding,
          vertical: kCoursCardButtonVerticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCoursCardButtonBorderRadius),
        ),
      ),
      child: const Text('Voir', style: kCoursCardButtonText),
    );
  }
}


