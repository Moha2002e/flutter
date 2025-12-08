import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../widgets/back_button.dart';
import '../widgets/form_text_field.dart';
import '../widgets/submit_button.dart';
import '../controllers/cours_controller.dart';
import '../models/cours.dart';

/// Écran pour modifier un cours existant
class ModifierCoursScreen extends StatefulWidget {
  const ModifierCoursScreen({super.key});
  static const String routeName = '/modifier-cours';

  @override
  State<ModifierCoursScreen> createState() => _ModifierCoursScreenState();
}

class _ModifierCoursScreenState extends State<ModifierCoursScreen> {
  late TextEditingController _nomController;
  late TextEditingController _nomProfController;
  late TextEditingController _localController;
  DateTime? _dateCours;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  Cours? _cours;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _cours = ModalRoute.of(context)!.settings.arguments as Cours;
      _nomController = TextEditingController(text: _cours!.nom);
      _nomProfController = TextEditingController(text: _cours!.nomProf);
      _localController = TextEditingController(text: _cours!.local);
      _dateCours = _cours!.date;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _nomProfController.dispose();
    _localController.dispose();
    super.dispose();
  }

  Future<void> _selectionnerDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateCours ?? DateTime.now(),
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
    if (picked != null && picked != _dateCours) {
      setState(() {
        _dateCours = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _cours == null) {
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
                  const Text('Modifier le cours', style: kCreerClubTitleText),
                  const SizedBox(height: kSpacingBeforeForm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormTextField(
                            label: 'Nom du cours',
                            controller: _nomController,
                          ),
                          const SizedBox(height: kSpacingBetweenFields),
                          FormTextField(
                            label: 'Professeur',
                            controller: _nomProfController,
                          ),
                          const SizedBox(height: kSpacingBetweenFields),
                          FormTextField(
                            label: 'Local',
                            controller: _localController,
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
                                _dateCours == null
                                    ? 'Sélectionner une date'
                                    : '${_dateCours!.day.toString().padLeft(2, '0')}/${_dateCours!.month.toString().padLeft(2, '0')}/${_dateCours!.year}',
                                style: kInputTextStyle,
                              ),
                            ),
                          ),
                          const SizedBox(height: kSpacingBeforeButton),
                          SubmitButton(
                            label: 'Enregistrer les modifications',
                            loading: _loading,
                            onPressed: _modifierCours,
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

  Future<void> _modifierCours() async {
    if (_cours == null) return;

    final success = await CoursController.updateCours(
      context: context,
      formKey: _formKey,
      coursId: _cours!.id,
      nom: _nomController.text,
      nomProf: _nomProfController.text,
      local: _localController.text,
      date: _dateCours,
      setLoading: (loading) {
        if (mounted) setState(() => _loading = loading);
      },
    );
    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }
}
