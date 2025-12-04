import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';

/// Widget réutilisable pour les boutons de soumission
class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.backgroundColor = kLoginButtonColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Color backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final textColor = foregroundColor ?? kWhiteColor;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: kInputFieldPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
          ),
        ),
        child: loading
            ? CircularProgressIndicator(color: textColor)
            : Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}

