import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../widgets/back_button.dart';
import '../widgets/form_text_field.dart';
import '../widgets/submit_button.dart';
import '../controllers/club_controller.dart';
import '../utils/guest_utils.dart';

/// Écran pour créer un nouveau club
class CreerClubScreen extends StatefulWidget {
  const CreerClubScreen({super.key});
  static const String routeName = '/creer-club';

  @override
  State<CreerClubScreen> createState() => _CreerClubScreenState();
}

class _CreerClubScreenState extends State<CreerClubScreen> {
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
    
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(gradient: kBackgroundGradient),
          child: SafeArea(
            child: SingleChildScrollView(
            child: Column(
              children: [
                AppBackButton(onTap: () => Navigator.pop(context)),
                const SizedBox(height: kSpacingAfterBackButton),
                const Text('Créer un club', style: kCreerClubTitleText),
                const SizedBox(height: kSpacingBeforeForm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormTextField(
                          label: 'Nom du club',
                          controller: _nomController,
                        ),
                        const SizedBox(height: kSpacingBetweenFields),
                        FormTextField(
                          label: 'Description',
                          controller: _descriptionController,
                          maxLines: kCreerClubDescriptionMaxLines,
                        ),
                        const SizedBox(height: kSpacingBeforeButton),
                        SubmitButton(
                          label: 'Créer le club',
                          loading: _loading,
                          onPressed: _creerClub,
                          backgroundColor: kWhiteColor,
                          foregroundColor: kMainButtonColor,
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
    ),);
  }

  Future<void> _creerClub() async {
    final success = await ClubController.createClub(
      context: context,
      formKey: _formKey,
      nom: _nomController.text,
      description: _descriptionController.text,
      setLoading: (loading) {
        if (mounted) setState(() => _loading = loading);
      },
    );
    if (success && context.mounted) Navigator.pop(context);
  }
}
