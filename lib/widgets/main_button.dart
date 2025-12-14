// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des styles de couleurs utilisés dans l'application
import '../styles/colors.dart';
// Import d'autres styles (ex: ombres)
import '../styles/others.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../styles/sizes.dart';
// Import des constantes d'espacement entre les éléments
import '../styles/spacings.dart';
// Import des styles de texte prédéfinis
import '../styles/texts.dart';

// Classe MainButton : un bouton personnalisé pour l'application
/// Widget réutilisable pour les boutons principaux de l'application
/// Supporte différents styles selon le paramètre 'status' ('main', 'white', 'login', etc.)
class MainButton extends StatelessWidget {
  // Constructeur constant avec paramètres nommés
  const MainButton({
    // Clé optionnelle pour identifier le widget dans l'arbre
    super.key,
    // Fonction obligatoire à exécuter au tap
    required this.onTap,
    // Texte obligatoire affiché sur le bouton
    required this.label,
    // État obligatoire du bouton qui détermine le style ('main', 'white', 'login', etc.)
    required this.status,
  });

  // Fonction callback appelée lors du clic sur le bouton
  final GestureTapCallback onTap;
  // Texte affiché sur le bouton
  final String label;
  // Statut du bouton qui détermine le style (couleurs, bordures, etc.)
  final String status;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Détermination des couleurs et styles selon le status
    // Vérifie si le status est 'white' (bouton blanc)
    final isWhite = status == 'white';
    // Vérifie si le status est 'main' (bouton principal)
    final isMain = status == 'main';
    // Vérifie si le status est 'login' (bouton de connexion)
    final isLogin = status == 'login';

    // Calcul de la couleur de fond en fonction du status
    final bgColor = isMain ? kMainButtonColor : (isWhite ? kWhiteColor : (isLogin ? kLoginButtonColor : kSecondaryButtonColor));
    // Calcul de la couleur de la bordure (pas de bordure pour blanc)
    final borderColor = isMain ? kMainButtonColor : (isLogin ? kLoginButtonColor : kSecondaryButtonColor);
    
    // Initialisation du style de texte par défaut (bouton secondaire)
    TextStyle textStyle = kSecondaryButtonText;
    // Si c'est le bouton principal, utilise le style principal
    if (isMain) textStyle = kMainButtonText;
    // Si c'est blanc ou login, définit un style spécifique
    else if (isWhite || isLogin) textStyle = const TextStyle(color: kCarouselInactiveLine, fontSize: 18, fontFamily: 'Avenir', fontWeight: FontWeight.w500);
    // Si c'est login, s'assure que le texte est blanc
    if (isLogin) textStyle = textStyle.copyWith(color: kWhiteColor);

    // Retourne un GestureDetector pour détecter les clics
    return GestureDetector(
      // Lie l'événement onTap à la fonction passée en paramètre
      onTap: onTap,
      // Conteneur visuel du bouton
      child: Container(
        // Padding interne : varie selon si le bouton est blanc ou non
        padding: EdgeInsets.symmetric(
          // Padding vertical : plus grand si blanc, sinon petit
          vertical: isWhite ? kVerticalPadding : kVerticalPaddingXS,
          // Padding horizontal : plus grand si blanc, sinon petit
          horizontal: isWhite ? kHorizontalPadding : kVerticalPaddingXS,
        ),
        // Largeur : infinie (prend tout) si blanc, sinon taille du contenu
        width: isWhite ? double.infinity : null,
        // Décoration du conteneur (couleur, bordure, arrondi, ombre)
        decoration: BoxDecoration(
          // Couleur de fond calculée selon le status
          color: bgColor,
          // Bordure : aucune si blanc, sinon bordure colorée
          border: isWhite ? null : Border.all(width: kWidth * 2, color: borderColor),
          // Coins arrondis : différent si blanc (8.0) ou autre (kBorderRadiusValue)
          borderRadius: BorderRadius.circular(isWhite ? 8.0 : kBorderRadiusValue),
          // Ombre : aucune si blanc, sinon ombre définie dans kShadow
          boxShadow: isWhite ? [] : [kShadow],
        ),
        // Le texte du bouton, centré, avec le style calculé
        child: Text(label, textAlign: TextAlign.center, style: textStyle),
      ),
    );
  }
}
