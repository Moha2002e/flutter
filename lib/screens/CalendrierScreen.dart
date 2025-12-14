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
// Import du contrôleur pour gérer les opérations sur les cours
import '../controllers/cours_controller.dart';
// Import du modèle Cours pour typer les données
import '../models/cours.dart';
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';
// Import de l'écran de création de cours
import 'CreerCoursScreen.dart';
// Import de l'écran de détails de cours
import 'CoursDetailScreen.dart';

/// Écran affichant la liste des cours (calendrier)
/// Permet de visualiser tous les cours et d'en créer de nouveaux
class CalendrierScreen extends StatelessWidget {
  // Constructeur constant pour optimiser les performances
  const CalendrierScreen({super.key});

  // Nom de la route pour la navigation
  static const String routeName = '/calendrier';

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
                // Construction de la liste des cours
                _construireListeCours(),
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
          // Titre de l'écran "Calendrier" avec style prédéfini
          const Text('Calendrier', style: kCalendrierScreenTitleText),
          // Bouton "+" pour ajouter un nouveau cours
          _construireBoutonAjouter(context),
        ],
      ),
    );
  }

  /// Construit le bouton ajouter
  /// Crée un bouton circulaire avec un "+" pour créer un nouveau cours
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
        () => Navigator.pushNamed(context, CreerCoursScreen.routeName),
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

  /// Construit la liste des cours
  /// Utilise un StreamBuilder pour afficher les cours en temps réel depuis Firestore
  Widget _construireListeCours() {
    // Widget qui prend tout l'espace disponible verticalement
    return Expanded(
      // StreamBuilder qui écoute les changements de la liste de cours
      child: StreamBuilder<List<Cours>>(
        // Stream qui émet la liste des cours depuis Firestore
        stream: CoursController.obtenirTousLesCoursStream(),
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

          // Si une erreur est survenue lors de la récupération des cours
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

          // Si aucun cours n'est disponible ou la liste est vide
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Affiche un message indiquant qu'il n'y a pas de cours
            return const Center(
              // Texte informatif
              child: Text(
                'Aucun cours disponible',
                // Style de texte en blanc
                style: TextStyle(color: kWhiteColor),
              ),
            );
          }

          // Récupère la liste des cours depuis les données du snapshot
          final cours = snapshot.data!;

          // Construit une liste défilable avec un builder pour optimiser les performances
          return ListView.builder(
            // Padding horizontal pour espacer les éléments des bords
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            // Nombre d'éléments dans la liste
            itemCount: cours.length,
            // Builder qui crée chaque élément de la liste
            itemBuilder: (context, index) {
              // Construit une carte pour chaque cours
              return _construireCarteCours(context, cours[index]);
            },
          );
        },
      ),
    );
  }

  /// Construit une carte de cours
  /// Crée un conteneur avec les informations du cours et un bouton pour voir les détails
  Widget _construireCarteCours(BuildContext context, Cours cours) {
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
                // Contenu du cours qui prend l'espace disponible
                Expanded(child: _construireContenuCours(cours)),
                // Espacement horizontal entre le contenu et le bouton
                const SizedBox(width: kSmallSpace),
                // Bouton pour voir les détails du cours
                _construireBoutonVoir(context, cours.id),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le contenu de la carte (nom, infos)
  /// Affiche les informations principales du cours dans la carte
  Widget _construireContenuCours(Cours cours) {
    // Colonne pour organiser les informations verticalement
    return Column(
      // Alignement du contenu à gauche
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nom du cours avec style prédéfini
        Text(cours.nom, style: kCoursCardTitleText),
        // Espacement vertical après le nom
        const SizedBox(height: kSpacingAfterCoursCardTitle),
        // Date formatée du cours
        Text(cours.dateFormatee, style: kCoursCardInfoText),
        // Espacement vertical après la date
        const SizedBox(height: kSpacingAfterCoursCardInfo),
        // Ligne horizontale pour afficher le professeur et le local côte à côte
        Row(
          children: [
            // Nom du professeur avec préfixe "Prof:"
            Text('Prof: ${cours.nomProf}', style: kCoursCardInfoText),
            // Espacement horizontal entre le professeur et le local
            const SizedBox(width: kSmallSpace),
            // Local/salle du cours avec préfixe "Local:"
            Text('Local: ${cours.local}', style: kCoursCardInfoText),
          ],
        ),
      ],
    );
  }

  /// Construit le bouton "Voir"
  /// Crée un bouton pour naviguer vers l'écran de détails du cours
  Widget _construireBoutonVoir(BuildContext context, String coursId) {
    // Bouton élevé Material Design
    return ElevatedButton(
      // Action à exécuter lors du clic
      onPressed: () {
        // Navigation vers l'écran de détails avec l'ID du cours
        Navigator.pushNamed(context, CoursDetailScreen.routeName, arguments: coursId);
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
          horizontal: kCoursCardButtonHorizontalPadding,
          // Padding vertical
          vertical: kCoursCardButtonVerticalPadding,
        ),
        // Forme du bouton avec coins arrondis
        shape: RoundedRectangleBorder(
          // Rayon des coins arrondis
          borderRadius: BorderRadius.circular(kCoursCardButtonBorderRadius),
        ),
      ),
      // Texte affiché sur le bouton
      child: const Text('Voir', style: kCoursCardButtonText),
    );
  }
}


