import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../styles/colors.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../widgets/main_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_header.dart';
import '../controllers/auth_controller.dart';
import 'LoginScreen.dart';

/// Écran d'inscription
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(gradient: kBackgroundGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                AuthHeader(
                  title: localizations.registration,
                  onBack: () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          label: localizations.mail,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: kSpacingBetweenFields),
                        AuthTextField(
                          label: localizations.password,
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: kSpacingBeforeButton),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, LoginScreen.routeName),
                          child: Text(localizations.alreadyHaveAccount, style: kLabelText),
                        ),
                        const SizedBox(height: kSpacingAfterButton),
                        SizedBox(
                          width: double.infinity,
                          child: MainButton(
                            onTap: () => AuthController.signUp(
                              context: context,
                              formKey: _formKey,
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                            label: localizations.register,
                            status: 'login',
                          ),
                        ),
                        const SizedBox(height: kSpacingBottomForm),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
