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
// Import du modèle Evenement pour typer les données
import '../models/evenement.dart';
// Import du contrôleur pour gérer les opérations sur les événements
import '../controllers/evenement_controller.dart';
// Import de l'écran de modification d'événement
import 'ModifierEvenementScreen.dart';

/// Écran de détails d'un événement
/// Affiche toutes les informations d'un événement et permet de le modifier ou supprimer si l'utilisateur est le créateur
class EvenementDetailScreen extends StatefulWidget {
  // Constructeur avec l'ID de l'événement requis
  const EvenementDetailScreen({super.key, required this.evenementId});

  // ID de l'événement à afficher
  final String evenementId;

  // Nom de la route pour la navigation
  static const String routeName = '/evenement-detail';

  // Crée l'état associé à ce widget
  @override
  State<EvenementDetailScreen> createState() => _EvenementDetailScreenState();
}

// Classe d'état privée pour gérer l'état de l'écran
class _EvenementDetailScreenState extends State<EvenementDetailScreen> {
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
            // StreamBuilder qui écoute les changements de l'événement en temps réel
            child: StreamBuilder<Evenement?>(
              // Stream qui émet l'événement depuis Firestore selon son ID
              stream: EvenementController.obtenirEvenementParIdStream(widget.evenementId),
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

                // Si une erreur est survenue ou l'événement n'existe pas
                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  // Affiche l'écran d'erreur
                  return _construireErreur(context);
                }

                // Récupère l'événement depuis les données du snapshot
                final evenement = snapshot.data!;
                // Récupère l'utilisateur actuellement connecté
                final utilisateur = FirebaseAuthService.currentUser;
                // Vérifie si l'utilisateur connecté est le créateur de l'événement
                final estCreateur = utilisateur != null && evenement.createurId == utilisateur.uid;

                // Retourne une colonne avec l'en-tête et la carte de l'événement
                return Column(
                  children: [
                    // Construction de l'en-tête avec bouton retour et titre
                    _construireEnTete(context, evenement.nom),
                    // Espacement vertical après l'en-tête
                    const SizedBox(height: kSpacingAfterHeader),
                    // Construction de la carte avec le contenu de l'événement
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
    Navigator.pushNamed(
      context,
      ModifierEvenementScreen.routeName,
      arguments: evenement,
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

