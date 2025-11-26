import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_auth.dart';
import '../utils/user_utils.dart';
import 'LoginScreen.dart';
import 'ProfileScreen.dart';
import 'ClubsScreen.dart';
import 'AnnoncesScreen.dart';
import 'EvenementsScreen.dart';
import 'CalendrierScreen.dart';

/// Écran d'accueil principal de l'application
/// Affiche un message de bienvenue et une grille de boutons pour accéder aux différentes fonctionnalités
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/homepage';

  @override
  Widget build(BuildContext context) {
    // Récupère l'utilisateur actuellement connecté
    final utilisateur = FirebaseAuthService.currentUser;
    
    // Obtient le nom d'affichage de l'utilisateur
    final nomUtilisateur = getUserName(utilisateur);

    return Scaffold(
      body: DecoratedBox(
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
                        // Bouton pour accéder au profil
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, ProfileScreen.routeName);
                          },
                          child: Container(
                            width: kBackButtonSize,
                            height: kBackButtonSize,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: kWhiteColor,
                              size: kHomeProfilDeconnectSize,
                            ),
                          ),
                        ),
                        
                        // Bouton pour se déconnecter
                        GestureDetector(
                          onTap: () {
                            _gererDeconnexion(context);
                          },
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
                      child: Text(
                        'Bonjour, \n$nomUtilisateur',
                        style: kGreetingText.copyWith(fontSize: kGreetingFontSize),
                      ),
                    ),
                    
                    // Espacement après le message
                    const SizedBox(height: kSpacingAfterGreeting),
                    
                    // Grille de boutons pour les fonctionnalités
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: kHomeGridCrossAxisCount,
                        crossAxisSpacing: kSpacingBetweenButtons,
                        mainAxisSpacing: kSpacingBetweenButtons,
                        children: [
                          // Bouton Calendrier
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, CalendrierScreen.routeName);
                            },
                            child: Container(
                              height: kHomeButtonHeight,
                              decoration: BoxDecoration(
                                gradient: kCalendarButtonGradient,
                                borderRadius: BorderRadius.circular(kHomeButtonBorderRadius),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: kWhiteColor,
                                    size: kHomeButtonIconSize,
                                  ),
                                  SizedBox(height: kSmallSpace),
                                  Text(
                                    'Calendrier',
                                    style: kHomeButtonText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Bouton Annonce
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AnnoncesScreen.routeName);
                            },
                            child: Container(
                              height: kHomeButtonHeight,
                              decoration: BoxDecoration(
                                gradient: kAnnouncementButtonGradient,
                                borderRadius: BorderRadius.circular(kHomeButtonBorderRadius),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.announcement_outlined,
                                    color: kWhiteColor,
                                    size: kHomeButtonIconSize,
                                  ),
                                  const SizedBox(height: kSmallSpace),
                                  Text(
                                    'Annonce',
                                    style: kHomeButtonText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Bouton Événement
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, EvenementsScreen.routeName);
                            },
                            child: Container(
                              height: kHomeButtonHeight,
                              decoration: BoxDecoration(
                                gradient: kEventButtonGradient,
                                borderRadius: BorderRadius.circular(kHomeButtonBorderRadius),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.event_available_outlined,
                                    color: kWhiteColor,
                                    size: kHomeButtonIconSize,
                                  ),
                                  const SizedBox(height: kSmallSpace),
                                  Text(
                                    'Evenement',
                                    style: kHomeButtonText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Bouton Clubs
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, ClubsScreen.routeName);
                            },
                            child: Container(
                              height: kHomeButtonHeight,
                              decoration: BoxDecoration(
                                gradient: kClubsButtonGradient,
                                borderRadius: BorderRadius.circular(kHomeButtonBorderRadius),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    color: kWhiteColor,
                                    size: kHomeButtonIconSize,
                                  ),
                                  const SizedBox(height: kSmallSpace),
                                  Text(
                                    'Clubs',
                                    style: kHomeButtonText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Gère la déconnexion de l'utilisateur
  /// Déconnecte l'utilisateur puis navigue vers l'écran de connexion
  Future<void> _gererDeconnexion(BuildContext context) async {
    // Déconnecte l'utilisateur
    await FirebaseAuthService.signOut();
    
    // Vérifie que le contexte est toujours valide avant de naviguer
    if (context.mounted) {
      // Navigue vers l'écran de connexion et supprime tous les écrans précédents
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
        (route) => false,
      );
    }
  }
}
