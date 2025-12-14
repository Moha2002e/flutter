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
// Import du service d'authentification Firebase
import '../services/firebase_auth.dart';
// Import du contrôleur pour gérer les opérations de l'écran d'accueil
import '../controllers/home_controller.dart';
// Import des utilitaires pour gérer les informations utilisateur
import '../utils/user_utils.dart';
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';
// Import de l'écran de connexion
import 'LoginScreen.dart';
// Import de l'écran d'accueil (Welcome)
import 'WelcomeScreen.dart';
// Import de l'écran de profil
import 'ProfileScreen.dart';
// Import de l'écran de liste des clubs
import 'ClubsScreen.dart';
// Import de l'écran de liste des annonces
import 'AnnoncesScreen.dart';
// Import de l'écran de liste des événements
import 'EvenementsScreen.dart';
// Import de l'écran de calendrier
import 'CalendrierScreen.dart';

/// Écran d'accueil principal de l'application
/// Affiche un message de bienvenue et les statistiques (nombre de cours, annonces, événements et clubs)
class HomeScreen extends StatelessWidget {
  // Constructeur constant pour optimiser les performances
  const HomeScreen({super.key});

  // Nom de la route pour la navigation
  static const String routeName = '/homepage';

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Récupère l'utilisateur actuellement connecté
    final utilisateur = FirebaseAuthService.currentUser;
    // Détermine le nom à afficher : "Invité" si mode invité, sinon le nom de l'utilisateur
    final nomUtilisateur = isGuest() ? 'Invité' : getUserName(utilisateur);

    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: kBackgroundGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kHomeContentPadding),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kHomeContentBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kHomeContentPadding),
                  child: Column(
                    children: [
                      // En-tête avec les boutons profil et déconnexion
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bouton pour accéder au profil (masqué si invité)
                        if (!isGuest())
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
                            child: Container(
                              width: kBackButtonSize,
                              height: kBackButtonSize,
                              decoration: const BoxDecoration(shape: BoxShape.circle),
                              child: const Icon(
                                Icons.person_outline,
                                color: kWhiteColor,
                                size: kHomeProfilDeconnectSize,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: kBackButtonSize),
                        
                        // Bouton pour se déconnecter
                        GestureDetector(
                          onTap: () => HomeController.signOut(context),
                          child: Container(
                            width: kBackButtonSize,
                            height: kBackButtonSize,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.exit_to_app,
                              color: kWhiteColor,
                              size: kHomeProfilDeconnectSize,
                            ),
                          ),
                        ),
                      ],
                      ),
                      
                      // Espacement après l'en-tête
                      const SizedBox(height: kSpacingAfterHeader),
                      
                      // Message de bienvenue personnalisé
                      Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour, \n$nomUtilisateur',
                            style: kGreetingText.copyWith(fontSize: kGreetingFontSize),
                          ),
                          if (isGuest()) ...[
                            const SizedBox(height: kSmallSpace),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kInputFieldPadding,
                                vertical: kSmallSpace,
                              ),
                              decoration: BoxDecoration(
                                color: kWhiteColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                              ),
                              child: const Text(
                                'Mode lecture seule - Créez un compte pour interagir',
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: kHomeGuestModeFontSize,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      ),
                      
                      // Espacement après le message
                      const SizedBox(height: kSpacingAfterGreeting),
                      
                      // Grille de statistiques
                      Expanded(
                        child: _buildStatisticsGrid(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }


  /// Construit la grille de statistiques avec gestion optimisée des streams
  /// Utilise des StreamBuilders imbriqués pour afficher les statistiques en temps réel
  Widget _buildStatisticsGrid() {
    // StreamBuilder pour le nombre de cours
    return StreamBuilder<int>(
      // Stream qui émet le nombre de cours depuis Firestore
      stream: HomeController.obtenirNombreCoursStream(),
      // Builder qui construit l'UI selon l'état du stream
      builder: (context, coursSnapshot) {
        // StreamBuilder pour le nombre d'annonces
        return StreamBuilder<int>(
          // Stream qui émet le nombre d'annonces depuis Firestore
          stream: HomeController.obtenirNombreAnnoncesStream(),
          // Builder qui construit l'UI selon l'état du stream
          builder: (context, annoncesSnapshot) {
            // StreamBuilder pour le nombre d'événements
            return StreamBuilder<int>(
              // Stream qui émet le nombre d'événements depuis Firestore
              stream: HomeController.obtenirNombreEvenementsStream(),
              // Builder qui construit l'UI selon l'état du stream
              builder: (context, evenementsSnapshot) {
                // StreamBuilder pour le nombre de clubs
                return StreamBuilder<int>(
                  // Stream qui émet le nombre de clubs depuis Firestore
                  stream: HomeController.obtenirNombreClubsStream(),
                  // Builder qui construit l'UI selon l'état du stream
                  builder: (context, clubsSnapshot) {
                    // Vérifie si tous les streams sont en cours de chargement
                    final allWaiting = coursSnapshot.connectionState == ConnectionState.waiting ||
                        annoncesSnapshot.connectionState == ConnectionState.waiting ||
                        evenementsSnapshot.connectionState == ConnectionState.waiting ||
                        clubsSnapshot.connectionState == ConnectionState.waiting;

                    // Vérifie si au moins un stream a une erreur
                    final hasError = coursSnapshot.hasError ||
                        annoncesSnapshot.hasError ||
                        evenementsSnapshot.hasError ||
                        clubsSnapshot.hasError;

                    // Si tous les streams sont en cours de chargement
                    if (allWaiting) {
                      // Affiche un indicateur de chargement centré
                      return const Center(
                        // Indicateur circulaire de progression en blanc
                        child: CircularProgressIndicator(
                          color: kWhiteColor,
                        ),
                      );
                    }

                    // Si au moins un stream a une erreur
                    if (hasError) {
                      // Affiche un message d'erreur centré
                      return Center(
                        // Texte d'erreur
                        child: Text(
                          'Erreur de chargement',
                          // Style de texte pour les boutons de l'accueil
                          style: kHomeButtonText,
                        ),
                      );
                    }

                    // Récupère les valeurs des streams ou 0 par défaut
                    final nombreCours = coursSnapshot.data ?? 0;
                    final nombreAnnonces = annoncesSnapshot.data ?? 0;
                    final nombreEvenements = evenementsSnapshot.data ?? 0;
                    final nombreClubs = clubsSnapshot.data ?? 0;

                    // Construit une grille avec les statistiques
                    return GridView.count(
                      // Nombre de colonnes dans la grille (2 colonnes)
                      crossAxisCount: kHomeGridCrossAxisCount,
                      // Espacement horizontal entre les cartes
                      crossAxisSpacing: kSpacingBetweenButtons,
                      // Espacement vertical entre les cartes
                      mainAxisSpacing: kSpacingBetweenButtons,
                      // Liste des cartes de statistiques
                      children: [
                        // Statistique Calendrier (nombre de cours)
                        _buildStatCard(
                          // Dégradé de couleur pour la carte calendrier
                          gradient: kCalendarButtonGradient,
                          // Icône Material Design pour le calendrier
                          icon: Icons.calendar_today_outlined,
                          // Label de la carte
                          label: 'Calendrier',
                          // Nombre de cours à afficher
                          count: nombreCours,
                        ),
                        
                        // Statistique Annonce (nombre d'annonces)
                        _buildStatCard(
                          // Dégradé de couleur pour la carte annonce
                          gradient: kAnnouncementButtonGradient,
                          // Icône Material Design pour l'annonce
                          icon: Icons.announcement_outlined,
                          // Label de la carte
                          label: 'Annonce',
                          // Nombre d'annonces à afficher
                          count: nombreAnnonces,
                        ),
                        
                        // Statistique Événement (nombre d'événements)
                        _buildStatCard(
                          // Dégradé de couleur pour la carte événement
                          gradient: kEventButtonGradient,
                          // Icône Material Design pour l'événement
                          icon: Icons.event_available_outlined,
                          // Label de la carte
                          label: 'Evenement',
                          // Nombre d'événements à afficher
                          count: nombreEvenements,
                        ),
                        
                        // Statistique Clubs (nombre de clubs)
                        _buildStatCard(
                          // Dégradé de couleur pour la carte clubs
                          gradient: kClubsButtonGradient,
                          // Icône Material Design pour les clubs
                          icon: Icons.school_outlined,
                          // Label de la carte
                          label: 'Clubs',
                          // Nombre de clubs à afficher
                          count: nombreClubs,
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  /// Construit une carte de statistique
  /// Crée un conteneur avec un dégradé, une icône, un nombre et un label
  Widget _buildStatCard({
    // Dégradé de couleur requis pour la carte
    required LinearGradient gradient,
    // Icône Material Design requise
    required IconData icon,
    // Label texte requis
    required String label,
    // Nombre à afficher requis
    required int count,
  }) {
    // Conteneur principal de la carte
    return Container(
      // Hauteur fixe de la carte
      height: kHomeButtonHeight,
      // Décoration de la carte
      decoration: BoxDecoration(
        // Dégradé de couleur appliqué à la carte
        gradient: gradient,
        // Coins arrondis pour un design moderne
        borderRadius: BorderRadius.circular(kHomeButtonBorderRadius),
      ),
      // Colonne pour organiser le contenu verticalement
      child: Column(
        // Alignement vertical centré
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône de la statistique
          Icon(
            // Icône Material Design
            icon,
            // Couleur blanche pour l'icône
            color: kWhiteColor,
            // Taille de l'icône
            size: kHomeButtonIconSize,
          ),
          // Espacement vertical après l'icône
          const SizedBox(height: kSmallSpace),
          // Texte affichant le nombre
          Text(
            // Convertit le nombre en chaîne de caractères
            count.toString(),
            // Style de texte avec taille et poids personnalisés
            style: kHomeButtonText.copyWith(
              // Taille de police pour le nombre
              fontSize: kHomeStatCardCountFontSize,
              // Texte en gras pour mettre en évidence
              fontWeight: FontWeight.bold,
            ),
          ),
          // Espacement vertical entre le nombre et le label
          const SizedBox(height: kHomeStatCardSpacing),
          // Texte affichant le label
          Text(
            // Label de la statistique
            label,
            // Style de texte avec taille personnalisée
            style: kHomeButtonText.copyWith(
              // Taille de police pour le label
              fontSize: kHomeStatCardLabelFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
