import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_firestore.dart';
import '../services/firebase_auth.dart';

/// Écran pour créer un nouvel événement
class CreerEvenementScreen extends StatefulWidget {
  const CreerEvenementScreen({super.key});

  static const String routeName = '/creer-evenement';

  @override
  State<CreerEvenementScreen> createState() => _CreerEvenementScreenState();
}

class _CreerEvenementScreenState extends State<CreerEvenementScreen> {
  final TextEditingController controleurNom = TextEditingController();
  final TextEditingController controleurDescription = TextEditingController();
  final TextEditingController controleurDate = TextEditingController();
  final TextEditingController controleurLieu = TextEditingController();
  final _cleFormulaire = GlobalKey<FormState>();
  bool _enChargement = false;
  DateTime? _dateSelectionnee;

  @override
  void dispose() {
    controleurNom.dispose();
    controleurDescription.dispose();
    controleurDate.dispose();
    controleurLieu.dispose();
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
                  const Text('Ajouter evenement', style: kCreerEvenementTitleText),
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
            _construireChampDate(),
            const SizedBox(height: kSpacingBetweenFields),
            _construireChampLieu(),
            const SizedBox(height: kSpacingBetweenFields),
            _construireChampDescription(),
            const SizedBox(height: kSpacingBeforeButton),
            _construireBoutonAjouter(),
            const SizedBox(height: kSpacingBottomForm),
          ],
        ),
      ),
    );
  }

  /// Construit le champ nom de l'événement
  Widget _construireChampNom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nom de l\'evenement', style: kLabelText),
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

  /// Construit le champ date
  Widget _construireChampDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date', style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        TextFormField(
          controller: controleurDate,
          style: kInputText,
          readOnly: true,
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
            suffixIcon: Icon(
              Icons.calendar_today,
              size: kDatePickerIconSize,
              color: Colors.black54,
            ),
          ),
          onTap: () {
            _selectionnerDate();
          },
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Veuillez sélectionner une date';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Construit le champ lieu
  Widget _construireChampLieu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lieu', style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        TextFormField(
          controller: controleurLieu,
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
              return 'Veuillez entrer un lieu';
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
          maxLines: kCreerEvenementDescriptionMaxLines,
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

  /// Construit le bouton ajouter
  Widget _construireBoutonAjouter() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _enChargement ? null : _creerEvenement,
        style: ElevatedButton.styleFrom(
          backgroundColor: kLoginButtonColor,
          foregroundColor: kWhiteColor,
          padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
          ),
        ),
        child: _enChargement
            ? const CircularProgressIndicator(color: kWhiteColor)
            : const Text(
                'Ajouter',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  /// Sélectionne une date
  Future<void> _selectionnerDate() async {
    final DateTime? dateChoisie = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
    );

    if (dateChoisie != null) {
      setState(() {
        _dateSelectionnee = dateChoisie;
        controleurDate.text = DateFormat('MM/dd/yyyy').format(dateChoisie);
      });
    }
  }

  /// Gère la création de l'événement
  Future<void> _creerEvenement() async {
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
        await FirebaseFirestoreService.creerEvenement(
          nom: controleurNom.text,
          description: controleurDescription.text,
          date: _dateSelectionnee,
          lieu: controleurLieu.text,
          createurId: utilisateur.uid,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Événement créé avec succès')),
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


