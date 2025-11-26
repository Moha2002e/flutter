import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_firestore.dart';
import '../models/club.dart';
import 'CreerClubScreen.dart';
import 'ClubDetailScreen.dart';

/// Écran affichant la liste des clubs
class ClubsScreen extends StatelessWidget {
  const ClubsScreen({super.key});

  static const String routeName = '/clubs';

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
                _construireListeClubs(),
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
          const Text('Clubs', style: kClubsScreenTitleText),
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
        Navigator.pushNamed(context, CreerClubScreen.routeName);
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

  /// Construit la liste des clubs
  Widget _construireListeClubs() {
    return Expanded(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirebaseFirestoreService.obtenirTousLesClubs(),
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
                'Aucun club disponible',
                style: TextStyle(color: kWhiteColor),
              ),
            );
          }

          final clubs = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            itemCount: clubs.length,
            itemBuilder: (context, index) {
              final club = Club.fromFirestore(clubs[index], clubs[index]['id']);
              return _construireCarteClub(context, club);
            },
          );
        },
      ),
    );
  }

  /// Construit une carte de club
  Widget _construireCarteClub(BuildContext context, Club club) {
    return Container(
      margin: const EdgeInsets.only(bottom: kSmallSpace),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kInputFieldPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _construireAvatarClub(),
            const SizedBox(width: kSmallSpace),
            Expanded(child: _construireContenuClub(club)),
            const SizedBox(width: kSmallSpace),
            _construireBoutonVoir(context, club.id),
          ],
        ),
      ),
    );
  }

  /// Construit l'avatar du club
  Widget _construireAvatarClub() {
    return Container(
      width: kClubCardAvatarSize,
      height: kClubCardAvatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kMainButtonColor.withOpacity(kClubCardAvatarOpacity),
      ),
      child: Icon(
        Icons.group,
        size: kClubCardAvatarIconSize,
        color: kMainButtonColor,
      ),
    );
  }

  /// Construit le contenu de la carte (nom, description, infos)
  Widget _construireContenuClub(Club club) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(club.nom, style: kClubCardTitleText),
        const SizedBox(height: kSpacingAfterClubCardTitle),
        Text(
          club.description,
          style: kClubCardDescriptionText,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: kSpacingAfterClubCardDescription),
        Row(
          children: [
            Text('${club.nombreMembres} membres', style: kClubCardInfoText),
            const SizedBox(width: kSmallSpace),
            Text(club.dateFormatee, style: kClubCardInfoText),
          ],
        ),
      ],
    );
  }

  /// Construit le bouton "Voir"
  Widget _construireBoutonVoir(BuildContext context, String clubId) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          ClubDetailScreen.routeName,
          arguments: clubId,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kMainButtonColor,
        foregroundColor: kWhiteColor,
        padding: const EdgeInsets.symmetric(
          horizontal: kClubCardButtonHorizontalPadding,
          vertical: kClubCardButtonVerticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kClubCardButtonBorderRadius),
        ),
      ),
      child: const Text('Voir', style: kClubCardButtonText),
    );
  }
}
