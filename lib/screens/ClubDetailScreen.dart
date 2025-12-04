import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_auth.dart';
import '../models/club.dart';
import '../utils/guest_utils.dart';
import '../controllers/club_controller.dart';
import 'ModifierClubScreen.dart';

/// Écran de détails d'un club
class ClubDetailScreen extends StatefulWidget {
  const ClubDetailScreen({super.key, required this.clubId});

  final String clubId;

  static const String routeName = '/club-detail';

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  bool _enChargement = false;
  bool? _estMembre;

  @override
  void initState() {
    super.initState();
    _verifierMembre();
  }

  /// Vérifie si l'utilisateur est membre du club
  Future<void> _verifierMembre() async {
    final utilisateur = FirebaseAuthService.currentUser;
    if (utilisateur != null) {
      final estMembre = await ClubController.checkMembership(
        widget.clubId,
        utilisateur.uid,
      );
      if (mounted) {
        setState(() => _estMembre = estMembre);
      }
    }
  }

  /// Gère l'adhésion ou le départ du club
  Future<void> _gererAdhesion() async {
    if (isGuest()) {
      showGuestMessage(context);
      return;
    }
    
    final utilisateur = FirebaseAuthService.currentUser;
    if (utilisateur == null) return;

    await ClubController.toggleMembership(
      context: context,
      clubId: widget.clubId,
      isMember: _estMembre == true,
      setLoading: (loading) {
        if (mounted) {
          setState(() => _enChargement = loading);
        }
      },
      setMemberStatus: (isMember) {
        if (mounted) {
          setState(() => _estMembre = isMember);
        }
      },
    );
    
    await _verifierMembre();
  }

  @override
  Widget build(BuildContext context) {
    final utilisateur = FirebaseAuthService.currentUser;

    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: kBackgroundGradient,
          ),
          child: SafeArea(
            child: StreamBuilder<Club?>(
              stream: ClubController.obtenirClubParIdStream(widget.clubId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kWhiteColor),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return _construireErreur();
                }

                final club = snapshot.data!;
                final utilisateurConnecte = utilisateur != null && !isGuest();
                final estCreateur = utilisateur != null && club.createurId == utilisateur.uid;

                return Column(
                  children: [
                    _construireEnTete(club.nom),
                    const SizedBox(height: kSpacingAfterHeader),
                    _construireCarteClub(club, utilisateurConnecte, estCreateur),
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
  Widget _construireEnTete(String nomClub) {
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
          Text(nomClub, style: kClubDetailTitleText, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Construit la carte blanche avec le contenu du club
  Widget _construireCarteClub(Club club, bool utilisateurConnecte, bool estCreateur) {
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
              _construireSectionImageEtNom(club.nom),
              const SizedBox(height: kSpacingBetweenFields),
              _construireDescription(club.description),
              const SizedBox(height: kSpacingBeforeButton),
              if (estCreateur) ...[
                _construireBoutonsModifierSupprimer(club),
                const SizedBox(height: kSpacingBetweenFields),
              ],
              if (utilisateurConnecte && !estCreateur) _construireBoutonAction(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la section avec l'image et le nom du club
  Widget _construireSectionImageEtNom(String nomClub) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: kClubDetailAvatarSize,
          height: kClubDetailAvatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kMainButtonColor.withOpacity(kClubCardAvatarOpacity),
          ),
          child: Icon(
            Icons.group,
            size: kClubDetailAvatarIconSize,
            color: kMainButtonColor,
          ),
        ),
        const SizedBox(width: kSmallSpace),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: kClubDetailCardTitleTopPadding),
            child: Text(nomClub, style: kClubDetailCardTitleText),
          ),
        ),
      ],
    );
  }

  /// Construit la description du club
  Widget _construireDescription(String description) {
    return Text(description, style: kClubDetailDescriptionText);
  }

  /// Construit les boutons Modifier et Supprimer (pour le créateur)
  Widget _construireBoutonsModifierSupprimer(Club club) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _modifierClub(club),
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
                : const Text('Modifier', style: kClubDetailButtonText),
          ),
        ),
        const SizedBox(width: kSpacingBetweenFields),
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _supprimerClub(),
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
                : const Text('Supprimer', style: kClubDetailButtonText),
          ),
        ),
      ],
    );
  }

  /// Construit le bouton Rejoindre/Quitter
  Widget _construireBoutonAction() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _enChargement ? null : _gererAdhesion,
          style: ElevatedButton.styleFrom(
            backgroundColor: _estMembre == true ? Colors.red : kMainButtonColor,
            foregroundColor: kWhiteColor,
            padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
            ),
          ),
          child: _enChargement
              ? const CircularProgressIndicator(color: kWhiteColor)
              : Text(
                  _estMembre == true ? 'Quitter' : 'Rejoindre',
                  style: kClubDetailButtonText,
                ),
        ),
      ),
    );
  }

  /// Modifie le club
  Future<void> _modifierClub(Club club) async {
    final result = await Navigator.pushNamed(
      context,
      ModifierClubScreen.routeName,
      arguments: club,
    );
    if (result == true && mounted) {
      // Rafraîchir l'écran si modification réussie
      setState(() {});
    }
  }

  /// Supprime le club
  Future<void> _supprimerClub() async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce club ?'),
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
      final success = await ClubController.deleteClub(
        context: context,
        clubId: widget.clubId,
        setLoading: (loading) {
          if (mounted) setState(() => _enChargement = loading);
        },
      );
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  /// Construit l'affichage d'erreur
  Widget _construireErreur() {
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
              'Club introuvable',
              style: TextStyle(color: kWhiteColor),
            ),
          ),
        ),
      ],
    );
  }
}
