import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/spacings.dart';
import 'auth_text_field.dart';
import 'submit_button.dart';
import 'cancel_button.dart';

/// Widget réutilisable pour la section de modification du mot de passe
class PasswordFormSection extends StatefulWidget {
  const PasswordFormSection({
    super.key,
    required this.formKey,
    required this.onSave,
    required this.onCancel,
  });

  final GlobalKey<FormState> formKey;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  State<PasswordFormSection> createState() => _PasswordFormSectionState();
}

class _PasswordFormSectionState extends State<PasswordFormSection> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  String get currentPassword => _currentPasswordController.text;
  String get newPassword => _newPasswordController.text;

  void clearFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          AuthTextField(
            label: 'Mot de passe actuel',
            controller: _currentPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: kSpacingBetweenFields),
          AuthTextField(
            label: 'Nouveau mot de passe',
            controller: _newPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: kSpacingBeforeButton),
          Row(
            children: [
              CancelButton(onPressed: widget.onCancel),
              const SizedBox(width: kSmallSpace),
              Expanded(
                child: SubmitButton(
                  label: 'Enregistrer',
                  loading: false,
                  onPressed: () {
                    if (widget.formKey.currentState!.validate()) {
                      widget.onSave();
                    }
                  },
                  backgroundColor: kWhiteColor,
                  foregroundColor: kMainButtonColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

