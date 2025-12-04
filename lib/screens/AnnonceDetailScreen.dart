import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_auth.dart';
import '../models/annonce.dart';
import '../controllers/annonce_controller.dart';
import 'ModifierAnnonceScreen.dart';

/// Écran de détails d'une annonce
class AnnonceDetailScreen extends StatefulWidget {
  const AnnonceDetailScreen({super.key, required this.annonceId});

  final String annonceId;

  static const String routeName = '/annonce-detail';

  @override
  State<AnnonceDetailScreen> createState() => _AnnonceDetailScreenState();
}

class _AnnonceDetailScreenState extends State<AnnonceDetailScreen> {
  bool _enChargement = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: kBackgroundGradient,
          ),
          child: SafeArea(
            child: StreamBuilder<Annonce?>(
              stream: AnnonceController.obtenirAnnonceParIdStream(widget.annonceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kWhiteColor),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return _construireErreur(context);
                }

                final annonce = snapshot.data!;
                final utilisateur = FirebaseAuthService.currentUser;
                final estCreateur = utilisateur != null && annonce.createurId == utilisateur.uid;

                return Column(
                  children: [
                    _construireEnTete(context, annonce.nom),
                    const SizedBox(height: kSpacingAfterHeader),
                    _construireCarteAnnonce(annonce, estCreateur),
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
  Widget _construireCarteAnnonce(Annonce annonce, bool estCreateur) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * kDetailScreenMaxHeightRatio,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kInputFieldPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _construireSectionImageEtNom(annonce.nom),
              const SizedBox(height: kSpacingBetweenFields),
              _construireInfosAnnonce(annonce),
              const SizedBox(height: kSpacingBetweenFields),
              _construireDescription(annonce.description),
              if (estCreateur) ...[
                const SizedBox(height: kSpacingBeforeButton),
                _construireBoutonsModifierSupprimer(annonce),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Construit les boutons Modifier et Supprimer
  Widget _construireBoutonsModifierSupprimer(Annonce annonce) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _modifierAnnonce(annonce),
            style: ElevatedButton.styleFrom(
              backgroundColor: kMainButtonColor,
              foregroundColor: kWhiteColor,
              padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
              ),
            ),
            child: _enChargement
                ? const CircularProgressIndicator(color: kWhiteColor)
                : const Text('Modifier', style: kAnnonceDetailInfoText),
          ),
        ),
        const SizedBox(width: kSpacingBetweenFields),
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _supprimerAnnonce(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: kWhiteColor,
              padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
              ),
            ),
            child: _enChargement
                ? const CircularProgressIndicator(color: kWhiteColor)
                : const Text('Supprimer', style: kAnnonceDetailInfoText),
          ),
        ),
      ],
    );
  }

  /// Modifie l'annonce
  Future<void> _modifierAnnonce(Annonce annonce) async {
    final result = await Navigator.pushNamed(
      context,
      ModifierAnnonceScreen.routeName,
      arguments: annonce,
    );
    if (result == true && mounted) {
      setState(() {});
    }
  }

  /// Supprime l'annonce
  Future<void> _supprimerAnnonce() async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette annonce ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmer == true) {
      final success = await AnnonceController.deleteAnnonce(
        context: context,
        annonceId: widget.annonceId,
        setLoading: (loading) {
          if (mounted) setState(() => _enChargement = loading);
        },
      );
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
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
          style: TextStyle(
            fontSize: kDetailScreenInfoFontSize,
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
    return Column(
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

