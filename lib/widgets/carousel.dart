// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';
// Import des localisations pour l'internationalisation (français/anglais)
import 'package:projectexamen/l10n/app_localizations.dart';
// Import des styles de couleurs utilisés dans l'application
import 'package:projectexamen/styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import 'package:projectexamen/styles/sizes.dart';
// Import des constantes d'espacement entre les éléments
import 'package:projectexamen/styles/spacings.dart';
// Import des styles de texte prédéfinis
import 'package:projectexamen/styles/texts.dart';

/// Widget Carousel qui a un état (StatefulWidget) pour gérer l'animation et l'index de page
/// Affiche un carrousel de textes avec indicateurs de page en bas
class Carousel extends StatefulWidget {
  // Constructeur constant pour optimiser les performances
  const Carousel({super.key});

  // Crée l'état associé à ce widget
  @override
  State<Carousel> createState() => _CarouselState();
}

// Classe d'état privée du Carousel
class _CarouselState extends State<Carousel> {
  // Contrôleur pour le PageView, permet de gérer le défilement programmatiquement
  final PageController controller = PageController();

  // Index de la diapositive actuelle (commence à 0)
  int _currentIndex = 0;

  // Méthode pour récupérer les textes du carrousel selon la langue
  /// Retourne une liste de 4 textes localisés pour le carrousel
  List<String> _getItems(BuildContext context) {
    // Récupération de l'instance de localisation depuis le contexte
    final localizations = AppLocalizations.of(context);
    // Sécurité: si null, retourne des chaînes vides (ne devrait pas arriver si bien configuré)
    if (localizations == null) {
      // Retourne une liste de 4 chaînes vides par défaut
      return ['', '', '', ''];
    }
    // Retourne la liste des 4 textes traduits depuis les localisations
    return [
      // Premier texte du carrousel
      localizations.carousel1,
      // Deuxième texte du carrousel
      localizations.carousel2,
      // Troisième texte du carrousel
      localizations.carousel3,
      // Quatrième texte du carrousel
      localizations.carousel4,
    ];
  }

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Récupère les items (textes) localisés
    final _items = _getItems(context);
    // Colonne pour contenir le carrousel (texte) et les indicateurs en bas
    return Column(
      children: [
        // Zone du texte défilant, hauteur fixée
        SizedBox(
          // Hauteur du carrousel selon la constante définie
          height: kCarouselHeight,
          // Widget PageView pour faire défiler les pages horizontalement
          child: PageView.builder(
            // Défilement horizontal (gauche-droite)
            scrollDirection: Axis.horizontal,
            // Attache le contrôleur pour gérer le défilement programmatiquement
            controller: controller,
            // Nombre d'éléments à afficher
            itemCount: _items.length,
            // Constructeur de chaque page/item
            itemBuilder: (context, i) {
              // Padding autour du texte
              return Padding(
                // Padding horizontal selon la constante définie
                padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingHorizontalL,
                ),
                // Animation Tween pour faire apparaître le texte (opacité et position)
                child: TweenAnimationBuilder<double>(
                  // Valeur variant de 0.0 à 1.0 pour l'animation
                  tween: Tween(begin: 0.0, end: 1.0),
                  // Durée de l'animation de 800 millisecondes
                  duration: const Duration(milliseconds: 800),
                  // Builder de l'animation qui construit le widget animé
                  builder: (context, value, child) {
                    // Opacité change avec 'value' (de 0 à 1)
                    return Opacity(
                      // Opacité basée sur la valeur de l'animation
                      opacity: value,
                      // Translation verticale (remonte de 20px pendant l'animation)
                      child: Transform.translate(
                        // Offset vertical calculé (remonte progressivement)
                        offset: Offset(0, 20 * (1 - value)),
                        // L'enfant animé (le texte)
                        child: child,
                      ),
                    );
                  },
                  // Animation imbriquée (peut être redondante, mais conservée pour compatibilité)
                  child: TweenAnimationBuilder<double>(
                    // Valeur variant de 0.0 à 1.0 pour l'animation
                    tween: Tween(begin: 0.0, end: 1.0),
                    // Durée de l'animation de 800 millisecondes
                    duration: const Duration(milliseconds: 800),
                    // Builder de l'animation qui construit le widget animé
                    builder: (context, value, child) {
                      // Opacité change avec 'value' (de 0 à 1)
                      return Opacity(
                        // Opacité basée sur la valeur de l'animation
                        opacity: value,
                        // Translation verticale (remonte de 20px pendant l'animation)
                        child: Transform.translate(
                          // Offset vertical calculé (remonte progressivement)
                          offset: Offset(0, 20 * (1 - value)),
                          // L'enfant animé (le texte)
                          child: child,
                        ),
                      );
                    },
                    // Le texte réel affiché avec style et alignement centré
                    child: Text(_items[i], style: kCarouselText, textAlign: TextAlign.center),
                  ),
                ),
              );
            },
            // Callback quand la page change (swipe manuel ou programmatique)
            onPageChanged: (i) {
              // Met à jour l'index courant pour les indicateurs
              setState(() {
                // Assigne le nouvel index de page
                _currentIndex = i;
              });
            },
          ),
        ),
        // Zone des indicateurs (lignes du bas)
        Padding(
          // Padding horizontal selon la constante définie
          padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
          // Ligne horizontale pour les barres indicateurs
          child: Row(
            // Espacement égal entre les barres
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Boucle pour créer un indicateur par item
              for (int i = 0; i < _items.length; i++)
                // Détecteur de geste pour cliquer sur la barre
                GestureDetector(
                  // Attrape tous les clics même sur zones transparentes
                  behavior: HitTestBehavior.opaque,
                  // Au clic, fait défiler vers la page correspondante
                  onTap: () {
                    // Anime le défilement vers la page cible
                    controller.animateToPage(
                      // Index cible de la page
                      i,
                      // Durée de l'animation de 1 seconde
                      duration: const Duration(seconds: 1),
                      // Courbe d'accélération pour une animation fluide
                      curve: Curves.easeInOut,
                    );
                  },
                  // Conteneur visuel de la barre indicateur
                  child: Container(
                    // Couleur : active si index match, sinon inactive
                    color: _currentIndex == i
                        ? kCarouselActiveLine
                        : kCarouselInactiveLine,
                    // Hauteur de la barre (3 pixels)
                    height: 3,
                    // Largeur calculée dynamiquement : (Largeur écran / nb items) - padding
                    width: (MediaQuery.of(context).size.width / _items.length) - (kPaddingHorizontal * 2),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}