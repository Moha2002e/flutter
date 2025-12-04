import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/spacings.dart';
import '../styles/texts.dart';
import '../widgets/back_button.dart';
import '../widgets/date_field.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/submit_button.dart';
import '../controllers/cours_controller.dart';
import '../utils/guest_utils.dart';

/// Écran pour créer un nouveau cours
class CreerCoursScreen extends StatefulWidget {
  const CreerCoursScreen({super.key});
  static const String routeName = '/creer-cours';

  @override
  State<CreerCoursScreen> createState() => _CreerCoursScreenState();
}

class _CreerCoursScreenState extends State<CreerCoursScreen> {
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  DateTime? _selectedDate;
  String? _selectedCourse;
  String? _selectedProf;
  String? _selectedLocal;

  final List<String> _courses = [
    'Mathématiques', 'Physique', 'Chimie', 'Informatique',
    'Anglais', 'Français', 'Histoire', 'Géographie',
  ];

  final List<String> _profs = [
    'M. Dupont', 'Mme Martin', 'M. Bernard',
    'Mme Dubois', 'M. Leroy', 'Mme Moreau',
  ];

  final List<String> _locals = [
    'Salle 101', 'Salle 102', 'Salle 201', 'Salle 202',
    'Amphithéâtre A', 'Amphithéâtre B', 'Laboratoire 1', 'Laboratoire 2',
  ];

  @override
  void dispose() {
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
                const Text('Ajouter cours', style: kCreerCoursTitleText),
                const SizedBox(height: kSpacingBeforeForm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kHorizontalPaddingL),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownField(
                          label: 'Nom du cours',
                          items: _courses,
                          value: _selectedCourse,
                          onChanged: (value) => setState(() => _selectedCourse = value),
                        ),
                        const SizedBox(height: kSpacingBetweenFields),
                        DateField(
                          label: 'Date',
                          controller: _dateController,
                          onDateSelected: (date) => setState(() => _selectedDate = date),
                        ),
                        const SizedBox(height: kSpacingBetweenFields),
                        DropdownField(
                          label: 'Nom du prof',
                          items: _profs,
                          value: _selectedProf,
                          onChanged: (value) => setState(() => _selectedProf = value),
                        ),
                        const SizedBox(height: kSpacingBetweenFields),
                        DropdownField(
                          label: 'Local',
                          items: _locals,
                          value: _selectedLocal,
                          onChanged: (value) => setState(() => _selectedLocal = value),
                        ),
                        const SizedBox(height: kSpacingBeforeButton),
                        SubmitButton(
                          label: 'Ajouter',
                          loading: _loading,
                          onPressed: _creerCours,
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

  Future<void> _creerCours() async {
    final success = await CoursController.createCours(
      context: context,
      formKey: _formKey,
      nom: _selectedCourse ?? '',
      date: _selectedDate,
      nomProf: _selectedProf ?? '',
      local: _selectedLocal ?? '',
      setLoading: (loading) {
        if (mounted) setState(() => _loading = loading);
      },
    );
    if (success && context.mounted) Navigator.pop(context);
  }
}


