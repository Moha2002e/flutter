import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';

/// Widget réutilisable pour les champs de formulaire génériques
class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          style: kInputText,
          decoration: InputDecoration(
            filled: true,
            fillColor: kWhiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kInputFieldPadding,
              vertical: kInputFieldPadding,
            ),
          ),
          validator: validator ?? (v) => v == null || v.isEmpty ? 'Ce champ est requis' : null,
        ),
      ],
    );
  }
}

