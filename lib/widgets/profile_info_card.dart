import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';

/// Widget réutilisable pour les cartes d'information du profil
class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kInputFieldPadding),
      decoration: BoxDecoration(
        color: kWhiteColor.withValues(alpha: kProfileInfoBackgroundOpacity),
        borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
      ),
      child: Row(
        children: [
          Icon(icon, color: kWhiteColor, size: kProfileInfoIconSize),
          const SizedBox(width: kSmallSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: kLabelText.copyWith(fontSize: kProfileLabelFontSize),
                ),
                const SizedBox(height: kProfileInfoSpacing),
                Text(value, style: kProfileInfoValueText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

