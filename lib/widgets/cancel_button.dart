import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';

/// Widget réutilisable pour le bouton Annuler
class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
    required this.onPressed,
    this.label = 'Annuler',
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: kWhiteColor,
          padding: EdgeInsets.symmetric(vertical: kInputFieldPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
          ),
        ),
        child: Text(
          label,
          style: kProfileButtonText.copyWith(color: kWhiteColor),
        ),
      ),
    );
  }
}

