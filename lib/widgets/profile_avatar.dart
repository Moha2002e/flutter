import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';

/// Widget réutilisable pour l'avatar du profil
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kProfileAvatarSize,
      height: kProfileAvatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kWhiteColor.withOpacity(kProfileAvatarOpacity),
        border: Border.all(
          color: kWhiteColor,
          width: kProfileAvatarBorderWidth,
        ),
      ),
      child: const Icon(
        Icons.person,
        size: kProfileAvatarIconSize,
        color: kWhiteColor,
      ),
    );
  }
}

