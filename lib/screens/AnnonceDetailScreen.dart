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
// Import du modèle Annonce pour typer les données
import '../models/annonce.dart';
// Import du contrôleur pour gérer les opérations sur les annonces
import '../controllers/annonce_controller.dart';
// Import de l'écran de modification d'annonce
import 'ModifierAnnonceScreen.dart';

/// Écran de détails d'une annonce
/// Affiche toutes les informations d'une annonce et permet de la modifier ou supprimer si l'utilisateur est le créateur
class AnnonceDetailScreen extends StatefulWidget {
  // Constructeur avec l'ID de l'annonce requis
  const AnnonceDetailScreen({super.key, required this.annonceId});

  // ID de l'annonce à afficher
  final String annonceId;

  // Nom de la route pour la navigation
  static const String routeName = '/annonce-detail';

  // Crée l'état associé à ce widget
  @override
  State<AnnonceDetailScreen> createState() => _AnnonceDetailScreenState();
}

// Classe d'état privée pour gérer l'état de l'écran
class _AnnonceDetailScreenState extends State<AnnonceDetailScreen> {
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
            // StreamBuilder qui écoute les changements de l'annonce en temps réel
            child: StreamBuilder<Annonce?>(
              // Stream qui émet l'annonce depuis Firestore selon son ID
              stream: AnnonceController.obtenirAnnonceParIdStream(widget.annonceId),
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

                // Si une erreur est survenue ou l'annonce n'existe pas
                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  // Affiche l'écran d'erreur
                  return _construireErreur(context);
                }

                // Récupère l'annonce depuis les données du snapshot
                final annonce = snapshot.data!;
                // Récupère l'utilisateur actuellement connecté
                final utilisateur = FirebaseAuthService.currentUser;
                // Vérifie si l'utilisateur connecté est le créateur de l'annonce
                final estCreateur = utilisateur != null && annonce.createurId == utilisateur.uid;

                // Retourne une colonne avec l'en-tête et la carte de l'annonce
                return Column(
                  children: [
                    // Construction de l'en-tête avec bouton retour et titre
                    _construireEnTete(context, annonce.nom),
                    // Espacement vertical après l'en-tête
                    const SizedBox(height: kSpacingAfterHeader),
                    // Construction de la carte avec le contenu de l'annonce
                    _construireCarteAnnonce(annonce, estCreateur),
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
  /// Crée la barre d'en-tête avec un bouton retour et le nom de l'annonce
  Widget _construireEnTete(BuildContext context, String nomAnnonce) {
    // Retourne un widget Padding pour ajouter de l'espace autour
    return Padding(
      // Padding horizontal uniforme autour de l'en-tête
      padding: const EdgeInsets.all(kHorizontalPadding),
      // Colonne pour organiser les éléments verticalement
      child: Column(
        children: [
          // Alignement du bouton retour en haut à gauche
          Align(
            // Alignement en haut à gauche
            alignment: Alignment.topLeft,
            // Widget qui détecte les gestes de tap
            child: GestureDetector(
              // Action à exécuter lors du tap : retour à l'écran précédent
              onTap: () {
                // Retourne à l'écran précédent dans la pile de navigation
                Navigator.pop(context);
              },
              // Conteneur circulaire pour le bouton retour
              child: Container(
                // Largeur du bouton (carré)
                width: kBackButtonSize,
                // Hauteur du bouton (carré)
                height: kBackButtonSize,
                // Décoration du conteneur
                decoration: const BoxDecoration(
                  // Fond blanc
                  color: kWhiteColor,
                  // Forme circulaire
                  shape: BoxShape.circle,
                ),
                // Icône de flèche retour
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
          // Espacement vertical après le bouton retour
          const SizedBox(height: kSpacingAfterBackButton),
          // Titre de l'annonce centré avec style prédéfini
          Text(nomAnnonce, style: kAnnonceDetailTitleText, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Construit la carte blanche avec le contenu de l'annonce
  /// Crée un conteneur scrollable avec toutes les informations de l'annonce
  Widget _construireCarteAnnonce(Annonce annonce, bool estCreateur) {
    // Widget qui limite la hauteur maximale de la carte
    return ConstrainedBox(
      // Contraintes de taille
      constraints: BoxConstraints(
        // Hauteur maximale basée sur la hauteur de l'écran
        maxHeight: MediaQuery.of(context).size.height * kDetailScreenMaxHeightRatio,
      ),
      // Conteneur principal de la carte
      child: Container(
        // Marge horizontale pour espacer la carte des bords
        margin: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        // Décoration de la carte
        decoration: BoxDecoration(
          // Fond blanc pour la carte
          color: kWhiteColor,
          // Coins arrondis pour un design moderne
          borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
        ),
        // Zone scrollable pour le contenu
        child: SingleChildScrollView(
          // Padding interne du contenu
          padding: const EdgeInsets.all(kInputFieldPadding),
          // Colonne pour organiser le contenu verticalement
          child: Column(
            // Alignement du contenu à gauche
            crossAxisAlignment: CrossAxisAlignment.start,
            // Taille minimale de la colonne
            mainAxisSize: MainAxisSize.min,
            children: [
              // Section avec l'icône et le nom de l'annonce
              _construireSectionImageEtNom(annonce.nom),
              // Espacement vertical entre les sections
              const SizedBox(height: kSpacingBetweenFields),
              // Section avec les informations de l'annonce (date, catégorie)
              _construireInfosAnnonce(annonce),
              // Espacement vertical entre les sections
              const SizedBox(height: kSpacingBetweenFields),
              // Section avec la description de l'annonce
              _construireDescription(annonce.description),
              // Affiche les boutons Modifier/Supprimer uniquement si l'utilisateur est le créateur
              if (estCreateur) ...[
                // Espacement vertical avant les boutons
                const SizedBox(height: kSpacingBeforeButton),
                // Boutons pour modifier et supprimer l'annonce
                _construireBoutonsModifierSupprimer(annonce),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Construit les boutons Modifier et Supprimer
  Widget _construireBoutonsModifierSupprimer(Annonce annonce) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _modifierAnnonce(annonce),
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
                : const Text('Modifier', style: kAnnonceDetailInfoText),
          ),
        ),
        const SizedBox(width: kSpacingBetweenFields),
        Expanded(
          child: ElevatedButton(
            onPressed: _enChargement ? null : () => _supprimerAnnonce(),
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
                : const Text('Supprimer', style: kAnnonceDetailInfoText),
          ),
        ),
      ],
    );
  }

  /// Modifie l'annonce
  Future<void> _modifierAnnonce(Annonce annonce) async {
    final result = await Navigator.pushNamed(
      context,
      ModifierAnnonceScreen.routeName,
      arguments: annonce,
    );
    if (result == true && mounted) {
      setState(() {});
    }
  }

  /// Supprime l'annonce
  Future<void> _supprimerAnnonce() async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette annonce ?'),
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
      final success = await AnnonceController.deleteAnnonce(
        context: context,
        annonceId: widget.annonceId,
        setLoading: (loading) {
          if (mounted) setState(() => _enChargement = loading);
        },
      );
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  /// Construit la section avec l'image et le nom de l'annonce
  Widget _construireSectionImageEtNom(String nomAnnonce) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: kAnnonceDetailAvatarSize,
          height: kAnnonceDetailAvatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kMainButtonColor.withOpacity(kClubCardAvatarOpacity),
          ),
          child: Icon(
            Icons.announcement,
            size: kAnnonceDetailAvatarIconSize,
            color: kMainButtonColor,
          ),
        ),
        const SizedBox(width: kSmallSpace),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: kAnnonceDetailCardTitleTopPadding),
            child: Text(nomAnnonce, style: kAnnonceDetailCardTitleText),
          ),
        ),
      ],
    );
  }

  /// Construit les informations de l'annonce
  Widget _construireInfosAnnonce(Annonce annonce) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _construireInfo('Date', annonce.dateFormatee),
        const SizedBox(height: kSpacingBetweenFields),
        _construireInfo('Catégorie', annonce.categorie),
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
        Text(valeur, style: kAnnonceDetailInfoText),
      ],
    );
  }

  /// Construit la description de l'annonce
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
        Text(description, style: kAnnonceDetailDescriptionText),
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
              'Annonce introuvable',
              style: TextStyle(color: kWhiteColor),
            ),
          ),
        ),
      ],
    );
  }
}

