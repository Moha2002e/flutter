import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../utils/date_utils.dart';

/// Widget réutilisable pour les champs de date
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.controller,
    required this.onDateSelected,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
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
          readOnly: true,
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
            suffixIcon: Icon(
              Icons.calendar_today,
              size: kDatePickerIconSize,
              color: Colors.black54,
            ),
          ),
          onTap: () async {
            final date = await AppDateUtils.selectDate(context: context);
            if (date != null) {
              controller.text = AppDateUtils.formatDate(date);
              onDateSelected(date);
            }
          },
          validator: validator ?? (v) => v == null || v.isEmpty ? 'Veuillez sélectionner une date' : null,
        ),
      ],
    );
  }
}

