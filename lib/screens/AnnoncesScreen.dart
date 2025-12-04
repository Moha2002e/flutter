import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../controllers/annonce_controller.dart';
import '../models/annonce.dart';
import '../utils/guest_utils.dart';
import 'CreerAnnonceScreen.dart';
import 'AnnonceDetailScreen.dart';

/// Écran affichant la liste des annonces
class AnnoncesScreen extends StatelessWidget {
  const AnnoncesScreen({super.key});

  static const String routeName = '/annonces';

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
                _construireListeAnnonces(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit l'en-tête avec titre et bouton ajouter
  Widget _construireEnTete(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: kBackButtonSize), // Espace pour équilibrer le layout
          const Text('Annonces', style: kAnnoncesScreenTitleText),
          _construireBoutonAjouter(context),
        ],
      ),
    );
  }

  /// Construit le bouton ajouter
  Widget _construireBoutonAjouter(BuildContext context) {
    final style = getGuestButtonStyle();
    return GestureDetector(
      onTap: () => handleGuestAction(
        context,
        () => Navigator.pushNamed(context, CreerAnnonceScreen.routeName),
      ),
      child: Container(
        width: kBackButtonSize,
        height: kBackButtonSize,
        decoration: BoxDecoration(
          color: kWhiteColor.withOpacity(style['opacity'] as double),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: style['color'] as Color),
      ),
    );
  }

  /// Construit la liste des annonces
  Widget _construireListeAnnonces() {
    return Expanded(
      child: StreamBuilder<List<Annonce>>(
        stream: AnnonceController.obtenirToutesLesAnnoncesStream(),
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
                'Aucune annonce disponible',
                style: TextStyle(color: kWhiteColor),
              ),
            );
          }

          final annonces = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            itemCount: annonces.length,
            itemBuilder: (context, index) {
              return _construireCarteAnnonce(context, annonces[index]);
            },
          );
        },
      ),
    );
  }

  /// Construit une carte d'annonce
  Widget _construireCarteAnnonce(BuildContext context, Annonce annonce) {
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
                Expanded(child: _construireContenuAnnonce(annonce)),
                const SizedBox(width: kSmallSpace),
                _construireBoutonVoir(context, annonce.id),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le contenu de la carte (nom, description, infos)
  Widget _construireContenuAnnonce(Annonce annonce) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(annonce.nom, style: kAnnonceCardTitleText),
        const SizedBox(height: kSpacingAfterAnnonceCardTitle),
        Text(
          annonce.description,
          style: kAnnonceCardDescriptionText,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: kSpacingAfterAnnonceCardDescription),
        Row(
          children: [
            Text(annonce.dateFormatee, style: kAnnonceCardInfoText),
            const SizedBox(width: kSmallSpace),
            Text(annonce.categorie, style: kAnnonceCardInfoText),
          ],
        ),
      ],
    );
  }

  /// Construit le bouton "Voir"
  Widget _construireBoutonVoir(BuildContext context, String annonceId) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, AnnonceDetailScreen.routeName, arguments: annonceId);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kMainButtonColor,
        foregroundColor: kWhiteColor,
        padding: const EdgeInsets.symmetric(
          horizontal: kAnnonceCardButtonHorizontalPadding,
          vertical: kAnnonceCardButtonVerticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kAnnonceCardButtonBorderRadius),
        ),
      ),
      child: const Text('Voir', style: kAnnonceCardButtonText),
    );
  }
}


