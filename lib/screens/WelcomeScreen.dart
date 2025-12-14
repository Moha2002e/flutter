// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des localisations pour l'internationalisation (français/anglais)
import 'package:projectexamen/l10n/app_localizations.dart';
// Import de l'écran de connexion
import 'package:projectexamen/screens/LoginScreen.dart';
// Import de l'écran d'inscription
import 'package:projectexamen/screens/RegisterScreen.dart';
// Import de l'écran de navigation principal
import 'package:projectexamen/screens/main_navigation_screen.dart';

// Import des constantes de tailles (dimensions, espacements)
import 'package:projectexamen/styles/sizes.dart';
// Import des styles de couleurs utilisés dans l'application
import 'package:projectexamen/styles/colors.dart';
// Import des constantes d'espacement entre les éléments
import 'package:projectexamen/styles/spacings.dart';

// Import des images utilisées dans l'application
import '../styles/images.dart';
// Import du widget carousel pour afficher les informations
import '../widgets/carousel.dart';
// Import du widget bouton principal personnalisé
import '../widgets/main_button.dart';
// Import des utilitaires pour gérer le mode invité
import '../utils/guest_utils.dart';

/// Écran d'accueil de l'application
/// Affiche le logo, un carousel et des boutons pour s'inscrire ou se connecter
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    // Récupère la largeur de l'écran pour adapter la taille du logo
    double largeurEcran = MediaQuery.of(context).size.width;
    double largeurLogo = largeurEcran * kLogoRatioPercentage;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: kBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Espace vide en haut pour centrer le contenu
              const Spacer(),
              
              // Logo de l'application - centré en haut
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: largeurLogo,
                ),
              ),
              
              // Carousel d'informations
              const Carousel(),
              
              // Espace vide au milieu
              const Spacer(),
              
              // Boutons d'action (S'inscrire et Se connecter)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouton "S'inscrire"
                    Expanded(
                      child: MainButton(
                        onTap: () {
                          // Navigue vers l'écran d'inscription
                          Navigator.pushNamed(context, RegisterScreen.routeName);
                        },
                        label: AppLocalizations.of(context)!.register,
                        status: 'white',
                      ),
                    ),
                    
                    // Espacement entre les deux boutons
                    const SizedBox(width: kWelcomeButtonSpacing),
                    
                    // Bouton "Se connecter"
                    Expanded(
                      child: MainButton(
                        onTap: () {
                          // Navigue vers l'écran de connexion
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        label: AppLocalizations.of(context)!.login,
                        status: 'white',
                      ),
                    ),
                  ],
                ),
              ),
              
              // Espacement avant le lien "Continuer sans compte"
              const SizedBox(height: kWelcomeBottomSpacing),
              
              // Lien pour continuer sans compte
              GestureDetector(
                onTap: () {
                  enableGuestMode();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MainNavigationScreen.routeName,
                    (route) => false,
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.withoutAccount,
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: kWithoutAccountFontSize,
                    fontFamily: 'Avenir',
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              
              // Espace vide en bas pour centrer le contenu
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
