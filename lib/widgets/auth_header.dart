import 'package:flutter/material.dart';
import '../styles/images.dart';
import '../styles/sizes.dart';
import '../styles/texts.dart';
import '../styles/spacings.dart';
import '../styles/colors.dart';

/// Widget réutilisable pour l'en-tête des écrans d'authentification
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    this.onBack,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onBack != null)
          Padding(
            padding: const EdgeInsets.all(kHorizontalPadding),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: onBack,
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
          ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * kWelcomeRatioForm,
              ),
              Text(title, style: kLoginTitleText),
            ],
          ),
        ),
      ],
    );
  }
}

