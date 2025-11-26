import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_firestore.dart';
import '../services/firebase_auth.dart';

/// Écran pour créer un nouveau club
class CreerClubScreen extends StatefulWidget {
  const CreerClubScreen({super.key});

  static const String routeName = '/creer-club';

  @override
  State<CreerClubScreen> createState() => _CreerClubScreenState();
}

class _CreerClubScreenState extends State<CreerClubScreen> {
  final TextEditingController controleurNom = TextEditingController();
  final TextEditingController controleurDescription = TextEditingController();
  final _cleFormulaire = GlobalKey<FormState>();
  bool _enChargement = false;

  @override
  void dispose() {
    controleurNom.dispose();
    controleurDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: kBackgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _construireBoutonRetour(),
                  const SizedBox(height: kSpacingAfterBackButton),
                  const Text('Créer un club', style: kCreerClubTitleText),
                  const SizedBox(height: kSpacingBeforeForm),
                  _construireFormulaire(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le bouton retour
  Widget _construireBoutonRetour() {
    return Padding(
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
    );
  }

  /// Construit le formulaire de création
  Widget _construireFormulaire() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
      child: Form(
        key: _cleFormulaire,
        child: Column(
          children: [
            _construireChampNom(),
            const SizedBox(height: kSpacingBetweenFields),
            _construireChampDescription(),
            const SizedBox(height: kSpacingBeforeButton),
            _construireBoutonCreer(),
            const SizedBox(height: kSpacingBottomForm),
          ],
        ),
      ),
    );
  }

  /// Construit le champ nom du club
  Widget _construireChampNom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nom du club', style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        TextFormField(
          controller: controleurNom,
          style: kInputText,
          decoration: InputDecoration(
            filled: true,
            fillColor: kWhiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kInputFieldPadding,
              vertical: kInputFieldPadding,
            ),
          ),
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Veuillez entrer un nom';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Construit le champ description
  Widget _construireChampDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        TextFormField(
          controller: controleurDescription,
          style: kInputText,
          maxLines: kCreerClubDescriptionMaxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: kWhiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kInputFieldPadding,
              vertical: kInputFieldPadding,
            ),
          ),
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Veuillez entrer une description';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Construit le bouton créer
  Widget _construireBoutonCreer() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _enChargement ? null : _creerClub,
        style: ElevatedButton.styleFrom(
          backgroundColor: kWhiteColor,
          foregroundColor: kMainButtonColor,
          padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
          ),
        ),
        child: _enChargement
            ? const CircularProgressIndicator()
            : Text(
                'Créer le club',
                style: kProfileButtonText.copyWith(color: kMainButtonColor),
              ),
      ),
    );
  }

  /// Gère la création du club
  Future<void> _creerClub() async {
    if (_cleFormulaire.currentState!.validate()) {
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
        await FirebaseFirestoreService.creerClub(
          nom: controleurNom.text,
          description: controleurDescription.text,
          createurId: utilisateur.uid,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Club créé avec succès')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
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
  }
}
