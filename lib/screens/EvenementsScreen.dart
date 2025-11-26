import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_firestore.dart';
import '../models/evenement.dart';
import 'CreerEvenementScreen.dart';
import 'EvenementDetailScreen.dart';

/// Écran affichant la liste des événements
class EvenementsScreen extends StatelessWidget {
  const EvenementsScreen({super.key});

  static const String routeName = '/evenements';

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
                _construireListeEvenements(),
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
          const Text('Événements', style: kEvenementsScreenTitleText),
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
        Navigator.pushNamed(context, CreerEvenementScreen.routeName);
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

  /// Construit la liste des événements
  Widget _construireListeEvenements() {
    return Expanded(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirebaseFirestoreService.obtenirTousLesEvenements(),
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
                'Aucun événement disponible',
                style: TextStyle(color: kWhiteColor),
              ),
            );
          }

          final evenements = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            itemCount: evenements.length,
            itemBuilder: (context, index) {
              final evenement = Evenement.fromFirestore(evenements[index], evenements[index]['id']);
              return _construireCarteEvenement(context, evenement);
            },
          );
        },
      ),
    );
  }

  /// Construit une carte d'événement
  Widget _construireCarteEvenement(BuildContext context, Evenement evenement) {
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
                Expanded(child: _construireContenuEvenement(evenement)),
                const SizedBox(width: kSmallSpace),
                _construireBoutonVoir(context, evenement.id),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le contenu de la carte (nom, description, infos)
  Widget _construireContenuEvenement(Evenement evenement) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(evenement.nom, style: kEvenementCardTitleText),
        const SizedBox(height: kSpacingAfterEvenementCardTitle),
        Text(
          evenement.description,
          style: kEvenementCardDescriptionText,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: kSpacingAfterEvenementCardDescription),
        Row(
          children: [
            Text(evenement.dateFormatee, style: kEvenementCardInfoText),
            const SizedBox(width: kSmallSpace),
            Text(evenement.lieu, style: kEvenementCardInfoText),
          ],
        ),
      ],
    );
  }

  /// Construit le bouton "Voir"
  Widget _construireBoutonVoir(BuildContext context, String evenementId) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, EvenementDetailScreen.routeName, arguments: evenementId);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kMainButtonColor,
        foregroundColor: kWhiteColor,
        padding: const EdgeInsets.symmetric(
          horizontal: kEvenementCardButtonHorizontalPadding,
          vertical: kEvenementCardButtonVerticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kEvenementCardButtonBorderRadius),
        ),
      ),
      child: const Text('Voir', style: kEvenementCardButtonText),
    );
  }
}


