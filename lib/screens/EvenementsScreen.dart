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
// Import du contrôleur pour gérer les opérations sur les événements
import '../controllers/evenement_controller.dart';
// Import du modèle Evenement pour typer les données
import '../models/evenement.dart';
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';
// Import de l'écran de création d'événement
import 'CreerEvenementScreen.dart';
// Import de l'écran de détails d'événement
import 'EvenementDetailScreen.dart';

/// Écran affichant la liste des événements
/// Permet de visualiser tous les événements et d'en créer de nouveaux
class EvenementsScreen extends StatelessWidget {
  // Constructeur constant pour optimiser les performances
  const EvenementsScreen({super.key});

  // Nom de la route pour la navigation
  static const String routeName = '/evenements';

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
                // Construction de la liste des événements
                _construireListeEvenements(),
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
          // Titre de l'écran "Événements" avec style prédéfini
          const Text('Événements', style: kEvenementsScreenTitleText),
          // Bouton "+" pour ajouter un nouvel événement
          _construireBoutonAjouter(context),
        ],
      ),
    );
  }

  /// Construit le bouton ajouter
  /// Crée un bouton circulaire avec un "+" pour créer un nouvel événement
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
        () => Navigator.pushNamed(context, CreerEvenementScreen.routeName),
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

  /// Construit la liste des événements
  /// Utilise un StreamBuilder pour afficher les événements en temps réel depuis Firestore
  Widget _construireListeEvenements() {
    // Widget qui prend tout l'espace disponible verticalement
    return Expanded(
      // StreamBuilder qui écoute les changements de la liste d'événements
      child: StreamBuilder<List<Evenement>>(
        // Stream qui émet la liste des événements depuis Firestore
        stream: EvenementController.obtenirTousLesEvenementsStream(),
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

          // Si une erreur est survenue lors de la récupération des événements
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

          // Si aucun événement n'est disponible ou la liste est vide
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Affiche un message indiquant qu'il n'y a pas d'événements
            return const Center(
              // Texte informatif
              child: Text(
                'Aucun événement disponible',
                // Style de texte en blanc
                style: TextStyle(color: kWhiteColor),
              ),
            );
          }

          // Récupère la liste des événements depuis les données du snapshot
          final evenements = snapshot.data!;

          // Construit une liste défilable avec un builder pour optimiser les performances
          return ListView.builder(
            // Padding horizontal pour espacer les éléments des bords
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            // Nombre d'éléments dans la liste
            itemCount: evenements.length,
            // Builder qui crée chaque élément de la liste
            itemBuilder: (context, index) {
              // Construit une carte pour chaque événement
              return _construireCarteEvenement(context, evenements[index]);
            },
          );
        },
      ),
    );
  }

  /// Construit une carte d'événement
  /// Crée un conteneur avec les informations de l'événement et un bouton pour voir les détails
  Widget _construireCarteEvenement(BuildContext context, Evenement evenement) {
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
                // Contenu de l'événement qui prend l'espace disponible
                Expanded(child: _construireContenuEvenement(evenement)),
                // Espacement horizontal entre le contenu et le bouton
                const SizedBox(width: kSmallSpace),
                // Bouton pour voir les détails de l'événement
                _construireBoutonVoir(context, evenement.id),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le contenu de la carte (nom, description, infos)
  /// Affiche les informations principales de l'événement dans la carte
  Widget _construireContenuEvenement(Evenement evenement) {
    // Colonne pour organiser les informations verticalement
    return Column(
      // Alignement du contenu à gauche
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nom de l'événement avec style prédéfini
        Text(evenement.nom, style: kEvenementCardTitleText),
        // Espacement vertical après le nom
        const SizedBox(height: kSpacingAfterEvenementCardTitle),
        // Description de l'événement
        Text(
          // Texte de la description
          evenement.description,
          // Style de texte pour la description
          style: kEvenementCardDescriptionText,
          // Limite à 2 lignes maximum
          maxLines: 2,
          // Affiche "..." si le texte dépasse 2 lignes
          overflow: TextOverflow.ellipsis,
        ),
        // Espacement vertical après la description
        const SizedBox(height: kSpacingAfterEvenementCardDescription),
        // Ligne horizontale pour afficher la date et le lieu côte à côte
        Row(
          children: [
            // Date formatée de l'événement
            Text(evenement.dateFormatee, style: kEvenementCardInfoText),
            // Espacement horizontal entre la date et le lieu
            const SizedBox(width: kSmallSpace),
            // Lieu de l'événement
            Text(evenement.lieu, style: kEvenementCardInfoText),
          ],
        ),
      ],
    );
  }

  /// Construit le bouton "Voir"
  /// Crée un bouton pour naviguer vers l'écran de détails de l'événement
  Widget _construireBoutonVoir(BuildContext context, String evenementId) {
    // Bouton élevé Material Design
    return ElevatedButton(
      // Action à exécuter lors du clic
      onPressed: () {
        // Navigation vers l'écran de détails avec l'ID de l'événement
        Navigator.pushNamed(context, EvenementDetailScreen.routeName, arguments: evenementId);
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
          horizontal: kEvenementCardButtonHorizontalPadding,
          // Padding vertical
          vertical: kEvenementCardButtonVerticalPadding,
        ),
        // Forme du bouton avec coins arrondis
        shape: RoundedRectangleBorder(
          // Rayon des coins arrondis
          borderRadius: BorderRadius.circular(kEvenementCardButtonBorderRadius),
        ),
      ),
      // Texte affiché sur le bouton
      child: const Text('Voir', style: kEvenementCardButtonText),
    );
  }
}


