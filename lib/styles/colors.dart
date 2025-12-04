import 'package:flutter/material.dart';

const kWhiteColor = Color.fromRGBO(255, 255, 255, 1);
const kMainColor = Color.fromRGBO(204, 214, 209, 1.0);
const kSecondaryColor = Color.fromRGBO(53, 78, 65, 1);
const kCarouselActiveLine = Color.fromRGBO(255, 255, 255, 1.0);
const kCarouselInactiveLine = Color.fromRGBO(99, 98, 98, 1.0);
const kMainButtonColor = Color.fromRGBO(53, 78, 65, 1);
const kSecondaryButtonColor = Color.fromRGBO(163, 177, 138, 1);
const kLoginButtonColor = Color(0xFF4A90E2); // Bleu clair pour le bouton de connexion
const kBackgroundColor = Color.fromRGBO(242, 239, 228, 1);
const kBorderColor = Color.fromRGBO(163, 177, 138, 1);
//  couleur en degreder 
const kBackgroundGradient = LinearGradient(
  colors: [
    Color(0xFF0172B2),
    Color(0xFF001645),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Gradients pour les boutons de la page d'accueil
const kCalendarButtonGradient = LinearGradient(
  colors: [
    Color(0xFF4DA3FF), // Bleu clair
    Color(0xFF244C93), // Bleu foncé
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const kAnnouncementButtonGradient = LinearGradient(
  colors: [
    Color(0xFF3BD082), // Vert clair
    Color(0xFF18785E), // Vert foncé
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const kEventButtonGradient = LinearGradient(
  colors: [
    Color(0xFF8A6CFF), // Violet clair
    Color(0xFF4627BE), // Violet foncé
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const kClubsButtonGradient = LinearGradient(
  colors: [
    Color(0xFFFFB463), // Orange clair
    Color(0xFFB2623D), // Orange-brun foncé
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Gradient pour la barre de navigation en bas
const kBottomNavBarGradient = LinearGradient(
  colors: [
    Color(0xFF001645), // Bleu foncé
    Color(0xFF0172B2), // Bleu moyen
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Opacités pour ProfileScreen
const double kProfileAvatarOpacity = 0.2;
const double kProfileInfoBackgroundOpacity = 0.1;

// Opacités pour ClubsScreen
const double kClubCardAvatarOpacity = 0.2;

// Opacité pour les icônes non sélectionnées de la barre de navigation
const double kBottomNavBarUnselectedOpacity = 0.7;