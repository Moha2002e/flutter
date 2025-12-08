import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_auth.dart';
import '../models/cours.dart';
import '../controllers/cours_controller.dart';
import 'ModifierCoursScreen.dart';

/// Écran de détails d'un cours
class CoursDetailScreen extends StatefulWidget {
  const CoursDetailScreen({super.key, required this.coursId});

  final String coursId;

  static const String routeName = '/cours-detail';

  @override
  State<CoursDetailScreen> createState() => _CoursDetailScreenState();
}

class _CoursDetailScreenState extends State<CoursDetailScreen> {
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
            child: StreamBuilder<Cours?>(
              stream: CoursController.obtenirCoursParIdStream(widget.coursId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kWhiteColor),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return _construireErreur(context);
                }

                final cours = snapshot.data!;
                final utilisateur = FirebaseAuthService.currentUser;
                final estCreateur = utilisateur != null && cours.createurId == utilisateur.uid;

                return Column(
                  children: [
                    _construireEnTete(context, cours.nom),
                    const SizedBox(height: kSpacingAfterHeader),
                    _construireCarteCours(cours, estCreateur),
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
  Widget _construireEnTete(BuildContext context, String nomCours) {
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
          Text(nomCours, style: kCoursDetailTitleText, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Construit la carte blanche avec le contenu du cours
  Widget _construireCarteCours(Cours cours, bool estCreateur) {
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
              _construireSectionImageEtNom(cours.nom),
              const SizedBox(height: kSpacingBetweenFields),
              _construireInfosCours(cours),
              if (estCreateur) ...[
                const SizedBox(height: kSpacingBeforeButton),
                _construireBoutonsModifierSupprimer(cours),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Construit les boutons Modifier et Supprimer
  Widget _construireBoutonsModifierSupprimer(Cours cours) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _modifierCours(cours),
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
                : const Text('Modifier', style: kCoursDetailInfoText),
          ),
        ),
        const SizedBox(width: kSpacingBetweenFields),
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _supprimerCours(),
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
                : const Text('Supprimer', style: kCoursDetailInfoText),
          ),
        ),
      ],
    );
  }

  /// Modifie le cours
  Future<void> _modifierCours(Cours cours) async {
    Navigator.pushNamed(
      context,
      ModifierCoursScreen.routeName,
      arguments: cours,
    );
  }

  /// Supprime le cours
  Future<void> _supprimerCours() async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce cours ?'),
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
      final success = await CoursController.deleteCours(
        context: context,
        coursId: widget.coursId,
        setLoading: (loading) {
          if (mounted) setState(() => _enChargement = loading);
        },
      );
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  /// Construit la section avec l'image et le nom du cours
  Widget _construireSectionImageEtNom(String nomCours) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: kCoursDetailAvatarSize,
          height: kCoursDetailAvatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kMainButtonColor.withOpacity(kClubCardAvatarOpacity),
          ),
          child: Icon(
            Icons.school,
            size: kCoursDetailAvatarIconSize,
            color: kMainButtonColor,
          ),
        ),
        const SizedBox(width: kSmallSpace),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: kCoursDetailCardTitleTopPadding),
            child: Text(nomCours, style: kCoursDetailCardTitleText),
          ),
        ),
      ],
    );
  }

  /// Construit les informations du cours
  Widget _construireInfosCours(Cours cours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _construireInfo('Date', cours.dateFormatee),
        const SizedBox(height: kSpacingBetweenFields),
        _construireInfo('Professeur', cours.nomProf),
        const SizedBox(height: kSpacingBetweenFields),
        _construireInfo('Local', cours.local),
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
        Text(valeur, style: kCoursDetailInfoText),
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
              'Cours introuvable',
              style: TextStyle(color: kWhiteColor),
            ),
          ),
        ),
      ],
    );
  }
}

