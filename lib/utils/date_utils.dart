import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utilitaires pour la gestion des dates
class AppDateUtils {
  /// Sélectionne une date avec un DatePicker
  static Future<DateTime?> selectDate({
    required BuildContext context,
    DateTime? initialDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
    );
  }

  /// Formate une date au format MM/dd/yyyy
  static String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }
}

