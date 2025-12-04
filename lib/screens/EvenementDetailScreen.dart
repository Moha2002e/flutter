import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_auth.dart';
import '../models/evenement.dart';
import '../controllers/evenement_controller.dart';

/// Écran de détails d'un événement
class EvenementDetailScreen extends StatefulWidget {
  const EvenementDetailScreen({super.key, required this.evenementId});

  final String evenementId;

  static const String routeName = '/evenement-detail';

  @override
  State<EvenementDetailScreen> createState() => _EvenementDetailScreenState();
}

class _EvenementDetailScreenState extends State<EvenementDetailScreen> {
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
            child: StreamBuilder<Evenement?>(
              stream: EvenementController.obtenirEvenementParIdStream(widget.evenementId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kWhiteColor),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return _construireErreur(context);
                }

                final evenement = snapshot.data!;
                final utilisateur = FirebaseAuthService.currentUser;
                final estCreateur = utilisateur != null && evenement.createurId == utilisateur.uid;

                return Column(
                  children: [
                    _construireEnTete(context, evenement.nom),
                    const SizedBox(height: kSpacingAfterHeader),
                    _construireCarteEvenement(evenement, estCreateur),
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
  Widget _construireEnTete(BuildContext context, String nomEvenement) {
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
          Text(nomEvenement, style: kEvenementDetailTitleText, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Construit la carte blanche avec le contenu de l'événement
  Widget _construireCarteEvenement(Evenement evenement, bool estCreateur) {
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
              _construireSectionImageEtNom(evenement.nom),
              const SizedBox(height: kSpacingBetweenFields),
              _construireInfosEvenement(evenement),
              const SizedBox(height: kSpacingBetweenFields),
              _construireDescription(evenement.description),
              if (estCreateur) ...[
                const SizedBox(height: kSpacingBeforeButton),
                _construireBoutonsModifierSupprimer(evenement),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Construit les boutons Modifier et Supprimer
  Widget _construireBoutonsModifierSupprimer(Evenement evenement) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _modifierEvenement(evenement),
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
                : const Text('Modifier', style: kEvenementDetailInfoText),
          ),
        ),
        const SizedBox(width: kSpacingBetweenFields),
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _supprimerEvenement(),
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
                : const Text('Supprimer', style: kEvenementDetailInfoText),
          ),
        ),
      ],
    );
  }

  /// Modifie l'événement
  Future<void> _modifierEvenement(Evenement evenement) async {
    // TODO: Créer ModifierEvenementScreen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité à venir')),
    );
  }

  /// Supprime l'événement
  Future<void> _supprimerEvenement() async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet événement ?'),
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
      final success = await EvenementController.deleteEvenement(
        context: context,
        evenementId: widget.evenementId,
        setLoading: (loading) {
          if (mounted) setState(() => _enChargement = loading);
        },
      );
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  /// Construit la section avec l'image et le nom de l'événement
  Widget _construireSectionImageEtNom(String nomEvenement) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: kEvenementDetailAvatarSize,
          height: kEvenementDetailAvatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kMainButtonColor.withOpacity(kClubCardAvatarOpacity),
          ),
          child: Icon(
            Icons.event,
            size: kEvenementDetailAvatarIconSize,
            color: kMainButtonColor,
          ),
        ),
        const SizedBox(width: kSmallSpace),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: kEvenementDetailCardTitleTopPadding),
            child: Text(nomEvenement, style: kEvenementDetailCardTitleText),
          ),
        ),
      ],
    );
  }

  /// Construit les informations de l'événement
  Widget _construireInfosEvenement(Evenement evenement) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _construireInfo('Date', evenement.dateFormatee),
        const SizedBox(height: kSpacingBetweenFields),
        _construireInfo('Lieu', evenement.lieu),
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
        Text(valeur, style: kEvenementDetailInfoText),
      ],
    );
  }

  /// Construit la description de l'événement
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
        Text(description, style: kEvenementDetailDescriptionText),
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
              'Événement introuvable',
              style: TextStyle(color: kWhiteColor),
            ),
          ),
        ),
      ],
    );
  }
}

