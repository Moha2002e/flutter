import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../styles/colors.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../widgets/main_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_header.dart';
import '../controllers/auth_controller.dart';
import 'RegisterScreen.dart';

/// Écran de connexion
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  title: localizations.connection,
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
                        const SizedBox(height: kSpacingBeforeForgotPassword),
                        GestureDetector(
                          onTap: () => AuthController.showPasswordResetDialog(context),
                          child: Text(localizations.forgotPassword, style: kLinkText),
                        ),
                        const SizedBox(height: kSpacingBeforeButton),
                        SizedBox(
                          width: double.infinity,
                          child: MainButton(
                            onTap: () => AuthController.signIn(
                              context: context,
                              formKey: _formKey,
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                            label: localizations.login,
                            status: 'login',
                          ),
                        ),
                        const SizedBox(height: kSpacingAfterButton),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, RegisterScreen.routeName),
                          child: Text(localizations.register, style: kRegisterLinkText),
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
