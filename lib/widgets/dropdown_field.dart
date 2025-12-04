import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';

/// Widget réutilisable pour les champs dropdown
class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final String label;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        DropdownButtonFormField<String>(
          value: value,
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
          style: kInputText,
          icon: Icon(
            Icons.arrow_drop_down,
            size: kDropdownIconSize,
            color: Colors.black54,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator ?? (v) => v == null || v.isEmpty ? 'Veuillez sélectionner une option' : null,
        ),
      ],
    );
  }
}

