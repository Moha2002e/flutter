import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../widgets/back_button.dart';
import '../widgets/form_text_field.dart';
import '../widgets/submit_button.dart';
import '../controllers/evenement_controller.dart';
import '../models/evenement.dart';

/// Écran pour modifier un événement existant
class ModifierEvenementScreen extends StatefulWidget {
  const ModifierEvenementScreen({super.key});
  static const String routeName = '/modifier-evenement';

  @override
  State<ModifierEvenementScreen> createState() => _ModifierEvenementScreenState();
}

class _ModifierEvenementScreenState extends State<ModifierEvenementScreen> {
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  late TextEditingController _lieuController;
  DateTime? _dateEvenement;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  Evenement? _evenement;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _evenement = ModalRoute.of(context)!.settings.arguments as Evenement;
      _nomController = TextEditingController(text: _evenement!.nom);
      _descriptionController = TextEditingController(text: _evenement!.description);
      _lieuController = TextEditingController(text: _evenement!.lieu);
      _dateEvenement = _evenement!.date;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _lieuController.dispose();
    super.dispose();
  }

  Future<void> _selectionnerDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateEvenement ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kMainButtonColor,
              onPrimary: kWhiteColor,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateEvenement) {
      setState(() {
        _dateEvenement = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _evenement == null) {
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
                  const Text('Modifier l\'événement', style: kCreerClubTitleText),
                  const SizedBox(height: kSpacingBeforeForm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormTextField(
                            label: 'Nom de l\'événement',
                            controller: _nomController,
                          ),
                          const SizedBox(height: kSpacingBetweenFields),
                          FormTextField(
                            label: 'Lieu',
                            controller: _lieuController,
                          ),
                          const SizedBox(height: kSpacingBetweenFields),
                          GestureDetector(
                            onTap: () => _selectionnerDate(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(kInputFieldPadding),
                              decoration: BoxDecoration(
                                color: kWhiteColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(kInputFieldBorderRadius),
                              ),
                              child: Text(
                                _dateEvenement == null
                                    ? 'Sélectionner une date'
                                    : '${_dateEvenement!.day.toString().padLeft(2, '0')}/${_dateEvenement!.month.toString().padLeft(2, '0')}/${_dateEvenement!.year}',
                                style: kInputTextStyle,
                              ),
                            ),
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
                            onPressed: _modifierEvenement,
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

  Future<void> _modifierEvenement() async {
    if (_evenement == null) return;

    final success = await EvenementController.updateEvenement(
      context: context,
      formKey: _formKey,
      evenementId: _evenement!.id,
      nom: _nomController.text,
      description: _descriptionController.text,
      lieu: _lieuController.text,
      date: _dateEvenement,
      setLoading: (loading) {
        if (mounted) setState(() => _loading = loading);
      },
    );
    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }
}
