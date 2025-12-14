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
// Import du modèle Club pour typer les données
import '../models/club.dart';
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';
// Import du contrôleur pour gérer les opérations sur les clubs
import '../controllers/club_controller.dart';
// Import de l'écran de modification de club
import 'ModifierClubScreen.dart';

/// Écran de détails d'un club
/// Affiche toutes les informations d'un club et permet de le rejoindre/quitter, modifier ou supprimer si l'utilisateur est le créateur
class ClubDetailScreen extends StatefulWidget {
  // Constructeur avec l'ID du club requis
  const ClubDetailScreen({super.key, required this.clubId});

  // ID du club à afficher
  final String clubId;

  // Nom de la route pour la navigation
  static const String routeName = '/club-detail';

  // Crée l'état associé à ce widget
  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

// Classe d'état privée pour gérer l'état de l'écran
class _ClubDetailScreenState extends State<ClubDetailScreen> {
  // Variable d'état pour indiquer si une opération est en cours
  bool _enChargement = false;
  // Variable d'état pour indiquer si l'utilisateur est membre du club (null = non vérifié)
  bool? _estMembre;

  // Méthode appelée lors de l'initialisation du widget
  @override
  void initState() {
    // Appelle la méthode initState de la classe parente
    super.initState();
    // Vérifie si l'utilisateur est membre du club au démarrage
    _verifierMembre();
  }

  /// Vérifie si l'utilisateur est membre du club
  /// Méthode asynchrone qui interroge Firestore pour vérifier l'adhésion
  Future<void> _verifierMembre() async {
    // Récupère l'utilisateur actuellement connecté
    final utilisateur = FirebaseAuthService.currentUser;
    // Vérifie si un utilisateur est connecté
    if (utilisateur != null) {
      // Vérifie si l'utilisateur est membre du club via le contrôleur
      final estMembre = await ClubController.checkMembership(
        // ID du club à vérifier
        widget.clubId,
        // ID de l'utilisateur
        utilisateur.uid,
      );
      // Met à jour l'état seulement si le widget est encore monté
      if (mounted) {
        // Met à jour l'état avec le résultat de la vérification
        setState(() => _estMembre = estMembre);
      }
    }
  }

  /// Gère l'adhésion ou le départ du club
  /// Méthode asynchrone qui permet à un utilisateur de rejoindre ou quitter un club
  Future<void> _gererAdhesion() async {
    // Vérifie si l'utilisateur est en mode invité
    if (isGuest()) {
      // Affiche un message indiquant que la fonctionnalité est réservée aux membres
      showGuestMessage(context);
      // Sort de la méthode sans exécuter le reste
      return;
    }
    
    // Récupère l'utilisateur actuellement connecté
    final utilisateur = FirebaseAuthService.currentUser;
    // Si aucun utilisateur n'est connecté, sort de la méthode
    if (utilisateur == null) return;

    // Appelle le contrôleur pour rejoindre ou quitter le club
    await ClubController.toggleMembership(
      // Contexte de l'application
      context: context,
      // ID du club
      clubId: widget.clubId,
      // Indique si l'utilisateur est actuellement membre (true = quitter, false = rejoindre)
      isMember: _estMembre == true,
      // Callback pour mettre à jour l'état de chargement
      setLoading: (loading) {
        // Met à jour l'état seulement si le widget est encore monté
        if (mounted) {
          // Met à jour l'état de chargement
          setState(() => _enChargement = loading);
        }
      },
      // Callback pour mettre à jour le statut de membre
      setMemberStatus: (isMember) {
        // Met à jour l'état seulement si le widget est encore monté
        if (mounted) {
          // Met à jour le statut de membre
          setState(() => _estMembre = isMember);
        }
      },
    );
    
    // Vérifie à nouveau le statut de membre pour s'assurer de la cohérence
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
