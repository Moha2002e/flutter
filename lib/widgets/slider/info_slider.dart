// Import de la bibliothèque math pour générer des nombres aléatoires
import 'dart:math';

// Import du package Flutter pour les widgets Material Design
import 'package:flutter/material.dart';

// Import des styles de couleurs utilisés dans l'application
import '../../styles/colors.dart';
// Import des constantes de tailles (dimensions, espacements)
import '../../styles/sizes.dart';
// Import des constantes d'espacement entre les éléments
import '../../styles/spacings.dart';
// Import des styles de texte prédéfinis
import '../../styles/texts.dart';

/// Widget InfoSlider qui affiche une liste horizontale d'informations avec images de fond
/// Affiche des cartes avec texte et prix aléatoire dans un défilement horizontal
class InfoSlider extends StatelessWidget {
  // Constructeur constant avec initialisation de la liste d'items
  const InfoSlider({super.key, required List<String> items}) : _items = items;

  // Liste des items (textes) à afficher dans le slider
  final List<String> _items;

  // Méthode build qui construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Conteneur avec image de fond
    return Container(
      // Décoration avec image de fond
      decoration: const BoxDecoration(
        // Image de fond depuis les assets
        image: DecorationImage(
          // Chemin vers l'image de fond
          image: AssetImage('assets/img/back1.png'),
          // Ajustement de l'image pour couvrir tout l'espace
          fit: BoxFit.cover,
        ),
      ),
      // Padding autour du contenu
      child: Padding(
        // Padding vertical selon la constante définie
        padding: const EdgeInsets.symmetric(vertical: kVerticalPadding),
        // SizedBox pour définir la hauteur du slider
        child: SizedBox(
          // Hauteur du slider selon la constante définie
          height: kInfoSliderHeight,
          // ListView horizontal pour faire défiler les items
          child: ListView.builder(
            // Défilement horizontal
            scrollDirection: Axis.horizontal,
            // Nombre d'items à afficher
            itemCount: _items.length,
            // Builder pour construire chaque item
            itemBuilder: (context, i) {
              // Ligne horizontale pour chaque item
              return Row(
                children: [
                  // Espacement avant le conteneur (seulement pour le premier item)
                  _buildLeadingSpacing(i),
                  // Conteneur principal de la carte
                  Container(
                    // Padding interne de la carte
                    padding: const EdgeInsets.symmetric(
                      // Padding horizontal
                      horizontal: kHorizontalPadding,
                      // Padding vertical
                      vertical: kVerticalPadding,
                    ),
                    // Décoration de la carte
                    decoration: BoxDecoration(
                      // Fond avec couleur de fond et opacité
                      color: kBackgroundColor.withValues(alpha: 0.7),
                      // Coins arrondis
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Largeur du conteneur calculée dynamiquement
                    width: _getContainerWidth(context),
                    // Colonne pour organiser le texte et le prix verticalement
                    child: Column(
                      // Alignement des enfants à droite
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // Répartition de l'espace entre les éléments
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Texte de l'item avec style prédéfini
                        Text(_items[i], style: kTextSideBar),
                        // Prix aléatoire généré avec style prédéfini
                        Text('${Random().nextInt(1000)}€', style: kTitleHome),
                      ],
                    ),
                  ),
                  // Espacement après le conteneur (pour tous les items sauf le dernier)
                  _buildTrailingSpacing(i),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Construit l'espacement avant le conteneur (seulement pour le premier item)
  Widget _buildLeadingSpacing(int index) {
    // Si c'est le premier item (index 0)
    if (index == 0) {
      // Retourne un espacement horizontal
      return const SizedBox(width: kHorizontalPadding);
    } else {
      // Sinon, retourne un conteneur vide
      return Container();
    }
  }

  // Construit l'espacement après le conteneur (pour tous les items)
  Widget _buildTrailingSpacing(int index) {
    // Si l'index est inférieur à la longueur de la liste (tous les items sauf le dernier)
    if (index < _items.length) {
      // Retourne un espacement horizontal
      return const SizedBox(width: kHorizontalPadding);
    } else {
      // Sinon, retourne un conteneur vide
      return Container();
    }
  }

  // Calcule la largeur du conteneur selon la largeur de l'écran
  double _getContainerWidth(BuildContext context) {
    // Si la largeur de l'écran est supérieure à 390 pixels
    if (MediaQuery.of(context).size.width > 390) {
      // Retourne une largeur de 160 pixels
      return 160;
    } else {
      // Sinon, retourne une largeur de 200 pixels
      return 200;
    }
  }
}
