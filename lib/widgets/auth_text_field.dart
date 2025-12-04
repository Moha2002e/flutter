import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';

/// Widget réutilisable pour les champs de formulaire d'authentification
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.confirmPasswordController,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? confirmPasswordController;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: kLabelText),
        const SizedBox(height: kSpacingBetweenLabelAndField),
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscure,
          keyboardType: widget.keyboardType,
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
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
          ),
          validator: widget.validator ?? _getDefaultValidator(),
        ),
      ],
    );
  }

  String? Function(String?)? _getDefaultValidator() {
    if (widget.confirmPasswordController != null) {
      return (valeur) {
        if (valeur == null || valeur.isEmpty) {
          return 'Veuillez confirmer votre mot de passe';
        }
        if (valeur != widget.confirmPasswordController!.text) {
          return 'Les mots de passe ne correspondent pas';
        }
        return null;
      };
    }
    if (widget.obscureText) {
      return (valeur) {
        if (valeur == null || valeur.isEmpty) {
          return 'Veuillez entrer votre mot de passe';
        }
        if (valeur.length < kMinPasswordLength) {
          return 'Le mot de passe doit contenir au moins $kMinPasswordLength caractères';
        }
        return null;
      };
    }
    if (widget.keyboardType == TextInputType.emailAddress) {
      return (valeur) {
        if (valeur == null || valeur.isEmpty) {
          return 'Veuillez entrer votre email';
        }
        if (!valeur.contains('@')) {
          return 'Email invalide';
        }
        return null;
      };
    }
    return null;
  }
}

