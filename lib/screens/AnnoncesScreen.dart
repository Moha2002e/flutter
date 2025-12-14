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
// Import du contrôleur pour gérer les opérations sur les annonces
import '../controllers/annonce_controller.dart';
// Import du modèle Annonce pour typer les données
import '../models/annonce.dart';
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';
// Import de l'écran de création d'annonce
import 'CreerAnnonceScreen.dart';
// Import de l'écran de détails d'annonce
import 'AnnonceDetailScreen.dart';

/// Écran affichant la liste des annonces
/// Permet de visualiser toutes les annonces et d'en créer de nouvelles
class AnnoncesScreen extends StatelessWidget {
  // Constructeur constant pour optimiser les performances
  const AnnoncesScreen({super.key});

  // Nom de la route pour la navigation
  static const String routeName = '/annonces';

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
                // Construction de la liste des annonces
                _construireListeAnnonces(),
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
          // Titre de l'écran "Annonces" avec style prédéfini
          const Text('Annonces', style: kAnnoncesScreenTitleText),
          // Bouton "+" pour ajouter une nouvelle annonce
          _construireBoutonAjouter(context),
        ],
      ),
    );
  }

  /// Construit le bouton ajouter
  /// Crée un bouton circulaire avec un "+" pour créer une nouvelle annonce
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
        () => Navigator.pushNamed(context, CreerAnnonceScreen.routeName),
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

  /// Construit la liste des annonces
  /// Utilise un StreamBuilder pour afficher les annonces en temps réel depuis Firestore
  Widget _construireListeAnnonces() {
    // Widget qui prend tout l'espace disponible verticalement
    return Expanded(
      // StreamBuilder qui écoute les changements de la liste d'annonces
      child: StreamBuilder<List<Annonce>>(
        // Stream qui émet la liste des annonces depuis Firestore
        stream: AnnonceController.obtenirToutesLesAnnoncesStream(),
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

          // Si une erreur est survenue lors de la récupération des annonces
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

          // Si aucune annonce n'est disponible ou la liste est vide
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Affiche un message indiquant qu'il n'y a pas d'annonces
            return const Center(
              // Texte informatif
              child: Text(
                'Aucune annonce disponible',
                // Style de texte en blanc
                style: TextStyle(color: kWhiteColor),
              ),
            );
          }

          // Récupère la liste des annonces depuis les données du snapshot
          final annonces = snapshot.data!;

          // Construit une liste défilable avec un builder pour optimiser les performances
          return ListView.builder(
            // Padding horizontal pour espacer les éléments des bords
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            // Nombre d'éléments dans la liste
            itemCount: annonces.length,
            // Builder qui crée chaque élément de la liste
            itemBuilder: (context, index) {
              // Construit une carte pour chaque annonce
              return _construireCarteAnnonce(context, annonces[index]);
            },
          );
        },
      ),
    );
  }

  /// Construit une carte d'annonce
  /// Crée un conteneur avec les informations de l'annonce et un bouton pour voir les détails
  Widget _construireCarteAnnonce(BuildContext context, Annonce annonce) {
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
        // Colonne pour organiser le contenu verticalement
        child: Column(
          // Alignement du contenu à gauche
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne horizontale pour organiser le contenu et le bouton
            Row(
              // Alignement vertical en haut
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contenu de l'annonce qui prend l'espace disponible
                Expanded(child: _construireContenuAnnonce(annonce)),
                // Espacement horizontal entre le contenu et le bouton
                const SizedBox(width: kSmallSpace),
                // Bouton pour voir les détails de l'annonce
                _construireBoutonVoir(context, annonce.id),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le contenu de la carte (nom, description, infos)
  /// Affiche les informations principales de l'annonce dans la carte
  Widget _construireContenuAnnonce(Annonce annonce) {
    // Colonne pour organiser les informations verticalement
    return Column(
      // Alignement du contenu à gauche
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de l'annonce avec style prédéfini
        Text(annonce.nom, style: kAnnonceCardTitleText),
        // Espacement vertical après le titre
        const SizedBox(height: kSpacingAfterAnnonceCardTitle),
        // Description de l'annonce
        Text(
          // Texte de la description
          annonce.description,
          // Style de texte pour la description
          style: kAnnonceCardDescriptionText,
          // Limite à 2 lignes maximum
          maxLines: 2,
          // Affiche "..." si le texte dépasse 2 lignes
          overflow: TextOverflow.ellipsis,
        ),
        // Espacement vertical après la description
        const SizedBox(height: kSpacingAfterAnnonceCardDescription),
        // Ligne horizontale pour afficher la date et la catégorie côte à côte
        Row(
          children: [
            // Date formatée de l'annonce
            Text(annonce.dateFormatee, style: kAnnonceCardInfoText),
            // Espacement horizontal entre la date et la catégorie
            const SizedBox(width: kSmallSpace),
            // Catégorie de l'annonce
            Text(annonce.categorie, style: kAnnonceCardInfoText),
          ],
        ),
      ],
    );
  }

  /// Construit le bouton "Voir"
  /// Crée un bouton pour naviguer vers l'écran de détails de l'annonce
  Widget _construireBoutonVoir(BuildContext context, String annonceId) {
    // Bouton élevé Material Design
    return ElevatedButton(
      // Action à exécuter lors du clic
      onPressed: () {
        // Navigation vers l'écran de détails avec l'ID de l'annonce
        Navigator.pushNamed(context, AnnonceDetailScreen.routeName, arguments: annonceId);
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
          horizontal: kAnnonceCardButtonHorizontalPadding,
          // Padding vertical
          vertical: kAnnonceCardButtonVerticalPadding,
        ),
        // Forme du bouton avec coins arrondis
        shape: RoundedRectangleBorder(
          // Rayon des coins arrondis
          borderRadius: BorderRadius.circular(kAnnonceCardButtonBorderRadius),
        ),
      ),
      // Texte affiché sur le bouton
      child: const Text('Voir', style: kAnnonceCardButtonText),
    );
  }
}


