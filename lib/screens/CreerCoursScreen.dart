import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_firestore.dart';
import '../services/firebase_auth.dart';

/// Écran pour créer un nouveau cours
class CreerCoursScreen extends StatefulWidget {
  const CreerCoursScreen({super.key});

  static const String routeName = '/creer-cours';

  @override
  State<CreerCoursScreen> createState() => _CreerCoursScreenState();
}

class _CreerCoursScreenState extends State<CreerCoursScreen> {
  final TextEditingController controleurDate = TextEditingController();
  final _cleFormulaire = GlobalKey<FormState>();
  bool _enChargement = false;
  DateTime? _dateSelectionnee;
  String? _nomCoursSelectionne;
  String? _nomProfSelectionne;
  String? _localSelectionne;

  // Liste des cours disponibles
  final List<String> _cours = [
    'Mathématiques',
    'Physique',
    'Chimie',
    'Informatique',
    'Anglais',
    'Français',
    'Histoire',
    'Géographie',
  ];

  // Liste des professeurs disponibles
  final List<String> _professeurs = [
    'M. Dupont',
    'Mme Martin',
    'M. Bernard',
    'Mme Dubois',
    'M. Leroy',
    'Mme Moreau',
  ];

  // Liste des locaux disponibles
  final List<String> _locaux = [
    'Salle 101',
    'Salle 102',
    'Salle 201',
    'Salle 202',
    'Amphithéâtre A',
    'Amphithéâtre B',
    'Laboratoire 1',
    'Laboratoire 2',
  ];

  @override
  void dispose() {
    controleurDate.dispose();
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
                  const Text('Ajouter cours', style: kCreerCoursTitleText),
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
            _construireChampNomCours(),
            const SizedBox(height: kSpacingBetweenFields),
            _construireChampDate(),
            const SizedBox(height: kSpacingBetweenFields),
            _construireChampNomProf(),
            const SizedBox(height: kSpacingBetweenFields),
            _construireChampLocal(),
            const SizedBox(height: kSpacingBeforeButton),
            _construireBoutonAjouter(),
            const SizedBox(height: kSpacingBottomForm),
          ],
        ),
      ),
    );
  }

  /// Construit le champ nom du cours
  Widget _construireChampNomCours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nom du cours', style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        DropdownButtonFormField<String>(
          value: _nomCoursSelectionne,
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
          items: _cours.map((cours) {
            return DropdownMenuItem<String>(
              value: cours,
              child: Text(cours),
            );
          }).toList(),
          onChanged: (valeur) {
            setState(() {
              _nomCoursSelectionne = valeur;
            });
          },
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Veuillez sélectionner un cours';
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

  /// Construit le champ nom du prof
  Widget _construireChampNomProf() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nom du prof', style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        DropdownButtonFormField<String>(
          value: _nomProfSelectionne,
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
          items: _professeurs.map((prof) {
            return DropdownMenuItem<String>(
              value: prof,
              child: Text(prof),
            );
          }).toList(),
          onChanged: (valeur) {
            setState(() {
              _nomProfSelectionne = valeur;
            });
          },
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Veuillez sélectionner un professeur';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Construit le champ local
  Widget _construireChampLocal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Local', style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        DropdownButtonFormField<String>(
          value: _localSelectionne,
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
          items: _locaux.map((local) {
            return DropdownMenuItem<String>(
              value: local,
              child: Text(local),
            );
          }).toList(),
          onChanged: (valeur) {
            setState(() {
              _localSelectionne = valeur;
            });
          },
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Veuillez sélectionner un local';
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
        onPressed: _enChargement ? null : _creerCours,
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

  /// Gère la création du cours
  Future<void> _creerCours() async {
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
        await FirebaseFirestoreService.creerCours(
          nom: _nomCoursSelectionne ?? '',
          date: _dateSelectionnee,
          nomProf: _nomProfSelectionne ?? '',
          local: _localSelectionne ?? '',
          createurId: utilisateur.uid,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cours créé avec succès')),
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


