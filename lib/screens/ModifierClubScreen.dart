import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../widgets/back_button.dart';
import '../widgets/form_text_field.dart';
import '../widgets/submit_button.dart';
import '../controllers/club_controller.dart';
import '../models/club.dart';

/// Écran pour modifier un club existant
class ModifierClubScreen extends StatefulWidget {
  const ModifierClubScreen({super.key});
  static const String routeName = '/modifier-club';

  @override
  State<ModifierClubScreen> createState() => _ModifierClubScreenState();
}

class _ModifierClubScreenState extends State<ModifierClubScreen> {
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  Club? _club;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _club = ModalRoute.of(context)!.settings.arguments as Club;
      _nomController = TextEditingController(text: _club!.nom);
      _descriptionController = TextEditingController(text: _club!.description);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _club == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
                  const Text('Modifier le club', style: kCreerClubTitleText),
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
                            label: 'Enregistrer les modifications',
                            loading: _loading,
                            onPressed: _modifierClub,
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
      ),
    );
  }

  Future<void> _modifierClub() async {
    if (_club == null) return;
    
    final success = await ClubController.updateClub(
      context: context,
      formKey: _formKey,
      clubId: _club!.id,
      nom: _nomController.text,
      description: _descriptionController.text,
      setLoading: (loading) {
        if (mounted) setState(() => _loading = loading);
      },
    );
    if (success && context.mounted) {
      Navigator.pop(context, true);
    }
  }
}

