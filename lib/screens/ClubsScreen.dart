// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';

// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';
// Import des styles de texte prédéfinis
import '../styles/texts.dart';
// Import du contrôleur pour gérer les opérations sur les clubs
import '../controllers/club_controller.dart';
// Import du modèle Club pour typer les données
import '../models/club.dart';
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';
// Import de l'écran de création de club
import 'CreerClubScreen.dart';
// Import de l'écran de détails de club
import 'ClubDetailScreen.dart';

/// Écran affichant la liste des clubs
/// Permet de visualiser tous les clubs et d'en créer de nouveaux
class ClubsScreen extends StatelessWidget {
  // Constructeur constant pour optimiser les performances
  const ClubsScreen({super.key});

  // Nom de la route pour la navigation
  static const String routeName = '/clubs';

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
            // Colonne verticale pour organiser les éléments
            child: Column(
              children: [
                // Construction de l'en-tête avec titre et bouton ajouter
                _construireEnTete(context),
                // Espacement vertical après l'en-tête
                const SizedBox(height: kSpacingAfterHeader),
                // Construction de la liste des clubs
                _construireListeClubs(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit l'en-tête avec titre et bouton ajouter
  /// Méthode privée qui crée la barre d'en-tête de l'écran
  Widget _construireEnTete(BuildContext context) {
    // Retourne un widget Padding pour ajouter de l'espace autour
    return Padding(
      // Padding horizontal uniforme autour de l'en-tête
      padding: const EdgeInsets.all(kHorizontalPadding),
      // Ligne horizontale pour organiser les éléments côte à côte
      child: Row(
        // Alignement des éléments : espacement égal entre eux
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Espace vide à gauche pour équilibrer le layout (compense le bouton à droite)
          const SizedBox(width: kBackButtonSize),
          // Titre de l'écran "Clubs" avec style prédéfini
          const Text('Clubs', style: kClubsScreenTitleText),
          // Bouton "+" pour ajouter un nouveau club
          _construireBoutonAjouter(context),
        ],
      ),
    );
  }

  /// Construit le bouton ajouter
  /// Crée un bouton circulaire avec un "+" pour créer un nouveau club
  Widget _construireBoutonAjouter(BuildContext context) {
    // Récupère le style du bouton selon le mode invité (opacité et couleur)
    final style = getGuestButtonStyle();
    // Widget qui détecte les gestes de tap
    return GestureDetector(
      // Action à exécuter lors du tap
      onTap: () => handleGuestAction(
        // Contexte de l'application
        context,
        // Fonction à exécuter si l'utilisateur n'est pas invité
        () => Navigator.pushNamed(context, CreerClubScreen.routeName),
      ),
      // Conteneur circulaire pour le bouton
      child: Container(
        // Largeur du bouton (carré)
        width: kBackButtonSize,
        // Hauteur du bouton (carré)
        height: kBackButtonSize,
        // Décoration du conteneur
        decoration: BoxDecoration(
          // Couleur blanche avec opacité selon le mode invité
          color: kWhiteColor.withOpacity(style['opacity'] as double),
          // Forme circulaire
          shape: BoxShape.circle,
        ),
        // Icône "+" avec couleur selon le mode invité
        child: Icon(Icons.add, color: style['color'] as Color),
      ),
    );
  }

  /// Construit la liste des clubs
  /// Utilise un StreamBuilder pour afficher les clubs en temps réel depuis Firestore
  Widget _construireListeClubs() {
    // Widget qui prend tout l'espace disponible verticalement
    return Expanded(
      // StreamBuilder qui écoute les changements de la liste de clubs
      child: StreamBuilder<List<Club>>(
        // Stream qui émet la liste des clubs depuis Firestore
        stream: ClubController.obtenirTousLesClubsStream(),
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

          // Si une erreur est survenue lors de la récupération des clubs
          if (snapshot.hasError) {
            // Affiche un message d'erreur centré
            return Center(
              // Texte d'erreur avec le message d'erreur
              child: Text(
                'Erreur: ${snapshot.error}',
                // Style de texte en blanc
                style: const TextStyle(color: kWhiteColor),
              ),
            );
          }

          // Si aucun club n'est disponible ou la liste est vide
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Affiche un message indiquant qu'il n'y a pas de clubs
            return const Center(
              // Texte informatif
              child: Text(
                'Aucun club disponible',
                // Style de texte en blanc
                style: TextStyle(color: kWhiteColor),
              ),
            );
          }

          // Récupère la liste des clubs depuis les données du snapshot
          final clubs = snapshot.data!;

          // Construit une liste défilable avec un builder pour optimiser les performances
          return ListView.builder(
            // Padding horizontal pour espacer les éléments des bords
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            // Nombre d'éléments dans la liste
            itemCount: clubs.length,
            // Builder qui crée chaque élément de la liste
            itemBuilder: (context, index) {
              // Construit une carte pour chaque club
              return _construireCarteClub(context, clubs[index]);
            },
          );
        },
      ),
    );
  }

  /// Construit une carte de club
  /// Crée un conteneur avec les informations du club et un bouton pour voir les détails
  Widget _construireCarteClub(BuildContext context, Club club) {
    // Conteneur principal de la carte
    return Container(
      // Marge en bas pour espacer les cartes entre elles
      margin: const EdgeInsets.only(bottom: kSmallSpace),
      // Décoration de la carte
      decoration: BoxDecoration(
        // Fond blanc pour la carte
        color: kWhiteColor,
        // Coins arrondis pour un design moderne
        borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
      ),
      // Padding à l'intérieur de la carte
      child: Padding(
        // Padding uniforme autour du contenu
        padding: const EdgeInsets.all(kInputFieldPadding),
        // Ligne horizontale pour organiser l'avatar, le contenu et le bouton
        child: Row(
          // Alignement vertical en haut
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar circulaire du club
            _construireAvatarClub(),
            // Espacement horizontal entre l'avatar et le contenu
            const SizedBox(width: kSmallSpace),
            // Contenu du club qui prend l'espace disponible
            Expanded(child: _construireContenuClub(club)),
            // Espacement horizontal entre le contenu et le bouton
            const SizedBox(width: kSmallSpace),
            // Bouton pour voir les détails du club
            _construireBoutonVoir(context, club.id),
          ],
        ),
      ),
    );
  }

  /// Construit l'avatar du club
  /// Crée un conteneur circulaire avec une icône de groupe
  Widget _construireAvatarClub() {
    // Conteneur pour l'avatar
    return Container(
      // Largeur de l'avatar (carré)
      width: kClubCardAvatarSize,
      // Hauteur de l'avatar (carré)
      height: kClubCardAvatarSize,
      // Décoration de l'avatar
      decoration: BoxDecoration(
        // Forme circulaire
        shape: BoxShape.circle,
        // Couleur de fond avec opacité
        color: kMainButtonColor.withOpacity(kClubCardAvatarOpacity),
      ),
      // Icône de groupe à l'intérieur
      child: Icon(
        // Icône Material Design pour représenter un groupe
        Icons.group,
        // Taille de l'icône
        size: kClubCardAvatarIconSize,
        // Couleur de l'icône (couleur principale)
        color: kMainButtonColor,
      ),
    );
  }

  /// Construit le contenu de la carte (nom, description, infos)
  /// Affiche les informations principales du club dans la carte
  Widget _construireContenuClub(Club club) {
    // Colonne pour organiser les informations verticalement
    return Column(
      // Alignement du contenu à gauche
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nom du club avec style prédéfini
        Text(club.nom, style: kClubCardTitleText),
        // Espacement vertical après le nom
        const SizedBox(height: kSpacingAfterClubCardTitle),
        // Description du club
        Text(
          // Texte de la description
          club.description,
          // Style de texte pour la description
          style: kClubCardDescriptionText,
          // Limite à 2 lignes maximum
          maxLines: 2,
          // Affiche "..." si le texte dépasse 2 lignes
          overflow: TextOverflow.ellipsis,
        ),
        // Espacement vertical après la description
        const SizedBox(height: kSpacingAfterClubCardDescription),
        // Ligne horizontale pour afficher le nombre de membres et la date côte à côte
        Row(
          children: [
            // Nombre de membres avec texte formaté
            Text('${club.nombreMembres} membres', style: kClubCardInfoText),
            // Espacement horizontal entre le nombre de membres et la date
            const SizedBox(width: kSmallSpace),
            // Date de création formatée du club
            Text(club.dateFormatee, style: kClubCardInfoText),
          ],
        ),
      ],
    );
  }

  /// Construit le bouton "Voir"
  /// Crée un bouton pour naviguer vers l'écran de détails du club
  Widget _construireBoutonVoir(BuildContext context, String clubId) {
    // Bouton élevé Material Design
    return ElevatedButton(
      // Action à exécuter lors du clic
      onPressed: () {
        // Navigation vers l'écran de détails avec l'ID du club
        Navigator.pushNamed(
          // Contexte de l'application
          context,
          // Nom de la route de l'écran de détails
          ClubDetailScreen.routeName,
          // Passage de l'ID du club comme argument
          arguments: clubId,
        );
      },
      // Style personnalisé du bouton
      style: ElevatedButton.styleFrom(
        // Couleur de fond du bouton (couleur principale de l'app)
        backgroundColor: kMainButtonColor,
        // Couleur du texte et de l'icône (blanc)
        foregroundColor: kWhiteColor,
        // Padding interne du bouton
        padding: const EdgeInsets.symmetric(
          // Padding horizontal
          horizontal: kClubCardButtonHorizontalPadding,
          // Padding vertical
          vertical: kClubCardButtonVerticalPadding,
        ),
        // Forme du bouton avec coins arrondis
        shape: RoundedRectangleBorder(
          // Rayon des coins arrondis
          borderRadius: BorderRadius.circular(kClubCardButtonBorderRadius),
        ),
      ),
      // Texte affiché sur le bouton
      child: const Text('Voir', style: kClubCardButtonText),
    );
  }
}
