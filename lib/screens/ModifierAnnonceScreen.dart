import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/sizes.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../widgets/back_button.dart';
import '../widgets/form_text_field.dart';
import '../widgets/date_field.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/submit_button.dart';
import '../controllers/annonce_controller.dart';
import '../models/annonce.dart';
import '../utils/date_utils.dart';

/// Écran pour modifier une annonce existante
class ModifierAnnonceScreen extends StatefulWidget {
  const ModifierAnnonceScreen({super.key});
  static const String routeName = '/modifier-annonce';

  @override
  State<ModifierAnnonceScreen> createState() => _ModifierAnnonceScreenState();
}

class _ModifierAnnonceScreenState extends State<ModifierAnnonceScreen> {
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  Annonce? _annonce;
  DateTime? _selectedDate;
  String? _selectedCategory;
  bool _initialized = false;

  final List<String> _categories = ['Vente', 'Location', 'Emploi', 'Services', 'Autre'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _annonce = ModalRoute.of(context)!.settings.arguments as Annonce;
      _nomController = TextEditingController(text: _annonce!.nom);
      _descriptionController = TextEditingController(text: _annonce!.description);
      _dateController = TextEditingController(
        text: _annonce!.date != null ? AppDateUtils.formatDate(_annonce!.date!) : '',
      );
      _selectedDate = _annonce!.date;
      _selectedCategory = _annonce!.categorie;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _annonce == null) {
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
                  const Text('Modifier l\'annonce', style: kCreerAnnonceTitleText),
                  const SizedBox(height: kSpacingBeforeForm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormTextField(
                            label: 'Nom de l\'annonce',
                            controller: _nomController,
                          ),
                          const SizedBox(height: kSpacingBetweenFields),
                          DateField(
                            label: 'Date',
                            controller: _dateController,
                            onDateSelected: (date) => setState(() => _selectedDate = date),
                          ),
                          const SizedBox(height: kSpacingBetweenFields),
                          DropdownField(
                            label: 'Catégorie',
                            items: _categories,
                            value: _selectedCategory,
                            onChanged: (value) => setState(() => _selectedCategory = value),
                          ),
                          const SizedBox(height: kSpacingBetweenFields),
                          FormTextField(
                            label: 'Description',
                            controller: _descriptionController,
                            maxLines: kCreerAnnonceDescriptionMaxLines,
                          ),
                          const SizedBox(height: kSpacingBeforeButton),
                          SubmitButton(
                            label: 'Enregistrer les modifications',
                            loading: _loading,
                            onPressed: _modifierAnnonce,
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

  Future<void> _modifierAnnonce() async {
    if (_annonce == null) return;
    
    final success = await AnnonceController.updateAnnonce(
      context: context,
      formKey: _formKey,
      annonceId: _annonce!.id,
      nom: _nomController.text,
      description: _descriptionController.text,
      date: _selectedDate,
      categorie: _selectedCategory ?? '',
      setLoading: (loading) {
        if (mounted) setState(() => _loading = loading);
      },
    );
    if (success && context.mounted) {
      Navigator.pop(context, true);
    }
  }
}

