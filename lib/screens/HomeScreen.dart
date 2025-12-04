import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_auth.dart';
import '../controllers/home_controller.dart';
import '../utils/user_utils.dart';
import '../utils/guest_utils.dart';
import 'LoginScreen.dart';
import 'WelcomeScreen.dart';
import 'ProfileScreen.dart';
import 'ClubsScreen.dart';
import 'AnnoncesScreen.dart';
import 'EvenementsScreen.dart';
import 'CalendrierScreen.dart';

/// Écran d'accueil principal de l'application
/// Affiche un message de bienvenue et les statistiques (nombre de cours, annonces, événements et clubs)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/homepage';

  @override
  Widget build(BuildContext context) {
    final utilisateur = FirebaseAuthService.currentUser;
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
  Widget _buildStatisticsGrid() {
    return StreamBuilder<int>(
      stream: HomeController.obtenirNombreCoursStream(),
      builder: (context, coursSnapshot) {
        return StreamBuilder<int>(
          stream: HomeController.obtenirNombreAnnoncesStream(),
          builder: (context, annoncesSnapshot) {
            return StreamBuilder<int>(
              stream: HomeController.obtenirNombreEvenementsStream(),
              builder: (context, evenementsSnapshot) {
                return StreamBuilder<int>(
                  stream: HomeController.obtenirNombreClubsStream(),
                  builder: (context, clubsSnapshot) {
                    // Vérifier l'état de connexion de tous les streams
                    final allWaiting = coursSnapshot.connectionState == ConnectionState.waiting ||
                        annoncesSnapshot.connectionState == ConnectionState.waiting ||
                        evenementsSnapshot.connectionState == ConnectionState.waiting ||
                        clubsSnapshot.connectionState == ConnectionState.waiting;

                    // Vérifier les erreurs
                    final hasError = coursSnapshot.hasError ||
                        annoncesSnapshot.hasError ||
                        evenementsSnapshot.hasError ||
                        clubsSnapshot.hasError;

                    if (allWaiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: kWhiteColor,
                        ),
                      );
                    }

                    if (hasError) {
                      return Center(
                        child: Text(
                          'Erreur de chargement',
                          style: kHomeButtonText,
                        ),
                      );
                    }

                    // Utiliser les valeurs ou 0 par défaut
                    final nombreCours = coursSnapshot.data ?? 0;
                    final nombreAnnonces = annoncesSnapshot.data ?? 0;
                    final nombreEvenements = evenementsSnapshot.data ?? 0;
                    final nombreClubs = clubsSnapshot.data ?? 0;

                    return GridView.count(
                      crossAxisCount: kHomeGridCrossAxisCount,
                      crossAxisSpacing: kSpacingBetweenButtons,
                      mainAxisSpacing: kSpacingBetweenButtons,
                      children: [
                        // Statistique Calendrier
                        _buildStatCard(
                          gradient: kCalendarButtonGradient,
                          icon: Icons.calendar_today_outlined,
                          label: 'Calendrier',
                          count: nombreCours,
                        ),
                        
                        // Statistique Annonce
                        _buildStatCard(
                          gradient: kAnnouncementButtonGradient,
                          icon: Icons.announcement_outlined,
                          label: 'Annonce',
                          count: nombreAnnonces,
                        ),
                        
                        // Statistique Événement
                        _buildStatCard(
                          gradient: kEventButtonGradient,
                          icon: Icons.event_available_outlined,
                          label: 'Evenement',
                          count: nombreEvenements,
                        ),
                        
                        // Statistique Clubs
                        _buildStatCard(
                          gradient: kClubsButtonGradient,
                          icon: Icons.school_outlined,
                          label: 'Clubs',
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
  Widget _buildStatCard({
    required LinearGradient gradient,
    required IconData icon,
    required String label,
    required int count,
  }) {
    return Container(
      height: kHomeButtonHeight,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(kHomeButtonBorderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: kWhiteColor,
            size: kHomeButtonIconSize,
          ),
          const SizedBox(height: kSmallSpace),
          Text(
            count.toString(),
            style: kHomeButtonText.copyWith(
              fontSize: kHomeStatCardCountFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: kHomeStatCardSpacing),
          Text(
            label,
            style: kHomeButtonText.copyWith(
              fontSize: kHomeStatCardLabelFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
