import 'package:flutter/material.dart';
import '../controllers/club_controller.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../services/firebase_auth.dart';
import '../utils/user_utils.dart';
import '../utils/guest_utils.dart';
import '../controllers/profile_controller.dart';
import '../widgets/back_button.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/password_form_section.dart';
import '../widgets/submit_button.dart';

/// Écran de profil utilisateur
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  bool _isEditingPassword = false;
  String _currentPassword = '';
  String _newPassword = '';

  @override
  Widget build(BuildContext context) {
    if (blockGuestAccess(context)) {
      return Scaffold(
        body: SizedBox.expand(
          child: DecoratedBox(
            decoration: const BoxDecoration(gradient: kBackgroundGradient),
          ),
        ),
      );
    }
    
    final user = FirebaseAuthService.currentUser;
    final userName = getUserName(user);
    final userEmail = user?.email ?? '';

    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(gradient: kBackgroundGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(kHomeContentPadding),
                child: Column(
                  children: [
                    AppBackButton(onTap: () => Navigator.pop(context)),
                    const SizedBox(height: kSpacingAfterHeader),
                    const ProfileAvatar(),
                    const SizedBox(height: kSpacingAfterGreeting),
                    Text(
                      userName,
                      style: kGreetingText.copyWith(fontSize: kGreetingFontSize),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: kSmallSpace),
                    Text(
                      userEmail,
                      style: kLabelText.copyWith(fontSize: kProfileEmailFontSize),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: kSpacingBeforeForm),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                      child: _isEditingPassword
                          ? PasswordFormSection(
                              formKey: _passwordFormKey,
                              onSave: _updatePassword,
                              onCancel: _cancelEdit,
                            )
                          : _buildEditButton(),
                    ),
                    const SizedBox(height: kSpacingAfterButton),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                      child: Column(
                        children: [
                          ProfileInfoCard(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: userEmail,
                          ),
                          const SizedBox(height: kSpacingBetweenFields),
                          ProfileInfoCard(
                            icon: Icons.calendar_today_outlined,
                            label: 'Compte créé le',
                            value: formatCreationDate(user),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kSpacingAfterButton),
                    // Section Badges
                    FutureBuilder<int>(
                      future: user != null ? ClubController.countJoinedClubs(user.uid) : Future.value(0),
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        if (count < 3) return const SizedBox.shrink();

                        return Column(
                          children: [
                            Text(
                              'Badges',
                              style: kGreetingText.copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: kSmallSpace),
                            Container(
                              padding: const EdgeInsets.all(kInputFieldPadding),
                              decoration: BoxDecoration(
                                color: kWhiteColor.withValues(alpha: kProfileInfoBackgroundOpacity),
                                borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                                border: Border.all(color: Colors.amber, width: 2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.stars, color: Colors.amber, size: 30),
                                  const SizedBox(width: kSmallSpace),
                                  Text(
                                    'Membre Actif',
                                    style: kLabelText.copyWith(
                                      color: Colors.amber[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: kSpacingBetweenFields),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: kSpacingBottomForm),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return SubmitButton(
      label: 'Modifier le mot de passe',
      loading: false,
      onPressed: () => setState(() => _isEditingPassword = true),
      backgroundColor: kWhiteColor,
      foregroundColor: kMainButtonColor,
    );
  }

  void _cancelEdit() {
    setState(() => _isEditingPassword = false);
  }

  void _updatePassword() {
    final formState = _passwordFormKey.currentState;
    if (formState == null || !formState.validate()) return;

    ProfileController.updatePassword(
      context: context,
      formKey: _passwordFormKey,
      currentPassword: _currentPassword,
      newPassword: _newPassword,
      onSuccess: _cancelEdit,
    );
  }
}
