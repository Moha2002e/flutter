// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import de Cloud Firestore pour les types de données Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';
// Import des styles de texte prédéfinis
import '../styles/texts.dart';
// Import du service d'authentification Firebase
import '../services/firebase_auth.dart';
// Import du modèle Cours pour typer les données
import '../models/cours.dart';
// Import du contrôleur pour gérer les opérations sur les cours
import '../controllers/cours_controller.dart';
// Import de l'écran de modification de cours
import 'ModifierCoursScreen.dart';

/// Écran de détails d'un cours
/// Affiche toutes les informations d'un cours et permet de le modifier ou supprimer si l'utilisateur est le créateur
class CoursDetailScreen extends StatefulWidget {
  // Constructeur avec l'ID du cours requis
  const CoursDetailScreen({super.key, required this.coursId});

  // ID du cours à afficher
  final String coursId;

  // Nom de la route pour la navigation
  static const String routeName = '/cours-detail';

  // Crée l'état associé à ce widget
  @override
  State<CoursDetailScreen> createState() => _CoursDetailScreenState();
}

// Classe d'état privée pour gérer l'état de l'écran
class _CoursDetailScreenState extends State<CoursDetailScreen> {
  // Variable d'état pour indiquer si une opération est en cours
  bool _enChargement = false;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Retourne un Scaffold qui est la structure de base d'un écran Material Design
    return Scaffold(
      // Corps de l'écran
      body: SizedBox.expand(
        // Widget qui prend toute la taille disponible
        child: DecoratedBox(
          // Décorateur pour appliquer un dégradé de fond
          decoration: const BoxDecoration(
            // Application du dégradé de fond défini dans les styles
            gradient: kBackgroundGradient,
          ),
          // Zone sécurisée qui évite les zones système (notch, barre de statut)
          child: SafeArea(
            // StreamBuilder qui écoute les changements du cours en temps réel
            child: StreamBuilder<Cours?>(
              // Stream qui émet le cours depuis Firestore selon son ID
              stream: CoursController.obtenirCoursParIdStream(widget.coursId),
              // Builder qui construit l'UI selon l'état du stream
              builder: (context, snapshot) {
                // Si les données sont en cours de chargement
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Affiche un indicateur de chargement centré
                  return const Center(
                    // Indicateur circulaire de progression en blanc
                    child: CircularProgressIndicator(color: kWhiteColor),
                  );
                }

                // Si une erreur est survenue ou le cours n'existe pas
                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  // Affiche l'écran d'erreur
                  return _construireErreur(context);
                }

                // Récupère le cours depuis les données du snapshot
                final cours = snapshot.data!;
                // Récupère l'utilisateur actuellement connecté
                final utilisateur = FirebaseAuthService.currentUser;
                // Vérifie si l'utilisateur connecté est le créateur du cours
                final estCreateur = utilisateur != null && cours.createurId == utilisateur.uid;

                // Retourne une colonne avec l'en-tête et la carte du cours
                return Column(
                  children: [
                    // Construction de l'en-tête avec bouton retour et titre
                    _construireEnTete(context, cours.nom),
                    // Espacement vertical après l'en-tête
                    const SizedBox(height: kSpacingAfterHeader),
                    // Construction de la carte avec le contenu du cours
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

