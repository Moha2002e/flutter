import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_firestore.dart';
import '../services/firebase_auth.dart';
import '../models/club.dart';

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
      final estMembre = await FirebaseFirestoreService.estMembre(
        clubId: widget.clubId,
        userId: utilisateur.uid,
      );
      if (mounted) {
        setState(() {
          _estMembre = estMembre;
        });
      }
    }
  }

  /// Gère l'adhésion ou le départ du club
  Future<void> _gererAdhesion() async {
    final utilisateur = FirebaseAuthService.currentUser;
    if (utilisateur == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez être connecté')),
      );
      return;
    }

    setState(() {
      _enChargement = true;
    });

    try {
      if (_estMembre == true) {
        await FirebaseFirestoreService.quitterClub(
          clubId: widget.clubId,
          userId: utilisateur.uid,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vous avez quitté le club')),
          );
        }
      } else {
        await FirebaseFirestoreService.rejoindreClub(
          clubId: widget.clubId,
          userId: utilisateur.uid,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vous avez rejoint le club')),
          );
        }
      }
      
      await _verifierMembre();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _enChargement = false;
        });
      }
    }
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
            child: StreamBuilder<Map<String, dynamic>?>(
              stream: FirebaseFirestoreService.clubsCollection
                  .doc(widget.clubId)
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
                  return _construireErreur();
                }

                final club = Club.fromFirestore(snapshot.data!, snapshot.data!['id']);

                return Column(
                  children: [
                    _construireEnTete(club.nom),
                    const SizedBox(height: kSpacingAfterHeader),
                    _construireCarteClub(club, utilisateur != null),
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
  Widget _construireCarteClub(Club club, bool utilisateurConnecte) {
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
              _construireSectionImageEtNom(club.nom),
              const SizedBox(height: kSpacingBetweenFields),
              _construireDescription(club.description),
              const SizedBox(height: kSpacingBeforeButton),
              if (utilisateurConnecte) _construireBoutonAction(),
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
    return Expanded(
      child: SingleChildScrollView(
        child: Text(description, style: kClubDetailDescriptionText),
      ),
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
