import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/others.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.status,
  });

  final GestureTapCallback onTap;
  final String label;
  final String status;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: _getVerticalPadding(),
          horizontal: _getHorizontalPadding(),
        ),
        width: _getWidth(),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          border: _getBorder(),
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          boxShadow: _getBoxShadow(),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: _getTextStyle(),
        ),
      ),
    );
  }

  double _getVerticalPadding() {
    if (status == 'white') {
      return kVerticalPadding;
    } else {
      return kVerticalPaddingXS;
    }
  }

  double _getHorizontalPadding() {
    if (status == 'white') {
      return kHorizontalPadding;
    } else {
      return kVerticalPaddingXS;
    }
  }

  double? _getWidth() {
    if (status == 'white') {
      return double.infinity;
    } else {
      return null;
    }
  }

  Color _getBackgroundColor() {
    if (status == 'main') {
      return kMainButtonColor;
    } else {
      if (status == 'white') {
        return kWhiteColor;
      } else {
        if (status == 'login') {
          return kLoginButtonColor;
        } else {
          return kSecondaryButtonColor;
        }
      }
    }
  }

  Border? _getBorder() {
    if (status == 'white') {
      return null;
    } else {
      Color borderColor;
      if (status == 'main') {
        borderColor = kMainButtonColor;
      } else {
        if (status == 'login') {
          borderColor = kLoginButtonColor;
        } else {
          borderColor = kSecondaryButtonColor;
        }
      }
      return Border.all(width: kWidth * 2, color: borderColor);
    }
  }

  double _getBorderRadius() {
    if (status == 'white') {
      return 8.0;
    } else {
      return kBorderRadiusValue;
    }
  }

  List<BoxShadow> _getBoxShadow() {
    if (status == 'white') {
      return [];
    } else {
      return [kShadow];
    }
  }

  TextStyle _getTextStyle() {
    if (status == 'main') {
      return kMainButtonText;
    } else {
      if (status == 'white') {
        return const TextStyle(
          color: kCarouselInactiveLine,
          fontSize: 18,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.w500,
        );
      } else {
        if (status == 'login') {
          return const TextStyle(
            color: kWhiteColor,
            fontSize: 18,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w500,
          );
        } else {
          return kSecondaryButtonText;
        }
      }
    }
  }
}
