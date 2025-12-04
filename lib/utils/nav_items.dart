import 'package:flutter/material.dart';

/// Énumération des items de navigation
enum NavItem {
  home,
  clubs,
  annonces,
  evenements,
  calendrier,
}

/// Extension pour obtenir les informations de navigation
extension NavItemExtension on NavItem {
  /// Retourne le label de l'item
  String get label {
    switch (this) {
      case NavItem.home:
        return 'Accueil';
      case NavItem.clubs:
        return 'Clubs';
      case NavItem.annonces:
        return 'Annonces';
      case NavItem.evenements:
        return 'Événements';
      case NavItem.calendrier:
        return 'Calendrier';
    }
  }

  /// Retourne l'icône de l'item
  IconData get icon {
    switch (this) {
      case NavItem.home:
        return Icons.home_outlined;
      case NavItem.clubs:
        return Icons.school_outlined;
      case NavItem.annonces:
        return Icons.announcement_outlined;
      case NavItem.evenements:
        return Icons.event_available_outlined;
      case NavItem.calendrier:
        return Icons.calendar_today_outlined;
    }
  }

  /// Retourne l'icône sélectionnée de l'item
  IconData get selectedIcon {
    switch (this) {
      case NavItem.home:
        return Icons.home;
      case NavItem.clubs:
        return Icons.school;
      case NavItem.annonces:
        return Icons.announcement;
      case NavItem.evenements:
        return Icons.event_available;
      case NavItem.calendrier:
        return Icons.calendar_today;
    }
  }
}

