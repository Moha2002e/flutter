import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_firestore.dart';
import '../models/annonce.dart';

/// Écran de détails d'une annonce
class AnnonceDetailScreen extends StatelessWidget {
  const AnnonceDetailScreen({super.key, required this.annonceId});

  final String annonceId;

  static const String routeName = '/annonce-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: kBackgroundGradient,
          ),
          child: SafeArea(
            child: StreamBuilder<Map<String, dynamic>?>(
              stream: FirebaseFirestoreService.annoncesCollection
                  .doc(annonceId)
                  .snapshots()
                  .map((doc) {
                if (doc.exists) {
                  return {
                    'id': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  };
                }
                return null;
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kWhiteColor),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return _construireErreur(context);
                }

                final annonce = Annonce.fromFirestore(snapshot.data!, snapshot.data!['id']);

                return Column(
                  children: [
                    _construireEnTete(context, annonce.nom),
                    const SizedBox(height: kSpacingAfterHeader),
                    _construireCarteAnnonce(annonce),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Construit l'en-tête avec bouton retour et titre
  Widget _construireEnTete(BuildContext context, String nomAnnonce) {
    return Padding(
      padding: const EdgeInsets.all(kHorizontalPadding),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
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
            ),
          ),
          const SizedBox(height: kSpacingAfterBackButton),
          Text(nomAnnonce, style: kAnnonceDetailTitleText, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Construit la carte blanche avec le contenu de l'annonce
  Widget _construireCarteAnnonce(Annonce annonce) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kInputFieldPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _construireSectionImageEtNom(annonce.nom),
              const SizedBox(height: kSpacingBetweenFields),
              _construireInfosAnnonce(annonce),
              const SizedBox(height: kSpacingBetweenFields),
              _construireDescription(annonce.description),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la section avec l'image et le nom de l'annonce
  Widget _construireSectionImageEtNom(String nomAnnonce) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: kAnnonceDetailAvatarSize,
          height: kAnnonceDetailAvatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kMainButtonColor.withOpacity(kClubCardAvatarOpacity),
          ),
          child: Icon(
            Icons.announcement,
            size: kAnnonceDetailAvatarIconSize,
            color: kMainButtonColor,
          ),
        ),
        const SizedBox(width: kSmallSpace),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: kAnnonceDetailCardTitleTopPadding),
            child: Text(nomAnnonce, style: kAnnonceDetailCardTitleText),
          ),
        ),
      ],
    );
  }

  /// Construit les informations de l'annonce
  Widget _construireInfosAnnonce(Annonce annonce) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _construireInfo('Date', annonce.dateFormatee),
        const SizedBox(height: kSpacingBetweenFields),
        _construireInfo('Catégorie', annonce.categorie),
      ],
    );
  }

  /// Construit une ligne d'information
  Widget _construireInfo(String label, String valeur) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        Text(valeur, style: kAnnonceDetailInfoText),
      ],
    );
  }

  /// Construit la description de l'annonce
  Widget _construireDescription(String description) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: kSpacingBetweenLabelAndField),
            Text(description, style: kAnnonceDetailDescriptionText),
          ],
        ),
      ),
    );
  }

  /// Construit l'affichage d'erreur
  Widget _construireErreur(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kHorizontalPadding),
          child: Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
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
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Annonce introuvable',
              style: TextStyle(color: kWhiteColor),
            ),
          ),
        ),
      ],
    );
  }
}

