import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../widgets/back_button.dart';
import '../widgets/form_text_field.dart';
import '../widgets/date_field.dart';
import '../widgets/submit_button.dart';
import '../controllers/evenement_controller.dart';
import '../utils/guest_utils.dart';

/// Écran pour créer un nouvel événement
class CreerEvenementScreen extends StatefulWidget {
  const CreerEvenementScreen({super.key});
  static const String routeName = '/creer-evenement';

  @override
  State<CreerEvenementScreen> createState() => _CreerEvenementScreenState();
}

class _CreerEvenementScreenState extends State<CreerEvenementScreen> {
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _lieuController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _lieuController.dispose();
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
                const Text('Ajouter evenement', style: kCreerEvenementTitleText),
                const SizedBox(height: kSpacingBeforeForm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormTextField(label: 'Nom de l\'evenement', controller: _nomController),
                        const SizedBox(height: kSpacingBetweenFields),
                        DateField(
                          label: 'Date',
                          controller: _dateController,
                          onDateSelected: (date) => setState(() => _selectedDate = date),
                        ),
                        const SizedBox(height: kSpacingBetweenFields),
                        FormTextField(label: 'Lieu', controller: _lieuController),
                        const SizedBox(height: kSpacingBetweenFields),
                        FormTextField(
                          label: 'Description',
                          controller: _descriptionController,
                          maxLines: kCreerEvenementDescriptionMaxLines,
                        ),
                        const SizedBox(height: kSpacingBeforeButton),
                        SubmitButton(
                          label: 'Ajouter',
                          loading: _loading,
                          onPressed: _creerEvenement,
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

  Future<void> _creerEvenement() async {
    final success = await EvenementController.createEvenement(
      context: context,
      formKey: _formKey,
      nom: _nomController.text,
      description: _descriptionController.text,
      date: _selectedDate,
      lieu: _lieuController.text,
      setLoading: (loading) {
        if (mounted) setState(() => _loading = loading);
      },
    );
    if (success && context.mounted) Navigator.pop(context);
  }
}


