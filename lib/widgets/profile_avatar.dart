// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';

/// Widget affichant l'avatar (cercle avec icône)
/// Affiche un cercle avec une icône de personne pour représenter l'avatar de l'utilisateur
class ProfileAvatar extends StatelessWidget {
  // Constructeur constant pour optimiser les performances
  const ProfileAvatar({super.key});

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Conteneur pour dessiner le cercle de l'avatar
    return Container(
      // Taille fixe (largeur x hauteur) selon la constante définie
      width: kProfileAvatarSize,
      height: kProfileAvatarSize,
      // Décoration : forme cercle, couleur de fond, bordure
      decoration: BoxDecoration(
        // Forme ronde (cercle)
        shape: BoxShape.circle,
        // Couleur de fond blanche semi-transparente selon l'opacité définie
        color: kWhiteColor.withOpacity(kProfileAvatarOpacity),
        // Bordure blanche avec largeur définie
        border: Border.all(color: kWhiteColor, width: kProfileAvatarBorderWidth),
      ),
      // Enfant : Icône de personne en blanc
      child: const Icon(Icons.person, size: kProfileAvatarIconSize, color: kWhiteColor),
    );
  }
}

