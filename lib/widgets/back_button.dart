import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';

/// Widget réutilisable pour le bouton retour
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kHorizontalPadding),
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: kBackButtonSize,
            height: kBackButtonSize,
            decoration: BoxDecoration(
              color: kWhiteColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

