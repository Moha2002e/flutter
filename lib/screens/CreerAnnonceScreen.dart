import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_firestore.dart';
import '../services/firebase_auth.dart';

/// Écran pour créer une nouvelle annonce
class CreerAnnonceScreen extends StatefulWidget {
  const CreerAnnonceScreen({super.key});

  static const String routeName = '/creer-annonce';

  @override
  State<CreerAnnonceScreen> createState() => _CreerAnnonceScreenState();
}

class _CreerAnnonceScreenState extends State<CreerAnnonceScreen> {
  final TextEditingController controleurNom = TextEditingController();
  final TextEditingController controleurDescription = TextEditingController();
  final TextEditingController controleurDate = TextEditingController();
  final TextEditingController controleurCategorie = TextEditingController();
  final _cleFormulaire = GlobalKey<FormState>();
  bool _enChargement = false;
  DateTime? _dateSelectionnee;
  String? _categorieSelectionnee;

  // Liste des catégories disponibles
  final List<String> _categories = [
    'Vente',
    'Location',
    'Emploi',
    'Services',
    'Autre',
  ];

  @override
  void dispose() {
    controleurNom.dispose();
    controleurDescription.dispose();
    controleurDate.dispose();
    controleurCategorie.dispose();
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
                  const Text('Ajouter annonce', style: kCreerAnnonceTitleText),
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
            _construireChampCategorie(),
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

  /// Construit le champ nom de l'annonce
  Widget _construireChampNom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nom de l\'annonce', style: kLabelText),
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

  /// Construit le champ catégorie
  Widget _construireChampCategorie() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Catégorie', style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        DropdownButtonFormField<String>(
          value: _categorieSelectionnee,
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
          style: kInputText,
          icon: Icon(
            Icons.arrow_drop_down,
            size: kDropdownIconSize,
            color: Colors.black54,
          ),
          items: _categories.map((categorie) {
            return DropdownMenuItem<String>(
              value: categorie,
              child: Text(categorie),
            );
          }).toList(),
          onChanged: (valeur) {
            setState(() {
              _categorieSelectionnee = valeur;
              controleurCategorie.text = valeur ?? '';
            });
          },
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Veuillez sélectionner une catégorie';
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
          maxLines: kCreerAnnonceDescriptionMaxLines,
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
        onPressed: _enChargement ? null : _creerAnnonce,
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

  /// Gère la création de l'annonce
  Future<void> _creerAnnonce() async {
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
        await FirebaseFirestoreService.creerAnnonce(
          nom: controleurNom.text,
          description: controleurDescription.text,
          date: _dateSelectionnee,
          categorie: _categorieSelectionnee ?? '',
          createurId: utilisateur.uid,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Annonce créée avec succès')),
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


