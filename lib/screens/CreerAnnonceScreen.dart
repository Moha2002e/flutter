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
import '../utils/guest_utils.dart';

/// Écran pour créer une nouvelle annonce
class CreerAnnonceScreen extends StatefulWidget {
  const CreerAnnonceScreen({super.key});
  static const String routeName = '/creer-annonce';

  @override
  State<CreerAnnonceScreen> createState() => _CreerAnnonceScreenState();
}

class _CreerAnnonceScreenState extends State<CreerAnnonceScreen> {
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  DateTime? _selectedDate;
  String? _selectedCategory;

  final List<String> _categories = ['Vente', 'Location', 'Emploi', 'Services', 'Autre'];

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
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
                const Text('Ajouter annonce', style: kCreerAnnonceTitleText),
                const SizedBox(height: kSpacingBeforeForm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormTextField(label: 'Nom de l\'annonce', controller: _nomController),
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
                          label: 'Ajouter',
                          loading: _loading,
                          onPressed: _creerAnnonce,
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

  Future<void> _creerAnnonce() async {
    final success = await AnnonceController.createAnnonce(
      context: context,
      formKey: _formKey,
      nom: _nomController.text,
      description: _descriptionController.text,
      date: _selectedDate,
      categorie: _selectedCategory ?? '',
      setLoading: (loading) {
        if (mounted) setState(() => _loading = loading);
      },
    );
    if (success && context.mounted) Navigator.pop(context);
  }
}


